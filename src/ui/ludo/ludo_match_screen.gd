class_name LudoMatchScreen
extends BaseShellScreen

signal pause_requested
signal match_finished(result: Dictionary)

const LudoMatchScript = preload("res://src/modes/cozy_ludo/ludo_match.gd")
const LudoBoardViewScript = preload("res://src/ui/ludo/ludo_board_view.gd")

var _session: Dictionary = {}
var _config: Dictionary = {}
var _match
var _board: Control
var _status_label: Label
var _roll_label: Label
var _action_button: Button
var _toast_label: Label
var _players_box: VBoxContainer
var _input_locked := false


func configure(session_data: Dictionary) -> void:
	_session = session_data.duplicate(true)
	_config = GameData.get_game("cozy_ludo")
	var player_count := int(_session.get("player_count", 4))
	var seed_value := int(_session.get("match_seed", 0))
	var starting_slot := int(_session.get("starting_player_slot", 0))
	_match = LudoMatchScript.new(_config, player_count, seed_value, starting_slot)


func _ready() -> void:
	var body := page_vbox()
	var top := HBoxContainer.new()
	top.add_child(button("PAUSE", func() -> void: pause_requested.emit()))
	var title := label("Cozy Ludo", 24)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top.add_child(title)
	_roll_label = label("Roll —", 20, HORIZONTAL_ALIGNMENT_RIGHT)
	top.add_child(_roll_label)
	body.add_child(top)

	var split := HBoxContainer.new()
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	split.add_theme_constant_override("separation", 24)
	body.add_child(split)

	_board = LudoBoardViewScript.new()
	_board.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_board.configure(_config, _match.get_public_state())
	_board.piece_selected.connect(_on_piece_selected)
	split.add_child(_board)

	var hud := VBoxContainer.new()
	hud.custom_minimum_size = Vector2(310, 0)
	hud.add_theme_constant_override("separation", 14)
	split.add_child(hud)

	_status_label = wrapped_label("", 22, HORIZONTAL_ALIGNMENT_CENTER)
	hud.add_child(_status_label)
	_toast_label = wrapped_label("", 16, HORIZONTAL_ALIGNMENT_CENTER)
	_toast_label.modulate = Color(0.65, 0.28, 0.20)
	hud.add_child(_toast_label)

	_action_button = button("ROLL", _on_roll_pressed, true)
	hud.add_child(_action_button)

	var divider := HSeparator.new()
	hud.add_child(divider)
	_players_box = VBoxContainer.new()
	_players_box.add_theme_constant_override("separation", 10)
	hud.add_child(_players_box)

	var hint := wrapped_label("Roll, then tap a glowing piece. Safe stars cannot be captured.", 15, HORIZONTAL_ALIGNMENT_CENTER)
	hint.modulate = Color(0.45, 0.45, 0.45)
	hud.add_child(hint)
	_refresh()


func get_match_debug_state() -> Dictionary:
	return _match.serialize_debug_state() if _match != null else {}


func _on_roll_pressed() -> void:
	if _input_locked or _match == null or _match.is_finished():
		return
	var state: Dictionary = _match.get_public_state()
	if str(state.get("phase", "")) != "awaiting_roll":
		return
	_input_locked = true
	var result: Dictionary = _match.submit_action({
		"type": "roll",
		"player_slot": int(state.get("turn_index", -1)),
	}, int(state.get("revision", 0)))
	if not bool(result.get("accepted", false)):
		_input_locked = false
		_show_toast(str(result.get("reason", "Action rejected")), 0.8)
		return
	_process_events(result.get("events", []) as Array)
	_refresh()
	await get_tree().create_timer(float((_config.get("animation_seconds", {}) as Dictionary).get("dice", 0.9))).timeout
	_input_locked = false
	_refresh()


func _on_piece_selected(piece_index: int) -> void:
	if _input_locked or _match == null or _match.is_finished():
		return
	var state: Dictionary = _match.get_public_state()
	if str(state.get("phase", "")) != "awaiting_piece_selection":
		return
	_input_locked = true
	var result: Dictionary = _match.submit_action({
		"type": "select_piece",
		"player_slot": int(state.get("turn_index", -1)),
		"piece_index": piece_index,
	}, int(state.get("revision", 0)))
	if not bool(result.get("accepted", false)):
		_input_locked = false
		_show_toast(str(result.get("reason", "Action rejected")), 0.8)
		return
	_process_events(result.get("events", []) as Array)
	_refresh()
	var move_seconds := _estimated_move_seconds(result.get("events", []) as Array)
	await get_tree().create_timer(move_seconds).timeout
	if _match.is_finished():
		_input_locked = false
		match_finished.emit(_match.get_result_payload())
		return
	_input_locked = false
	_refresh()


func _refresh() -> void:
	if _match == null:
		return
	var state: Dictionary = _match.get_public_state()
	_board.set_state(state)
	var turn_slot := int(state.get("turn_index", 0))
	var player := _session_player(turn_slot)
	var player_name := str(player.get("name", "Player %d" % (turn_slot + 1)))
	var avatar_name := str(player.get("avatar_name", "Avatar"))
	var phase := str(state.get("phase", ""))
	if phase == "awaiting_roll":
		_status_label.text = "%s • %s\nYour turn — roll the dice" % [avatar_name, player_name]
		_action_button.text = "BONUS ROLL" if bool(state.get("bonus_roll_pending", false)) else "ROLL"
		_action_button.disabled = _input_locked
	elif phase == "awaiting_piece_selection":
		_status_label.text = "%s • %s\nChoose a glowing piece" % [avatar_name, player_name]
		_action_button.text = "ROLL %d" % int(state.get("last_roll", 0))
		_action_button.disabled = true
	else:
		_status_label.text = "Match complete"
		_action_button.disabled = true
	_roll_label.text = "Roll %s" % ("—" if int(state.get("last_roll", 0)) <= 0 else str(int(state.get("last_roll", 0))))
	_rebuild_player_summary(state)


func _rebuild_player_summary(state: Dictionary) -> void:
	for child in _players_box.get_children():
		child.queue_free()
	var match_players: Array = state.get("players", []) as Array
	for slot in range(match_players.size()):
		var logical := match_players[slot] as Dictionary
		var shell_player := _session_player(slot)
		var pieces: Array = logical.get("pieces", []) as Array
		var home_count := 0
		var yard_count := 0
		for progress_value: Variant in pieces:
			var progress := int(progress_value)
			if progress == 58:
				home_count += 1
			elif progress == 0:
				yard_count += 1
		var prefix := "▶ " if slot == int(state.get("turn_index", -1)) and not _match.is_finished() else ""
		var summary := "%sP%d  %s\n    Home %d/3 • Yard %d • Captures %d" % [
			prefix,
			slot + 1,
			str(shell_player.get("name", "Player %d" % (slot + 1))),
			home_count,
			yard_count,
			int(logical.get("captures_made", 0)),
		]
		_players_box.add_child(wrapped_label(summary, 15))


func _process_events(events: Array) -> void:
	for event_value: Variant in events:
		if not (event_value is Dictionary):
			continue
		var event := event_value as Dictionary
		match str(event.get("type", "")):
			"no_legal_move":
				_show_toast("No legal move", float(event.get("toast_seconds", 0.8)))
			"piece_captured":
				_show_toast("Captured! Rival returns to the Yard.", 0.8)
			"piece_home":
				_show_toast("Piece Home!", 0.8)
			"bonus_roll_granted":
				_show_toast("Roll 6 — one bonus roll!", 0.8)


func _show_toast(text_value: String, seconds: float) -> void:
	_toast_label.text = text_value
	var token := text_value
	_clear_toast_later(token, seconds)


func _clear_toast_later(token: String, seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	if _toast_label != null and _toast_label.text == token:
		_toast_label.text = ""


func _estimated_move_seconds(events: Array) -> float:
	var animation := _config.get("animation_seconds", {}) as Dictionary
	var hop_per_cell := float(animation.get("hop_per_cell", 0.12))
	var hop_cap := float(animation.get("hop_cap", 1.2))
	var result := 0.2
	for event_value: Variant in events:
		if not (event_value is Dictionary):
			continue
		var event := event_value as Dictionary
		match str(event.get("type", "")):
			"piece_moved":
				var distance := absi(int(event.get("to_progress", 0)) - int(event.get("from_progress", 0)))
				result = maxf(result, minf(float(distance) * hop_per_cell, hop_cap))
			"piece_captured":
				result += float(animation.get("capture_reaction", 0.45))
			"piece_home":
				result += float(animation.get("home_celebration", 0.5))
	return result


func _session_player(slot: int) -> Dictionary:
	var players: Array = _session.get("players", []) as Array
	if slot >= 0 and slot < players.size() and players[slot] is Dictionary:
		return players[slot] as Dictionary
	return {}
