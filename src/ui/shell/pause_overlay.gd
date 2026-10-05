class_name PauseOverlay
extends BaseShellScreen

signal resume_requested
signal tutorial_requested
signal settings_requested
signal restart_requested
signal leave_requested


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := VBoxContainer.new()
	panel.custom_minimum_size = Vector2(520, 420)
	panel.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_theme_constant_override("separation", 14)
	center.add_child(panel)
	panel.add_child(label("Paused", 34, HORIZONTAL_ALIGNMENT_CENTER))
	panel.add_child(button("RESUME", func() -> void: resume_requested.emit(), true))
	panel.add_child(button("HOW TO PLAY", func() -> void: tutorial_requested.emit()))
	panel.add_child(button("SETTINGS", func() -> void: settings_requested.emit()))
	panel.add_child(button("RESTART MATCH", func() -> void: restart_requested.emit()))
	panel.add_child(button("LEAVE MATCH", func() -> void: leave_requested.emit()))
