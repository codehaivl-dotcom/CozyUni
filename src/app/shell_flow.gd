class_name ShellFlow
extends RefCounted

const BOOT := "boot"
const GAME_LIBRARY := "game_library"
const GAME_START := "game_start"
const LOCAL_PLAYER_SETUP := "local_player_setup"
const MATCH_SUMMARY := "match_summary"
const TUTORIAL := "tutorial"
const COUNTDOWN := "countdown"
const MATCH := "match"
const FINAL_RESULTS := "final_results"
const SETTINGS := "settings"

const _ALLOWED: Dictionary = {
	BOOT: [GAME_LIBRARY],
	GAME_LIBRARY: [GAME_START, SETTINGS],
	GAME_START: [GAME_LIBRARY, LOCAL_PLAYER_SETUP, TUTORIAL, SETTINGS],
	LOCAL_PLAYER_SETUP: [GAME_START, MATCH_SUMMARY],
	MATCH_SUMMARY: [LOCAL_PLAYER_SETUP, TUTORIAL, COUNTDOWN],
	TUTORIAL: [GAME_START, MATCH_SUMMARY, COUNTDOWN, MATCH],
	COUNTDOWN: [MATCH],
	MATCH: [FINAL_RESULTS, GAME_START, TUTORIAL, SETTINGS, COUNTDOWN],
	FINAL_RESULTS: [COUNTDOWN, LOCAL_PLAYER_SETUP, GAME_LIBRARY],
	SETTINGS: [GAME_LIBRARY, GAME_START, MATCH],
}

var current_route: String = BOOT


func reset() -> void:
	current_route = BOOT


func can_transition(next_route: String) -> bool:
	var allowed: Variant = _ALLOWED.get(current_route, [])
	return allowed is Array and next_route in (allowed as Array)


func transition(next_route: String) -> bool:
	if not can_transition(next_route):
		return false
	current_route = next_route
	return true


func is_known_route(route_id: String) -> bool:
	return _ALLOWED.has(route_id)
