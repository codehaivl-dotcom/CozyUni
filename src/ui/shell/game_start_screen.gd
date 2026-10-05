class_name GameStartScreen
extends BaseShellScreen

signal back_requested
signal play_requested
signal tutorial_requested
signal settings_requested

var game_id := ""


func configure(selected_game_id: String) -> void:
	game_id = selected_game_id


func _ready() -> void:
	var meta := GameData.get_game_metadata(game_id)
	var body := page_vbox()
	body.add_child(header(str(meta.get("title", game_id)), str(meta.get("description", "")), func() -> void: back_requested.emit(), func() -> void: settings_requested.emit()))
	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 32)
	body.add_child(row)

	var preview := PanelContainer.new()
	preview.custom_minimum_size = Vector2(720, 430)
	preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var preview_label := label("3D BOARD PREVIEW\n\nVisual integration begins after shell/rules gates.", 28, HORIZONTAL_ALIGNMENT_CENTER)
	preview_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	preview.add_child(preview_label)
	row.add_child(preview)

	var actions := VBoxContainer.new()
	actions.custom_minimum_size = Vector2(260, 0)
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override("separation", 18)
	actions.add_child(button("PLAY", func() -> void: play_requested.emit(), true))
	actions.add_child(button("HOW TO PLAY", func() -> void: tutorial_requested.emit()))
	actions.add_child(button("SETTINGS", func() -> void: settings_requested.emit()))
	row.add_child(actions)
