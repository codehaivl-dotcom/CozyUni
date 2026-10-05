extends Control

@onready var data_status_label: Label = %DataStatusLabel


func _ready() -> void:
	var game_ids: PackedStringArray = GameData.get_game_ids()
	var errors: PackedStringArray = GameData.get_load_errors()

	if errors.is_empty():
		data_status_label.text = "Game Library foundation ready • %d canonical game configs loaded" % game_ids.size()
	else:
		data_status_label.text = "DATA ERROR • %d config(s) failed to load" % errors.size()
		push_error("AppRoot: canonical game data failed: %s" % [errors])
