class_name StubMatchScreen
extends BaseShellScreen

signal pause_requested
signal finish_requested

var game_id := ""


func configure(selected_game_id: String) -> void:
	game_id = selected_game_id


func _ready() -> void:
	var meta := GameData.get_game_metadata(game_id)
	var body := page_vbox()
	var top := HBoxContainer.new()
	top.add_child(button("PAUSE", func() -> void: pause_requested.emit()))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(spacer)
	top.add_child(label("%s • DEVELOPMENT SHELL STUB" % str(meta.get("title", "Game")), 20))
	body.add_child(top)
	var center := VBoxContainer.new()
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 18)
	body.add_child(center)
	center.add_child(label("BOARD / MATCH PRESENTATION", 36, HORIZONTAL_ALIGNMENT_CENTER))
	center.add_child(wrapped_label("A1 verifies shell navigation only. Canonical Ludo rules begin in A2.", 20, HORIZONTAL_ALIGNMENT_CENTER))
	if OS.is_debug_build():
		center.add_child(button("FINISH STUB MATCH", func() -> void: finish_requested.emit(), true))
