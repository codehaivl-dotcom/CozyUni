class_name FinalResultsScreen
extends BaseShellScreen

signal rematch_requested
signal change_players_requested
signal library_requested

var session: Dictionary = {}


func configure(session_data: Dictionary) -> void:
	session = session_data


func _ready() -> void:
	var players: Array = session.get("players", []) as Array
	var player_count := int(session.get("player_count", 0))
	var stub_result: Dictionary = session.get("stub_result", {}) as Dictionary
	var body := page_vbox()
	body.alignment = BoxContainer.ALIGNMENT_CENTER
	body.add_child(label("Final Results", 42, HORIZONTAL_ALIGNMENT_CENTER))
	if bool(stub_result.get("development_stub", false)):
		body.add_child(label("Development Stub Result — not gameplay scoring", 16, HORIZONTAL_ALIGNMENT_CENTER))
	for index in range(player_count):
		var player: Dictionary = players[index] if index < players.size() else {}
		body.add_child(label("#%d  %s  —  %s" % [index + 1, str(player.get("avatar_name", "Avatar")), str(player.get("name", "Player"))], 22, HORIZONTAL_ALIGNMENT_CENTER))
	body.add_child(button("REMATCH", func() -> void: rematch_requested.emit(), true))
	body.add_child(button("CHANGE PLAYERS", func() -> void: change_players_requested.emit()))
	body.add_child(button("GAME LIBRARY", func() -> void: library_requested.emit()))
