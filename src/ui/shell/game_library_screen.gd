class_name GameLibraryScreen
extends BaseShellScreen

signal game_selected(game_id: String)
signal settings_requested


func _ready() -> void:
	var body := page_vbox()
	body.add_child(header("CozyUni", "", Callable(), func() -> void: settings_requested.emit()))
	body.add_child(label("Choose a Game", 34))

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	body.add_child(scroll)

	var rail := HBoxContainer.new()
	rail.add_theme_constant_override("separation", 24)
	scroll.add_child(rail)
	for game_id: String in GameData.get_available_game_ids():
		var meta := GameData.get_game_metadata(game_id)
		var card := Button.new()
		card.custom_minimum_size = Vector2(340, 430)
		card.size_flags_vertical = Control.SIZE_EXPAND_FILL
		card.text = "%s\n\nBOARD PREVIEW\n\n%s   •   %s   •   %s" % [
			str(meta.get("title", game_id)),
			str(meta.get("player_count_label", "")),
			str(meta.get("session_label", "")),
			str(meta.get("tag", "")),
		]
		card.pressed.connect(func() -> void: game_selected.emit(game_id))
		rail.add_child(card)
