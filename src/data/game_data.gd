extends Node

const GAME_CONFIG_PATHS: Dictionary = {
	"cozy_ludo": "res://docs/data/games/ludo_v1.json",
	"cozy_caro": "res://docs/data/games/caro_v1.json",
	"cozy_journey": "res://docs/data/games/journey_v1.json",
	"cozy_chess": "res://docs/data/games/chess_v1.json",
	"cozy_tycoon": "res://docs/data/games/tycoon_v1.json",
}

var _games: Dictionary = {}
var _load_errors: PackedStringArray = PackedStringArray()


func _ready() -> void:
	load_all()


func load_all() -> bool:
	_games.clear()
	_load_errors.clear()

	for game_id: String in GAME_CONFIG_PATHS.keys():
		var path: String = GAME_CONFIG_PATHS[game_id]
		var parsed: Variant = _load_json(path)
		if parsed is Dictionary:
			_games[game_id] = parsed
		else:
			_load_errors.append("%s:%s" % [game_id, path])

	return _load_errors.is_empty()


func has_game(game_id: String) -> bool:
	return _games.has(game_id)


func get_game(game_id: String) -> Dictionary:
	if not _games.has(game_id):
		push_error("GameData: unknown game id '%s'" % game_id)
		return {}
	return (_games[game_id] as Dictionary).duplicate(true)


func get_game_ids() -> PackedStringArray:
	var ids := PackedStringArray()
	for game_id: String in GAME_CONFIG_PATHS.keys():
		if _games.has(game_id):
			ids.append(game_id)
	return ids


func get_load_errors() -> PackedStringArray:
	return _load_errors.duplicate()


func _load_json(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		push_error("GameData: missing canonical JSON at %s" % path)
		return null

	var text: String = FileAccess.get_file_as_string(path)
	var parsed: Variant = JSON.parse_string(text)
	if parsed == null:
		push_error("GameData: invalid JSON at %s" % path)
		return null
	return parsed
