class_name MatchSummaryScreen
extends BaseShellScreen

signal back_requested
signal start_requested
signal tutorial_requested

var game_id := ""
var session: Dictionary = {}


func configure(selected_game_id: String, session_data: Dictionary) -> void:
	game_id = selected_game_id
	session = session_data


func _ready() -> void:
	var meta := GameData.get_game_metadata(game_id)
	var body := page_vbox()
	body.add_child(header("Match Summary", str(meta.get("title", game_id)), func() -> void: back_requested.emit()))
	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	panel.add_child(content)
	content.add_child(label(str(meta.get("title", game_id)), 34, HORIZONTAL_ALIGNMENT_CENTER))
	content.add_child(label(_player_order_text(), 20, HORIZONTAL_ALIGNMENT_CENTER))
	content.add_child(wrapped_label(str(meta.get("win_condition", "")), 20, HORIZONTAL_ALIGNMENT_CENTER))
	content.add_child(label("Ruleset: %s" % str(meta.get("ruleset", "")), 18, HORIZONTAL_ALIGNMENT_CENTER))
	var bullets: Variant = meta.get("summary_bullets", [])
	if bullets is Array:
		for bullet: Variant in bullets:
			content.add_child(label("• %s" % str(bullet), 17, HORIZONTAL_ALIGNMENT_CENTER))
	content.add_child(label("Expected: %s" % str(meta.get("session_label", "")), 18, HORIZONTAL_ALIGNMENT_CENTER))
	content.add_child(button("START", func() -> void: start_requested.emit(), true))
	content.add_child(button("HOW TO PLAY", func() -> void: tutorial_requested.emit()))
	content.add_child(button("BACK", func() -> void: back_requested.emit()))


func _player_order_text() -> String:
	var names := PackedStringArray()
	var players: Array = session.get("players", []) as Array
	var player_count := int(session.get("player_count", 0))
	for index in range(player_count):
		var player: Dictionary = players[index] if index < players.size() else {}
		names.append(str(player.get("name", "Player %d" % (index + 1))))
	return "Starting order: %s" % " → ".join(names)
