extends SceneTree

const LudoMatchScript = preload("res://src/modes/cozy_ludo/ludo_match.gd")
const LudoBoardViewScript = preload("res://src/ui/ludo/ludo_board_view.gd")
const CONFIG_PATH := "res://data/games/ludo_v1.json"

var _config: Dictionary = {}
var _failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_config = _load_config()
	if _config.is_empty():
		push_error("Ludo UI smoke FAILED: runtime config missing")
		quit(1)
		return

	_test_supported_player_counts()
	await _test_touch_target_and_selection()

	if _failures > 0:
		push_error("Ludo UI smoke FAILED: %d invariant(s)" % _failures)
		quit(1)
		return
	print("Ludo UI smoke PASS")
	quit(0)


func _load_config() -> Dictionary:
	if not FileAccess.file_exists(CONFIG_PATH):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(CONFIG_PATH))
	return parsed as Dictionary if parsed is Dictionary else {}


func _test_supported_player_counts() -> void:
	for count in [2, 3, 4]:
		var match_obj = LudoMatchScript.new(_config, count, 424200 + count, 0)
		var state: Dictionary = match_obj.get_public_state()
		var players: Array = state.get("players", []) as Array
		_expect(players.size() == count, "match creates exactly %d players" % count)
		_expect(int(state.get("turn_index", -1)) == 0, "%dP match starts at requested slot" % count)
		_expect(str(state.get("phase", "")) == "awaiting_roll", "%dP match begins awaiting roll" % count)


func _test_touch_target_and_selection() -> void:
	var match_obj = LudoMatchScript.new(_config, 2, 606060, 0, func() -> int: return 6)
	var roll_result: Dictionary = match_obj.submit_action({"type": "roll", "player_slot": 0}, 0)
	_expect(bool(roll_result.get("accepted", false)), "roll action accepted for UI state")
	var state: Dictionary = roll_result.get("state", {}) as Dictionary
	var legal: Array = state.get("legal_piece_indices", []) as Array
	_expect(not legal.is_empty(), "roll 6 exposes at least one selectable piece")
	if legal.is_empty():
		return

	var board = LudoBoardViewScript.new()
	board.size = Vector2(760, 660)
	board.configure(_config, state)
	root.add_child(board)
	await process_frame
	board.queue_redraw()
	await process_frame

	var piece_index := int(legal[0])
	var hit_rects: Dictionary = board._hit_rects
	_expect(hit_rects.has(piece_index), "legal piece has a hit target")
	if not hit_rects.has(piece_index):
		board.queue_free()
		return

	var hit_rect := hit_rects[piece_index] as Rect2
	_expect(hit_rect.size.x >= 52.0 and hit_rect.size.y >= 52.0, "legal touch target is at least 52x52 px")

	# GDScript lambda locals are captured by value. Use a reference container so
	# the signal callback can update state observed by the outer test scope.
	var selected_ref: Dictionary = {"value": -1}
	board.piece_selected.connect(func(index: int) -> void: selected_ref["value"] = index)
	var touch := InputEventScreenTouch.new()
	touch.pressed = true
	touch.index = 0
	touch.position = hit_rect.get_center()
	board._gui_input(touch)
	_expect(int(selected_ref["value"]) == piece_index, "touch at legal-piece center emits correct selection")

	var illegal_touch := InputEventScreenTouch.new()
	illegal_touch.pressed = true
	illegal_touch.index = 1
	illegal_touch.position = Vector2(4, 4)
	selected_ref["value"] = -1
	board._gui_input(illegal_touch)
	_expect(int(selected_ref["value"]) == -1, "touch outside legal targets does not select a piece")

	board.queue_free()
	await process_frame


func _expect(condition: bool, description: String) -> void:
	if condition:
		return
	_failures += 1
	push_error("Ludo UI invariant failed: %s" % description)
