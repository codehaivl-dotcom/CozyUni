class_name SettingsScreen
extends BaseShellScreen

signal close_requested
signal replay_tutorials_requested


func _ready() -> void:
	var body := page_vbox()
	body.add_child(header("Settings", "Presentation & accessibility", func() -> void: close_requested.emit()))
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	body.add_child(scroll)
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	scroll.add_child(content)

	content.add_child(label("Audio", 24))
	content.add_child(_slider_row("Master Volume", float(SettingsStore.get_value("settings", "master_volume", 0.8)), Callable(AudioService, "set_master_volume")))
	content.add_child(_slider_row("Music", float(SettingsStore.get_value("settings", "music_volume", 0.6)), Callable(AudioService, "set_music_volume")))
	content.add_child(_slider_row("SFX", float(SettingsStore.get_value("settings", "sfx_volume", 0.8)), Callable(AudioService, "set_sfx_volume")))

	content.add_child(label("Feedback", 24))
	content.add_child(_check_row("Haptics", bool(SettingsStore.get_value("settings", "haptics", true)), "settings", "haptics"))
	content.add_child(_option_row("Animation Speed", ["normal", "fast"], str(SettingsStore.get_value("settings", "animation_speed", "normal")), "settings", "animation_speed"))
	content.add_child(_check_row("Reduce Motion", bool(SettingsStore.get_value("accessibility", "reduced_motion", false)), "accessibility", "reduced_motion"))

	content.add_child(label("Accessibility", 24))
	content.add_child(_option_row("Color Mode", ["normal", "deuteranopia", "protanopia", "tritanopia"], str(SettingsStore.get_value("accessibility", "color_mode", "normal")), "accessibility", "color_mode"))
	content.add_child(_option_row("UI Scale", ["normal", "large"], str(SettingsStore.get_value("accessibility", "ui_scale", "normal")), "accessibility", "ui_scale"))
	content.add_child(_check_row("High Contrast Board Markers", bool(SettingsStore.get_value("accessibility", "high_contrast_board_markers", false)), "accessibility", "high_contrast_board_markers"))

	content.add_child(label("General", 24))
	content.add_child(_option_row("Language", ["auto"], str(SettingsStore.get_value("settings", "language", "auto")), "settings", "language"))
	content.add_child(_check_row("Confirm Leave/Restart", bool(SettingsStore.get_value("settings", "confirm_leave_restart", true)), "settings", "confirm_leave_restart"))
	content.add_child(button("REPLAY TUTORIALS", func() -> void: replay_tutorials_requested.emit()))


func _slider_row(title: String, value: float, callback: Callable) -> Control:
	var row := HBoxContainer.new()
	row.add_child(label(title, 18))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spacer)
	var slider := HSlider.new()
	slider.custom_minimum_size = Vector2(360, 56)
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.05
	slider.value = value
	slider.value_changed.connect(callback)
	row.add_child(slider)
	return row


func _check_row(title: String, value: bool, section: String, key: String) -> Control:
	var check := CheckButton.new()
	check.custom_minimum_size = Vector2(0, 56)
	check.text = title
	check.button_pressed = value
	check.toggled.connect(func(enabled: bool) -> void: SettingsStore.set_value(section, key, enabled))
	return check


func _option_row(title: String, options: Array[String], current: String, section: String, key: String) -> Control:
	var row := HBoxContainer.new()
	row.add_child(label(title, 18))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spacer)
	var option := OptionButton.new()
	option.custom_minimum_size = Vector2(280, 56)
	var selected_index := 0
	for index in range(options.size()):
		option.add_item(options[index].capitalize())
		if options[index] == current:
			selected_index = index
	option.select(selected_index)
	option.item_selected.connect(func(index: int) -> void: SettingsStore.set_value(section, key, options[index]))
	row.add_child(option)
	return row
