extends SceneTree

const LudoRulesScript = preload("res://src/modes/cozy_ludo/ludo_rules.gd")
const LudoMatchScript = preload("res://src/modes/cozy_ludo/ludo_match.gd")
const CONFIG_PATH := "res://data/games/ludo_v1.json"

class RollQueue:
	extends RefCounted
	var values: Array[int] = []
	var index := 0

	func _init(input_values: Array[int]) -> void:
		values = input_values.duplicate()

	func next_roll() -> int:
		assert(index < values.size())
		var value := values[index]
		index += 1
		return value


var _failures := 0
var _config: Dictionary = {}


func _initialize() -> void:
	_config = _load_config()
	if _config.is_empty():
		quit(1)
		return

	_test_initial_state()
	_test_yard_deploy_and_own_destination()
	_test_safe_cell_no_capture()
	_test_non_safe_capture()
	_test_finish_clamp_and_win()
	_test_ranking_and_shared_rank()
	_test_match_revision_bonus_and_no_chain()
	_test_no_legal_move_auto_turn_end()
	_test_determinism()
	_test_rematch_rotates_original_start()

	if _failures > 0:
		push_error("Cozy Ludo rule acceptance FAILED: %d invariant(s)" % _failures)
		quit(1)
		return
	print("Cozy Ludo rule acceptance PASS")
	quit(0)


func _test_initial_state() -> void:
	for player_count in [2, 3, 4]:
		var state := LudoRulesScript.create_initial_state(_config, player_count, player_count - 1)
		_expect(int(state["starting_player_slot"]) == player_count - 1, "initial starting slot recorded for %dP" % player_count)
		_expect(int(state["turn_index"]) == player_count - 1, "initial turn matches starting slot for %dP" % player_count)
		var players: Array = state["players"] as Array
		_expect(players.size() == player_count, "initial player count %d" % player_count)
		for player_value: Variant in players:
			var pieces: Array = (player_value as Dictionary)["pieces"] as Array
			_expect(pieces == [1, 0, 0], "each player starts one active + two yard")


func _test_yard_deploy_and_own_destination() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 2, 0)
	_expect(not LudoRulesScript.is_piece_move_legal(state, _config, 0, 1, 5), "yard piece cannot deploy without six")
	_expect(LudoRulesScript.is_piece_move_legal(state, _config, 0, 1, 6), "yard piece deploys on six when start free")

	var players: Array = state["players"] as Array
	var p0 := players[0] as Dictionary
	p0["pieces"] = [1, 3, 0]
	players[0] = p0
	state["players"] = players
	_expect(not LudoRulesScript.is_piece_move_legal(state, _config, 0, 0, 2), "own destination occupancy blocks move")

	p0["pieces"] = [1, 0, 0]
	players[0] = p0
	state["players"] = players
	var events := LudoRulesScript.apply_piece_move(state, _config, 0, 1, 6)
	_expect(int(((state["players"] as Array)[0] as Dictionary)["pieces"][1]) == 0, "deploy remains illegal when own start occupied")
	_expect(events.is_empty(), "illegal deploy emits no move event")


func _test_safe_cell_no_capture() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 2, 0)
	var players: Array = state["players"] as Array
	var p0 := players[0] as Dictionary
	var p1 := players[1] as Dictionary
	p0["pieces"] = [7, 0, 0]
	p1["pieces"] = [48, 0, 0]
	players[0] = p0
	players[1] = p1
	state["players"] = players

	var events := LudoRulesScript.apply_piece_move(state, _config, 0, 0, 2)
	_expect(LudoRulesScript.absolute_cell(_config, 0, 9) == 8, "safe test lands on absolute star cell 8")
	_expect(int(((state["players"] as Array)[1] as Dictionary)["pieces"][0]) == 48, "enemy remains on safe destination")
	_expect(not _has_event(events, "piece_captured"), "safe landing emits no capture")


func _test_non_safe_capture() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 2, 0)
	var players: Array = state["players"] as Array
	var p0 := players[0] as Dictionary
	var p1 := players[1] as Dictionary
	p0["pieces"] = [1, 0, 0]
	p1["pieces"] = [41, 0, 0]
	players[0] = p0
	players[1] = p1
	state["players"] = players

	var events := LudoRulesScript.apply_piece_move(state, _config, 0, 0, 1)
	_expect(LudoRulesScript.absolute_cell(_config, 0, 2) == 1, "capture test moving piece lands absolute cell 1")
	_expect(LudoRulesScript.absolute_cell(_config, 1, 41) == 1, "capture test enemy occupies same non-safe cell")
	_expect(int(((state["players"] as Array)[1] as Dictionary)["pieces"][0]) == 0, "captured enemy returns to yard")
	_expect(int(((state["players"] as Array)[0] as Dictionary)["captures_made"]) == 1, "capture counter increments")
	_expect(_has_event(events, "piece_captured"), "capture event emitted")


func _test_finish_clamp_and_win() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 2, 0)
	var players: Array = state["players"] as Array
	var p0 := players[0] as Dictionary
	p0["pieces"] = [58, 58, 56]
	players[0] = p0
	state["players"] = players

	var events := LudoRulesScript.apply_piece_move(state, _config, 0, 2, 6)
	_expect(int(((state["players"] as Array)[0] as Dictionary)["pieces"][2]) == 58, "finish overshoot clamps to Home 58")
	_expect(str(state["phase"]) == LudoRulesScript.PHASE_MATCH_END, "third home piece ends match immediately")
	_expect(int(state["winner_slot"]) == 0, "winner slot recorded")
	_expect(_has_event(events, "match_won"), "match win event emitted")
	var ranking: Array = state["ranking"] as Array
	_expect(int((ranking[0] as Dictionary)["slot"]) == 0 and int((ranking[0] as Dictionary)["rank"]) == 1, "winner is rank one")


func _test_ranking_and_shared_rank() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 3, 0)
	state["winner_slot"] = 0
	var players: Array = state["players"] as Array
	var p0 := players[0] as Dictionary
	var p1 := players[1] as Dictionary
	var p2 := players[2] as Dictionary
	p0["pieces"] = [58, 58, 58]
	p0["captures_made"] = 0
	p1["pieces"] = [58, 10, 0]
	p1["captures_made"] = 2
	p2["pieces"] = [58, 10, 0]
	p2["captures_made"] = 2
	players[0] = p0
	players[1] = p1
	players[2] = p2
	state["players"] = players
	var ranking := LudoRulesScript.compute_ranking(state, _config)
	_expect(int(ranking[0]["slot"]) == 0, "winner stays first in final ranking")
	_expect(int(ranking[1]["rank"]) == int(ranking[2]["rank"]), "identical remaining metrics share rank")
	_expect(bool(ranking[2]["shared_rank"]), "shared-rank marker emitted")


func _test_match_revision_bonus_and_no_chain() -> void:
	var queue := RollQueue.new([6, 6])
	var match_obj = LudoMatchScript.new(_config, 2, 1234, 0, Callable(queue, "next_roll"))
	var roll_result: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 0)
	_expect(bool(roll_result["accepted"]), "original six roll accepted")
	_expect(int(roll_result["revision"]) == 1, "accepted roll increments revision once")
	var stale: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 0)
	_expect(not bool(stale["accepted"]) and str(stale["reason"]) == "STALE_REVISION", "stale duplicate action rejected")

	var move_result: Dictionary = match_obj.submit_action({"type": "select_piece", "player_slot": 0, "piece_index": 0}, 1)
	_expect(bool(move_result["accepted"]), "legal move after six accepted")
	var after_move: Dictionary = move_result["state"]
	_expect(int(after_move["turn_index"]) == 0, "successful original six keeps same player for one bonus roll")
	_expect(str(after_move["phase"]) == LudoRulesScript.PHASE_AWAITING_ROLL, "bonus returns to awaiting roll")
	_expect(_has_event(move_result["events"], "bonus_roll_granted"), "bonus grant event emitted")

	var bonus_roll: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 2)
	_expect(bool(bonus_roll["accepted"]), "bonus six roll accepted")
	var bonus_move: Dictionary = match_obj.submit_action({"type": "select_piece", "player_slot": 0, "piece_index": 0}, 3)
	_expect(bool(bonus_move["accepted"]), "bonus-roll move accepted")
	var final_state: Dictionary = bonus_move["state"]
	_expect(int(final_state["turn_index"]) == 1, "bonus roll cannot chain another bonus")
	_expect(not _has_event(bonus_move["events"], "bonus_roll_granted"), "bonus six emits no second bonus")


func _test_no_legal_move_auto_turn_end() -> void:
	var queue := RollQueue.new([5])
	var match_obj = LudoMatchScript.new(_config, 2, 99, 0, Callable(queue, "next_roll"))
	match_obj._state["players"][0]["pieces"] = [0, 0, 0]
	var result: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 0)
	_expect(bool(result["accepted"]), "no-move roll still resolves as accepted action")
	_expect(_has_event(result["events"], "no_legal_move"), "no legal move emits toast event")
	_expect(int(result["state"]["turn_index"]) == 1, "no legal move automatically ends turn")
	_expect(str(result["state"]["phase"]) == LudoRulesScript.PHASE_AWAITING_ROLL, "next player awaits roll")


func _test_determinism() -> void:
	var match_a = LudoMatchScript.new(_config, 3, 777, 0)
	var match_b = LudoMatchScript.new(_config, 3, 777, 0)
	for step in range(12):
		var state_a: Dictionary = match_a.get_public_state()
		var state_b: Dictionary = match_b.get_public_state()
		_expect(JSON.stringify(state_a) == JSON.stringify(state_b), "same seed/actions produce same state at step %d" % step)
		if match_a.is_finished():
			break
		var active := int(state_a["turn_index"])
		var actions: Array[Dictionary] = match_a.get_legal_actions(active)
		_expect(not actions.is_empty(), "determinism sequence exposes a legal semantic action")
		if actions.is_empty():
			break
		var action := actions[0].duplicate(true)
		var result_a: Dictionary = match_a.submit_action(action, int(state_a["revision"]))
		var result_b: Dictionary = match_b.submit_action(action, int(state_b["revision"]))
		_expect(bool(result_a["accepted"]) and bool(result_b["accepted"]), "mirrored deterministic action accepted")


func _test_rematch_rotates_original_start() -> void:
	var match_obj = LudoMatchScript.new(_config, 4, 1, 2)
	match_obj._state["turn_index"] = 0
	var rematch: Dictionary = match_obj.get_rematch_config()
	_expect(int(rematch["starting_player_slot"]) == 3, "rematch rotates from original starting slot, not current/winner slot")


func _load_config() -> Dictionary:
	if not FileAccess.file_exists(CONFIG_PATH):
		push_error("Missing Ludo runtime config: %s" % CONFIG_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(CONFIG_PATH))
	if not (parsed is Dictionary):
		push_error("Invalid Ludo runtime config")
		return {}
	return parsed as Dictionary


func _has_event(events_value: Variant, event_type: String) -> bool:
	if not (events_value is Array):
		return false
	for event_value: Variant in events_value:
		if event_value is Dictionary and str((event_value as Dictionary).get("type", "")) == event_type:
			return true
	return false


func _expect(condition: bool, description: String) -> void:
	if condition:
		return
	_failures += 1
	push_error("Ludo invariant failed: %s" % description)
