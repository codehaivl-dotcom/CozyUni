extends Node

const SAVE_PATH := "user://settings_v1.json"
const SCHEMA_VERSION := 1

var _data: Dictionary = {}


func _ready() -> void:
	_load_or_defaults()


func get_value(section: String, key: String, default_value: Variant = null) -> Variant:
	var section_data: Variant = _data.get(section, {})
	if section_data is Dictionary:
		return (section_data as Dictionary).get(key, default_value)
	return default_value


func set_value(section: String, key: String, value: Variant, persist: bool = true) -> void:
	if not _data.has(section) or not (_data[section] is Dictionary):
		_data[section] = {}
	(_data[section] as Dictionary)[key] = value
	if persist:
		save()


func snapshot() -> Dictionary:
	return _data.duplicate(true)


func save() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SettingsStore: unable to open settings file for write")
		return false
	file.store_string(JSON.stringify(_data, "\t"))
	file.close()
	return true


func _load_or_defaults() -> void:
	_data = _defaults()
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if not (parsed is Dictionary):
		push_warning("SettingsStore: malformed save; using defaults")
		return

	var loaded := parsed as Dictionary
	if int(loaded.get("schema_version", -1)) != SCHEMA_VERSION:
		push_warning("SettingsStore: unsupported schema; using defaults")
		return

	_data = loaded


func _defaults() -> Dictionary:
	return {
		"schema_version": SCHEMA_VERSION,
		"settings": {
			"language": "en",
			"master_volume": 1.0,
			"music_volume": 1.0,
			"sfx_volume": 1.0,
		},
		"accessibility": {
			"reduced_motion": false,
		},
		"tutorials": {},
		"local_profiles": {},
		"stats": {},
		"cache": {},
	}
