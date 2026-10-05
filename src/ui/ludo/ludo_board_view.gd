class_name LudoBoardView
extends Control

signal piece_selected(piece_index: int)

const PLAYER_COLORS := [
	Color("d95c5c"),
	Color("547fc4"),
	Color("5b9a68"),
	Color("d7ae43"),
]
const BOARD_BG := Color("f4efe2")
const TRACK := Color("d8d1c0")
const SAFE := Color("f0c966")
const HOME_LANE := Color("e9e3d5")
const OUTLINE := Color("675f54")
const LEGAL_GLOW := Color(1.0, 0.92, 0.45, 0.95)

var _config: Dictionary = {}
var _state: Dictionary = {}
var _active_slot := -1
var _legal_piece_indices: Array[int] = []
var _hit_rects: Dictionary = {}


func configure(config: Dictionary, state: Dictionary) -> void:
	_config = config.duplicate(true)
	set_state(state)


func set_state(state: Dictionary) -> void:
	_state = state.duplicate(true)
	_active_slot = int(_state.get("turn_index", -1))
	_legal_piece_indices.clear()
	for value: Variant in (_state.get("legal_piece_indices", []) as Array):
		_legal_piece_indices.append(int(value))
	queue_redraw()


func _ready() -> void:
	custom_minimum_size = Vector2(660, 600)
	mouse_filter = Control.MOUSE_FILTER_STOP


func _draw() -> void:
	_hit_rects.clear()
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, BOARD_BG, true)
	var margin := minf(size.x, size.y) * 0.12
	var track_rect := Rect2(Vector2(margin, margin), size - Vector2(margin * 2.0, margin * 2.0))

	for cell_index in range(52):
		var center := _outer_cell_position(track_rect, cell_index)
		var fill := SAFE if _is_safe_cell(cell_index) else TRACK
		draw_circle(center, 11.0, fill)
		draw_arc(center, 11.0, 0.0, TAU, 24, OUTLINE, 1.2)

	var center_point := rect.get_center()
	for slot in range(4):
		var start_cell := _start_cell(slot)
		if start_cell < 0:
			continue
		var start_pos := _outer_cell_position(track_rect, start_cell)
		var lane_color := PLAYER_COLORS[slot].lerp(Color.WHITE, 0.55)
		for lane_index in range(1, 6):
			var t := float(lane_index) / 6.0
			var lane_pos := start_pos.lerp(center_point, t)
			draw_circle(lane_pos, 12.0, lane_color)
			draw_arc(lane_pos, 12.0, 0.0, TAU, 24, OUTLINE, 1.2)

	for slot in range(4):
		var home_pos := _home_position(center_point, slot)
		draw_circle(home_pos, 24.0, PLAYER_COLORS[slot].lerp(Color.WHITE, 0.35))
		draw_arc(home_pos, 24.0, 0.0, TAU, 28, OUTLINE, 1.5)

	_draw_pieces(track_rect, center_point)


func _draw_pieces(track_rect: Rect2, center_point: Vector2) -> void:
	var players: Array = _state.get("players", []) as Array
	for slot in range(players.size()):
		var player := players[slot] as Dictionary
		var pieces: Array = player.get("pieces", []) as Array
		for piece_index in range(pieces.size()):
			var progress := int(pieces[piece_index])
			var pos := _piece_position(track_rect, center_point, slot, piece_index, progress)
			var legal := slot == _active_slot and piece_index in _legal_piece_indices
			if legal:
				draw_circle(pos, 24.0, LEGAL_GLOW)
			var color := PLAYER_COLORS[slot % PLAYER_COLORS.size()]
			draw_circle(pos, 17.0, color)
			draw_arc(pos, 17.0, 0.0, TAU, 24, Color.WHITE, 2.5)
			draw_string(ThemeDB.fallback_font, pos + Vector2(-5, 6), str(piece_index + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
			if legal:
				_hit_rects[piece_index] = Rect2(pos - Vector2(26, 26), Vector2(52, 52))


func _gui_input(event: InputEvent) -> void:
	var pressed := false
	var position := Vector2.ZERO
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		pressed = mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT
		position = mouse_event.position
	elif event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		pressed = touch_event.pressed
		position = touch_event.position
	if not pressed:
		return
	for piece_index_value: Variant in _hit_rects.keys():
		var piece_index := int(piece_index_value)
		var hit_rect := _hit_rects[piece_index] as Rect2
		if hit_rect.has_point(position):
			piece_selected.emit(piece_index)
			accept_event()
			return


func _piece_position(track_rect: Rect2, center_point: Vector2, slot: int, piece_index: int, progress: int) -> Vector2:
	if progress <= 0:
		return _yard_position(track_rect, slot, piece_index)
	if progress <= 52:
		var absolute := _absolute_cell(slot, progress)
		return _outer_cell_position(track_rect, absolute) + _stack_offset(slot, piece_index)
	if progress <= 57:
		var start_pos := _outer_cell_position(track_rect, _start_cell(slot))
		var lane_index := progress - 52
		return start_pos.lerp(center_point, float(lane_index) / 6.0) + _stack_offset(slot, piece_index)
	return _home_position(center_point, slot) + _home_piece_offset(piece_index)


func _outer_cell_position(track_rect: Rect2, absolute_cell: int) -> Vector2:
	var segment := posmod(absolute_cell, 52)
	var side := segment / 13
	var step := segment % 13
	var t := float(step) / 13.0
	match side:
		0:
			return Vector2(lerpf(track_rect.position.x, track_rect.end.x, t), track_rect.position.y)
		1:
			return Vector2(track_rect.end.x, lerpf(track_rect.position.y, track_rect.end.y, t))
		2:
			return Vector2(lerpf(track_rect.end.x, track_rect.position.x, t), track_rect.end.y)
		_:
			return Vector2(track_rect.position.x, lerpf(track_rect.end.y, track_rect.position.y, t))


func _yard_position(track_rect: Rect2, slot: int, piece_index: int) -> Vector2:
	var inset := Vector2(62, 62)
	var anchor := Vector2.ZERO
	match slot:
		0:
			anchor = track_rect.position + inset
		1:
			anchor = Vector2(track_rect.end.x - inset.x, track_rect.position.y + inset.y)
		2:
			anchor = track_rect.end - inset
		_:
			anchor = Vector2(track_rect.position.x + inset.x, track_rect.end.y - inset.y)
	var offsets := [Vector2(-24, 18), Vector2(24, 18), Vector2(0, -24)]
	return anchor + offsets[piece_index % offsets.size()]


func _home_position(center_point: Vector2, slot: int) -> Vector2:
	var offsets := [Vector2(-34, -34), Vector2(34, -34), Vector2(34, 34), Vector2(-34, 34)]
	return center_point + offsets[slot % offsets.size()]


func _home_piece_offset(piece_index: int) -> Vector2:
	var offsets := [Vector2(-8, 7), Vector2(8, 7), Vector2(0, -9)]
	return offsets[piece_index % offsets.size()]


func _stack_offset(slot: int, piece_index: int) -> Vector2:
	var angle := float((slot * 3 + piece_index) % 8) * TAU / 8.0
	return Vector2(cos(angle), sin(angle)) * 5.0


func _absolute_cell(slot: int, progress: int) -> int:
	var starts: Array = (_config.get("board", {}) as Dictionary).get("start_indices", []) as Array
	var loop_cells := int((_config.get("board", {}) as Dictionary).get("outer_loop_cells", 52))
	if slot < 0 or slot >= starts.size():
		return 0
	return (int(starts[slot]) + progress - 1) % loop_cells


func _start_cell(slot: int) -> int:
	var starts: Array = (_config.get("board", {}) as Dictionary).get("start_indices", []) as Array
	if slot < 0 or slot >= starts.size():
		return -1
	return int(starts[slot])


func _is_safe_cell(cell_index: int) -> bool:
	var safe_cells: Array = (_config.get("board", {}) as Dictionary).get("safe_cells", []) as Array
	for value: Variant in safe_cells:
		if int(value) == cell_index:
			return true
	return false
