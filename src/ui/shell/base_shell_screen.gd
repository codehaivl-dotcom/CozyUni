class_name BaseShellScreen
extends Control


func _init() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func page_vbox() -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 48)
	margin.add_theme_constant_override("margin_right", 48)
	margin.add_theme_constant_override("margin_top", 32)
	margin.add_theme_constant_override("margin_bottom", 32)
	add_child(margin)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 18)
	margin.add_child(body)
	return body


func header(title: String, subtitle: String = "", back_callback: Callable = Callable(), settings_callback: Callable = Callable()) -> Control:
	var row := HBoxContainer.new()
	row.custom_minimum_size = Vector2(0, 72)
	if back_callback.is_valid():
		row.add_child(button("BACK", back_callback))
	var title_box := VBoxContainer.new()
	title_box.add_child(label(title, 30))
	if not subtitle.is_empty():
		title_box.add_child(wrapped_label(subtitle, 15))
	row.add_child(title_box)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spacer)
	if settings_callback.is_valid():
		row.add_child(button("SETTINGS", settings_callback))
	return row


func label(text_value: String, font_size: int = 18, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var node := Label.new()
	node.text = text_value
	node.horizontal_alignment = alignment
	node.add_theme_font_size_override("font_size", font_size)
	return node


func wrapped_label(text_value: String, font_size: int = 18, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var node := label(text_value, font_size, alignment)
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return node


func button(text_value: String, callback: Callable, primary: bool = false) -> Button:
	var node := Button.new()
	node.text = text_value
	node.custom_minimum_size = Vector2(220, 64 if primary else 56)
	node.add_theme_font_size_override("font_size", 20 if primary else 17)
	node.pressed.connect(callback)
	return node
