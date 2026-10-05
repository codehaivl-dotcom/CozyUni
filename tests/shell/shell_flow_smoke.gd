extends SceneTree

const ShellFlowScript = preload("res://src/app/shell_flow.gd")

var _failures := 0


func _initialize() -> void:
	var flow = ShellFlowScript.new()
	_expect(flow.current_route == "boot", "starts at boot")
	_expect(not flow.transition("match"), "rejects boot -> match")
	_expect(flow.transition("game_library"), "boot -> library")
	_expect(flow.transition("game_start"), "library -> start")
	_expect(flow.transition("local_player_setup"), "start -> setup")
	_expect(flow.transition("match_summary"), "setup -> summary")
	_expect(flow.transition("tutorial"), "summary -> tutorial")
	_expect(flow.transition("countdown"), "tutorial -> countdown")
	_expect(flow.transition("match"), "countdown -> match")
	_expect(flow.transition("final_results"), "match -> results")
	_expect(flow.transition("local_player_setup"), "results -> change players")
	_expect(flow.transition("match_summary"), "setup -> summary again")
	_expect(flow.transition("countdown"), "summary -> countdown after tutorial complete")
	_expect(flow.transition("match"), "countdown -> rematch")
	_expect(flow.transition("settings"), "match -> settings")
	_expect(flow.transition("match"), "settings -> match")
	_expect(flow.transition("final_results"), "match -> final results")
	_expect(flow.transition("game_library"), "results -> library")

	if _failures > 0:
		push_error("shell flow smoke FAILED: %d invariant(s)" % _failures)
		quit(1)
		return
	print("shell flow smoke PASS")
	quit(0)


func _expect(condition: bool, description: String) -> void:
	if condition:
		return
	_failures += 1
	push_error("shell flow invariant failed: %s" % description)
