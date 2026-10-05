extends SceneTree

const LudoRulesScript = preload("res://src/modes/cozy_ludo/ludo_rules.gd")
const LudoMatchScript = preload("res://src/modes/cozy_ludo/ludo_match.gd")
const CONFIG_PATH := "res://data/games/ludo_v1.json"

class RollQueue:
	var values: Array = []
	var index := 0

	func _init(source: Array) -> void:
		values = source.duplicate()

	func next_roll() -> int:
		assert(index < values.size())
		var result := int(values[index])
		index += 1
		return result


var _config: Dictionary = {}
var _failures := 0


func _initialize() -> void:
	_config = _load_config()
	if _config.is_empty():
		push_error("Ludo acceptance FAILED: runtime config missing")
		quit(1)
		return

	_test_all_outer_loop_transitions()
	_test_home_lane_entry_all_players()
	_test_safe_cell_never_captures()
	_test_non_safe_capture_returns_to_yard()
	_test_own_destination_is_illegal()
	_test_only_six_deploys_yard_piece()
	_test_one_bonus_roll_maximum()
	_test_no_legal_move_auto_ends_turn()
	_test_overshoot_clamps_to_home_and_wins()
	_test_revision_rejects_duplicate_submission()
	_test_seeded_match_is_deterministic()
	_test_ranking_is_deterministic()
	_test_rematch_rotates_starting_slot()

	if _failures > 0:
		push_error("Ludo acceptance FAILED: %d invariant(s)" % _failures)
		quit(1)
		return
	print("Ludo acceptance PASS")
	quit(0)


func _load_config() -> Dictionary:
	if not FileAccess.file_exists(CONFIG_PATH):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(CONFIG_PATH))
	return parsed as Dictionary if parsed is Dictionary else {}


func _test_all_outer_loop_transitions() -> void:
	var starts: Array = (_config.get("board", {}) as Dictionary).get("start_indices", []) as Array
	var loop_cells := int((_config.get("board", {}) as Dictionary).get("outer_loop_cells", 52))
	for slot in range(starts.size()):
		for progress in range(1, loop_cells + 1):
			var expected := (int(starts[slot]) + progress - 1) % loop_cells
			_expect(LudoRulesScript.absolute_cell(_config, slot, progress) == expected, "outer loop mapping slot=%d progress=%d" % [slot, progress])


func _test_home_lane_entry_all_players() -> void:
	for slot in range(4):
		var state := LudoRulesScript.create_initial_state(_config, 4, slot)
		_set_piece(state, slot, 0, 52)
		var legal := LudoRulesScript.get_legal_piece_indices(state, _config, slot, 1)
		_expect(0 in legal, "home lane entry legal for slot %d" % slot)
		LudoRulesScript.apply_piece_move(state, _config, slot, 0, 1)
		_expect(_piece(state, slot, 0) == 53, "home lane entry progress=53 for slot %d" % slot)


func _test_safe_cell_never_captures() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 2, 0)
	_set_all_pieces(state, 0, [8, 0, 0])
	var enemy_progress := _progress_for_absolute(1, 8)
	_set_all_pieces(state, 1, [enemy_progress, 0, 0])
	LudoRulesScript.apply_piece_move(state, _config, 0, 0, 1)
	_expect(_piece(state, 0, 0) == 9, "mover lands on safe global cell 8")
	_expect(_piece(state, 1, 0) == enemy_progress, "enemy remains on safe cell")
	_expect(_captures(state, 0) == 0, "safe cell grants no capture")


func _test_non_safe_capture_returns_to_yard() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 2, 0)
	_set_all_pieces(state, 0, [5, 0, 0])
	var enemy_progress := _progress_for_absolute(1, 5)
	_set_all_pieces(state, 1, [enemy_progress, 0, 0])
	LudoRulesScript.apply_piece_move(state, _config, 0, 0, 1)
	_expect(LudoRulesScript.absolute_cell(_config, 0, _piece(state, 0, 0)) == 5, "mover lands on non-safe target")
	_expect(_piece(state, 1, 0) == 0, "captured enemy returns to Yard")
	_expect(_captures(state, 0) == 1, "capture stat increments")


func _test_own_destination_is_illegal() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 2, 0)
	_set_all_pieces(state, 0, [1, 2, 0])
	var legal := LudoRulesScript.get_legal_piece_indices(state, _config, 0, 1)
	_expect(0 not in legal, "own occupied destination blocks move")
	_expect(1 in legal, "other unblocked piece remains legal")


func _test_only_six_deploys_yard_piece() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 2, 0)
	_set_all_pieces(state, 0, [2, 0, 0])
	var legal_five := LudoRulesScript.get_legal_piece_indices(state, _config, 0, 5)
	var legal_six := LudoRulesScript.get_legal_piece_indices(state, _config, 0, 6)
	_expect(1 not in legal_five and 2 not in legal_five, "yard pieces do not deploy on 5")
	_expect(1 in legal_six and 2 in legal_six, "yard pieces deploy on 6 when Start is free")


func _test_one_bonus_roll_maximum() -> void:
	var queue := RollQueue.new([6, 6])
	var match_obj = LudoMatchScript.new(_config, 2, 1001, 0, Callable(queue, "next_roll"))
	var result: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 0)
	_expect(bool(result.get("accepted", false)), "original 6 accepted")
	result = match_obj.submit_action({"type": "select_piece", "player_slot": 0, "piece_index": 0}, 1)
	var after_original: Dictionary = result.get("state", {}) as Dictionary
	_expect(int(after_original.get("turn_index", -1)) == 0, "successful original 6 keeps same player")
	_expect(str(after_original.get("phase", "")) == LudoRulesScript.PHASE_AWAITING_ROLL, "bonus roll becomes awaiting roll")
	result = match_obj.submit_action({"type": "roll", "player_slot": 0}, 2)
	_expect(bool(result.get("accepted", false)), "bonus 6 accepted")
	var legal: Array = (result.get("state", {}) as Dictionary).get("legal_piece_indices", []) as Array
	_expect(not legal.is_empty(), "bonus roll has a legal move")
	result = match_obj.submit_action({"type": "select_piece", "player_slot": 0, "piece_index": int(legal[0])}, 3)
	var after_bonus: Dictionary = result.get("state", {}) as Dictionary
	_expect(int(after_bonus.get("turn_index", -1)) == 1, "bonus 6 cannot chain another bonus")


func _test_no_legal_move_auto_ends_turn() -> void:
	var queue := RollQueue.new([5])
	var match_obj = LudoMatchScript.new(_config, 2, 1002, 0, Callable(queue, "next_roll"))
	var state := match_obj.serialize_debug_state()
	_set_all_pieces(state, 0, [0, 0, 0])
	match_obj._state = state
	var result: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 0)
	var next_state: Dictionary = result.get("state", {}) as Dictionary
	_expect(bool(result.get("accepted", false)), "no-move roll is an accepted action")
	_expect(int(next_state.get("turn_index", -1)) == 1, "no legal move auto-ends turn")
	_expect(str(next_state.get("phase", "")) == LudoRulesScript.PHASE_AWAITING_ROLL, "next player awaits roll")
	_expect(_events_contain(result.get("events", []) as Array, "no_legal_move"), "no legal move event emitted")


func _test_overshoot_clamps_to_home_and_wins() -> void:
	var queue := RollQueue.new([6])
	var match_obj = LudoMatchScript.new(_config, 2, 1003, 0, Callable(queue, "next_roll"))
	var state := match_obj.serialize_debug_state()
	_set_all_pieces(state, 0, [58, 58, 57])
	match_obj._state = state
	var roll_result: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 0)
	var legal: Array = (roll_result.get("state", {}) as Dictionary).get("legal_piece_indices", []) as Array
	_expect(2 in legal, "progress 57 may finish with overshoot")
	var move_result: Dictionary = match_obj.submit_action({"type": "select_piece", "player_slot": 0, "piece_index": 2}, 1)
	var end_state: Dictionary = move_result.get("state", {}) as Dictionary
	_expect(_piece(end_state, 0, 2) == 58, "overshoot clamps to Home 58")
	_expect(match_obj.is_finished(), "third home piece ends match immediately")
	_expect(int(end_state.get("winner_slot", -1)) == 0, "first player with all pieces home wins")


func _test_revision_rejects_duplicate_submission() -> void:
	var queue := RollQueue.new([4])
	var match_obj = LudoMatchScript.new(_config, 2, 1004, 0, Callable(queue, "next_roll"))
	var first: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 0)
	_expect(bool(first.get("accepted", false)) and int(first.get("revision", -1)) == 1, "accepted action increments revision once")
	var duplicate: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 0)
	_expect(not bool(duplicate.get("accepted", true)), "duplicate stale action rejected")
	_expect(str(duplicate.get("reason", "")) == "STALE_REVISION", "stale action reports structured reason")


func _test_seeded_match_is_deterministic() -> void:
	var a = LudoMatchScript.new(_config, 4, 998877)
	var b = LudoMatchScript.new(_config, 4, 998877)
	_expect(JSON.stringify(a.serialize_debug_state()) == JSON.stringify(b.serialize_debug_state()), "same seed creates same initial state")
	for _step in range(20):
		if a.is_finished() or b.is_finished():
			break
		var state_a: Dictionary = a.get_public_state()
		var state_b: Dictionary = b.get_public_state()
		_expect(JSON.stringify(state_a) == JSON.stringify(state_b), "same seed remains deterministic before action")
		var slot := int(state_a.get("turn_index", -1))
		var actions_a := a.get_legal_actions(slot)
		var actions_b := b.get_legal_actions(slot)
		_expect(JSON.stringify(actions_a) == JSON.stringify(actions_b), "same state exposes same legal actions")
		if actions_a.is_empty():
			break
		var action: Dictionary = actions_a[0]
		var revision := int(state_a.get("revision", 0))
		var result_a: Dictionary = a.submit_action(action, revision)
		var result_b: Dictionary = b.submit_action(action, revision)
		_expect(JSON.stringify(result_a) == JSON.stringify(result_b), "same seed + same action produces same transition")


func _test_ranking_is_deterministic() -> void:
	var state := LudoRulesScript.create_initial_state(_config, 4, 0)
	_set_all_pieces(state, 0, [58, 58, 58])
	_set_all_pieces(state, 1, [58, 30, 0])
	_set_all_pieces(state, 2, [58, 30, 0])
	_set_all_pieces(state, 3, [20, 10, 0])
	state["winner_slot"] = 0
	var first := LudoRulesScript.compute_ranking(state, _config)
	var second := LudoRulesScript.compute_ranking(state, _config)
	_expect(JSON.stringify(first) == JSON.stringify(second), "ranking output deterministic")
	_expect(int(first[0].get("slot", -1)) == 0 and int(first[0].get("rank", -1)) == 1, "winner always rank 1")
	_expect(int(first[1].get("rank", -1)) == int(first[2].get("rank", -2)), "fully tied players share rank")


func _test_rematch_rotates_starting_slot() -> void:
	var match_obj = LudoMatchScript.new(_config, 4, 1005, 2)
	var rematch := match_obj.get_rematch_config()
	_expect(int(rematch.get("starting_player_slot", -1)) == 3, "rematch rotates starting slot 2 -> 3")
	var wrap_match = LudoMatchScript.new(_config, 4, 1006, 3)
	var wrap := wrap_match.get_rematch_config()
	_expect(int(wrap.get("starting_player_slot", -1)) == 0, "rematch starting slot wraps 3 -> 0")


func _progress_for_absolute(player_slot: int, absolute: int) -> int:
	for progress in range(1, 53):
		if LudoRulesScript.absolute_cell(_config, player_slot, progress) == absolute:
			return progress
	return -1


func _set_piece(state: Dictionary, player_slot: int, piece_index: int, progress: int) -> void:
	var players: Array = state.get("players", []) as Array
	var player: Dictionary = players[player_slot] as Dictionary
	var pieces: Array = player.get("pieces", []) as Array
	pieces[piece_index] = progress
	player["pieces"] = pieces
	players[player_slot] = player
	state["players"] = players


func _set_all_pieces(state: Dictionary, player_slot: int, values: Array) -> void:
	var players: Array = state.get("players", []) as Array
	var player: Dictionary = players[player_slot] as Dictionary
	player["pieces"] = values.duplicate()
	players[player_slot] = player
	state["players"] = players


func _piece(state: Dictionary, player_slot: int, piece_index: int) -> int:
	var players: Array = state.get("players", []) as Array
	var pieces: Array = (players[player_slot] as Dictionary).get("pieces", []) as Array
	return int(pieces[piece_index])


func _captures(state: Dictionary, player_slot: int) -> int:
	var players: Array = state.get("players", []) as Array
	return int((players[player_slot] as Dictionary).get("captures_made", 0))


func _events_contain(events: Array, event_type: String) -> bool:
	for event_value: Variant in events:
		if event_value is Dictionary and str((event_value as Dictionary).get("type", "")) == event_type:
			return true
	return false


func _expect(condition: bool, description: String) -> void:
	if condition:
		return
	_failures += 1
	push_error("Ludo invariant failed: %s" % description)
