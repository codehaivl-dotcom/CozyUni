class_name TutorialScreen
extends BaseShellScreen

signal next_requested
signal skip_requested

var game_id := ""
var step_index := 0
var auto_match := false


func configure(selected_game_id: String, current_step: int, starts_match: bool) -> void:
	game_id = selected_game_id
	step_index = current_step
	auto_match = starts_match


func _ready() -> void:
	var meta := GameData.get_game_metadata(game_id)
	var steps: Array = meta.get("tutorial_steps", []) as Array
	var body := page_vbox()
	var top := HBoxContainer.new()
	top.add_child(label("How to Play", 32))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(spacer)
	top.add_child(button("SKIP TUTORIAL", func() -> void: skip_requested.emit()))
	body.add_child(top)
	if steps.is_empty():
		body.add_child(label("Tutorial data missing", 24, HORIZONTAL_ALIGNMENT_CENTER))
		return
	step_index = clampi(step_index, 0, steps.size() - 1)
	var center := VBoxContainer.new()
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 24)
	body.add_child(center)
	center.add_child(label("%d / %d" % [step_index + 1, steps.size()], 18, HORIZONTAL_ALIGNMENT_CENTER))
	center.add_child(wrapped_label(str(steps[step_index]), 30, HORIZONTAL_ALIGNMENT_CENTER))
	var button_text := "NEXT"
	if step_index == steps.size() - 1:
		button_text = "START MATCH" if auto_match else "DONE"
	center.add_child(button(button_text, func() -> void: next_requested.emit(), true))
