class_name LocalPlayerSetupScreen
extends BaseShellScreen

signal back_requested
signal continue_requested
signal player_count_changed(count: int)
signal avatar_cycle_requested(slot: int)
signal player_name_changed(slot: int, value: String)

var game_id := ""
var session: Dictionary = {}


func configure(selected_game_id: String, session_data: Dictionary) -> void:
	game_id = selected_game_id
	session = session_data


func _ready() -> void:
	var config := GameData.get_game(game_id)
	var meta := GameData.get_game_metadata(game_id)
	var counts: Array = config.get("player_counts", [2]) as Array
	var body := page_vbox()
	body.add_child(header("Local Player Setup", str(meta.get("title", game_id)), func() -> void: back_requested.emit()))

	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 28)
	body.add_child(row)

	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_theme_constant_override("separation", 12)
	row.add_child(left)

	if counts.size() > 1:
		var selector := HBoxContainer.new()
		selector.add_child(label("Players", 20))
		for count_value: Variant in counts:
			var count := int(count_value)
			var count_button := button(str(count), func() -> void: player_count_changed.emit(count), count == int(session.get("player_count", 2)))
			count_button.custom_minimum_size = Vector2(80, 56)
			selector.add_child(count_button)
		left.add_child(selector)

	var players: Array = session.get("players", []) as Array
	var player_count := int(session.get("player_count", 2))
	var colors: Array = config.get("player_colors", ["red", "blue", "green", "yellow"]) as Array
	for slot in range(player_count):
		var player: Dictionary = players[slot] if slot < players.size() else {}
		var slot_row := HBoxContainer.new()
		slot_row.custom_minimum_size = Vector2(0, 72)
		slot_row.add_theme_constant_override("separation", 12)
		left.add_child(slot_row)
		slot_row.add_child(label("P%d" % (slot + 1), 20))
		var avatar_button := button(str(player.get("avatar_name", "Avatar")), func() -> void: avatar_cycle_requested.emit(slot))
		avatar_button.custom_minimum_size = Vector2(210, 56)
		slot_row.add_child(avatar_button)
		var name_edit := LineEdit.new()
		name_edit.max_length = 16
		name_edit.custom_minimum_size = Vector2(220, 56)
		name_edit.text = str(player.get("name", "Player %d" % (slot + 1)))
		name_edit.text_changed.connect(func(value: String) -> void: player_name_changed.emit(slot, value))
		slot_row.add_child(name_edit)
		var color_name := str(colors[slot]) if slot < colors.size() else "side"
		slot_row.add_child(label(color_name.capitalize(), 18))

	var summary := VBoxContainer.new()
	summary.custom_minimum_size = Vector2(320, 0)
	summary.add_theme_constant_override("separation", 16)
	summary.add_child(label(str(meta.get("title", game_id)), 28))
	summary.add_child(wrapped_label(str(meta.get("win_condition", "")), 18))
	summary.add_child(label("Ruleset: %s" % str(meta.get("ruleset", "")), 18))
	summary.add_child(label("Expected: %s" % str(meta.get("session_label", "")), 18))
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	summary.add_child(spacer)
	summary.add_child(button("CONTINUE", func() -> void: continue_requested.emit(), true))
	row.add_child(summary)
