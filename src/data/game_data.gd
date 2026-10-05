extends Node

const SHELL_CONFIG_PATH := "res://data/app_shell_v1.json"
const GAME_CONFIG_PATHS: Dictionary = {
	"cozy_ludo": "res://data/games/ludo_v1.json",
	"cozy_caro": "res://data/games/caro_v1.json",
	"cozy_journey": "res://data/games/journey_v1.json",
	"cozy_chess": "res://data/games/chess_v1.json",
	"cozy_tycoon": "res://data/games/tycoon_v1.json",
}

var _shell: Dictionary = {}
var _games: Dictionary = {}
var _load_errors: PackedStringArray = PackedStringArray()


func _ready() -> void:
	load_all()


func load_all() -> bool:
	_shell.clear()
	_games.clear()
	_load_errors.clear()

	var shell_parsed: Variant = _load_json(SHELL_CONFIG_PATH)
	if shell_parsed is Dictionary:
		_shell = shell_parsed
	else:
		_load_errors.append("shell:%s" % SHELL_CONFIG_PATH)

	for game_id: String in GAME_CONFIG_PATHS.keys():
		var path: String = GAME_CONFIG_PATHS[game_id]
		var parsed: Variant = _load_json(path)
		if parsed is Dictionary:
			_games[game_id] = parsed
		else:
			_load_errors.append("%s:%s" % [game_id, path])

	return _load_errors.is_empty()


func has_game(game_id: String) -> bool:
	return _games.has(game_id)


func get_game(game_id: String) -> Dictionary:
	if not _games.has(game_id):
		push_error("GameData: unknown game id '%s'" % game_id)
		return {}
	return (_games[game_id] as Dictionary).duplicate(true)


func get_game_ids() -> PackedStringArray:
	var ids := PackedStringArray()
	for game_id: String in GAME_CONFIG_PATHS.keys():
		if _games.has(game_id):
			ids.append(game_id)
	return ids


func get_available_game_ids() -> PackedStringArray:
	var ids := PackedStringArray()
	var configured: Variant = _shell.get("available_game_ids", [])
	if not (configured is Array):
		push_error("GameData: shell available_game_ids must be an array")
		return ids
	for value: Variant in configured:
		var game_id := str(value)
		if _games.has(game_id):
			ids.append(game_id)
		else:
			push_error("GameData: shell exposes unknown game id '%s'" % game_id)
	return ids


func get_game_metadata(game_id: String) -> Dictionary:
	var games_meta: Variant = _shell.get("games", {})
	if not (games_meta is Dictionary):
		push_error("GameData: shell games metadata is malformed")
		return {}
	var metadata: Variant = (games_meta as Dictionary).get(game_id, {})
	if not (metadata is Dictionary):
		push_error("GameData: missing shell metadata for '%s'" % game_id)
		return {}
	return (metadata as Dictionary).duplicate(true)


func get_avatar_roster() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var configured: Variant = _shell.get("avatar_roster", [])
	if not (configured is Array):
		push_error("GameData: avatar_roster must be an array")
		return result
	for value: Variant in configured:
		if value is Dictionary:
			result.append((value as Dictionary).duplicate(true))
	return result


func get_load_errors() -> PackedStringArray:
	return _load_errors.duplicate()


func _load_json(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		push_error("GameData: missing runtime JSON at %s" % path)
		return null

	var text: String = FileAccess.get_file_as_string(path)
	var parsed: Variant = JSON.parse_string(text)
	if parsed == null:
		push_error("GameData: invalid JSON at %s" % path)
		return null
	return parsed
