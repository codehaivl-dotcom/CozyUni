class_name LudoMatch
extends RefCounted

const LudoRulesScript = preload("res://src/modes/cozy_ludo/ludo_rules.gd")

var _config: Dictionary
var _state: Dictionary
var _rng := RandomNumberGenerator.new()
var _roll_provider: Callable
var _seed: int
var _player_count: int


func _init(config: Dictionary, player_count: int, seed_value: int, starting_slot: int = -1, roll_provider: Callable = Callable()) -> void:
	_config = config.duplicate(true)
	_seed = seed_value
	_player_count = player_count
	_roll_provider = roll_provider
	_rng.seed = seed_value

	var allowed: Array = _config.get("player_counts", []) as Array
	assert(player_count in allowed)
	var actual_start := starting_slot
	if actual_start < 0:
		actual_start = _rng.randi_range(0, player_count - 1)
	_state = LudoRulesScript.create_initial_state(_config, player_count, actual_start)
	_state["seed"] = seed_value


func mode_id() -> String:
	return "cozy_ludo"


func supported_player_counts() -> Array:
	return (_config.get("player_counts", []) as Array).duplicate()


func get_public_state() -> Dictionary:
	return _state.duplicate(true)


func get_legal_actions(player_slot: int) -> Array[Dictionary]:
	var actions: Array[Dictionary] = []
	if is_finished() or player_slot != int(_state.get("turn_index", -1)):
		return actions
	var phase := str(_state.get("phase", ""))
	if phase == LudoRulesScript.PHASE_AWAITING_ROLL:
		actions.append({"type": "roll", "player_slot": player_slot})
	elif phase == LudoRulesScript.PHASE_AWAITING_PIECE_SELECTION:
		for piece_index: Variant in _state.get("legal_piece_indices", []):
			actions.append({"type": "select_piece", "player_slot": player_slot, "piece_index": int(piece_index)})
	return actions


func submit_action(action: Dictionary, expected_revision: int) -> Dictionary:
	var current_revision := int(_state.get("revision", 0))
	if expected_revision != current_revision:
		return _reject("STALE_REVISION")
	if is_finished():
		return _reject("MATCH_FINISHED")

	var player_slot := int(action.get("player_slot", -1))
	if player_slot != int(_state.get("turn_index", -1)):
		return _reject("NOT_ACTIVE_PLAYER")

	var action_type := str(action.get("type", ""))
	var events: Array[Dictionary] = []
	match action_type:
		"roll":
			if str(_state.get("phase", "")) != LudoRulesScript.PHASE_AWAITING_ROLL:
				return _reject("ROLL_NOT_ALLOWED")
			events = _handle_roll(player_slot)
		"select_piece":
			if str(_state.get("phase", "")) != LudoRulesScript.PHASE_AWAITING_PIECE_SELECTION:
				return _reject("PIECE_SELECTION_NOT_ALLOWED")
			var piece_index := int(action.get("piece_index", -1))
			var legal: Array = _state.get("legal_piece_indices", []) as Array
			if piece_index not in legal:
				return _reject("ILLEGAL_PIECE")
			events = _handle_piece_selection(player_slot, piece_index)
		_:
			return _reject("UNKNOWN_ACTION")

	_state["revision"] = current_revision + 1
	return {
		"accepted": true,
		"revision": int(_state["revision"]),
		"events": events,
		"state": get_public_state(),
	}


func is_finished() -> bool:
	return str(_state.get("phase", "")) == LudoRulesScript.PHASE_MATCH_END


func get_result_payload() -> Dictionary:
	if not is_finished():
		return {}
	return {
		"game_id": mode_id(),
		"winner_slot": int(_state.get("winner_slot", -1)),
		"ranking": (_state.get("ranking", []) as Array).duplicate(true),
		"key_stat": "pieces_home",
	}


func get_rematch_config() -> Dictionary:
	return {
		"game_id": mode_id(),
		"player_count": _player_count,
		"starting_player_slot": (int(_state.get("starting_player_slot", 0)) + 1) % _player_count,
	}


func serialize_debug_state() -> Dictionary:
	return _state.duplicate(true)


func _handle_roll(player_slot: int) -> Array[Dictionary]:
	var events: Array[Dictionary] = []
	var roll := _next_roll()
	var was_bonus := bool(_state.get("bonus_roll_pending", false))
	_state["bonus_roll_pending"] = false
	_state["roll_is_bonus"] = was_bonus
	_state["last_roll"] = roll
	var legal := LudoRulesScript.get_legal_piece_indices(_state, _config, player_slot, roll)
	_state["legal_piece_indices"] = legal
	events.append({"type": "dice_rolled", "player_slot": player_slot, "roll": roll, "bonus": was_bonus})

	if legal.is_empty():
		events.append({
			"type": "no_legal_move",
			"player_slot": player_slot,
			"toast_seconds": float((_config.get("no_legal_move", {}) as Dictionary).get("toast_seconds", 0.8)),
		})
		_end_turn()
		return events

	_state["phase"] = LudoRulesScript.PHASE_AWAITING_PIECE_SELECTION
	return events


func _handle_piece_selection(player_slot: int, piece_index: int) -> Array[Dictionary]:
	var roll := int(_state.get("last_roll", 0))
	var was_bonus_roll := bool(_state.get("roll_is_bonus", false))
	var events := LudoRulesScript.apply_piece_move(_state, _config, player_slot, piece_index, roll)
	_state["legal_piece_indices"] = []

	if is_finished():
		return events

	var bonus_config := _config.get("bonus_roll", {}) as Dictionary
	var trigger := int(bonus_config.get("trigger_original_roll", 6))
	var bonus_used := bool(_state.get("bonus_used_this_turn", false))
	var can_bonus := (
		roll == trigger
		and not was_bonus_roll
		and not bonus_used
		and int(bonus_config.get("max_bonus_rolls_per_turn", 1)) > 0
	)
	if can_bonus:
		_state["bonus_used_this_turn"] = true
		_state["bonus_roll_pending"] = true
		_state["roll_is_bonus"] = false
		_state["last_roll"] = 0
		_state["phase"] = LudoRulesScript.PHASE_AWAITING_ROLL
		events.append({"type": "bonus_roll_granted", "player_slot": player_slot})
		return events

	_end_turn()
	return events


func _end_turn() -> void:
	var next_slot := (int(_state.get("turn_index", 0)) + 1) % _player_count
	_state["turn_index"] = next_slot
	_state["phase"] = LudoRulesScript.PHASE_AWAITING_ROLL
	_state["last_roll"] = 0
	_state["roll_is_bonus"] = false
	_state["bonus_roll_pending"] = false
	_state["bonus_used_this_turn"] = false
	_state["legal_piece_indices"] = []
	_state["turn_number"] = int(_state.get("turn_number", 1)) + 1


func _next_roll() -> int:
	var sides := int((_config.get("dice", {}) as Dictionary).get("sides", 6))
	if _roll_provider.is_valid():
		var provided := int(_roll_provider.call())
		assert(provided >= 1 and provided <= sides)
		return provided
	return _rng.randi_range(1, sides)


func _reject(reason: String) -> Dictionary:
	return {
		"accepted": false,
		"reason": reason,
		"revision": int(_state.get("revision", 0)),
	}
