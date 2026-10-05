extends Node

const SAVE_PATH := "user://settings_v2.json"
const LEGACY_SAVE_PATH := "user://settings_v1.json"
const SCHEMA_VERSION := 2

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


func is_tutorial_completed(game_id: String) -> bool:
	return bool(get_value("tutorials", game_id, false))


func set_tutorial_completed(game_id: String, completed: bool = true) -> void:
	set_value("tutorials", game_id, completed)


func reset_tutorials() -> void:
	_data["tutorials"] = {}
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
	if FileAccess.file_exists(SAVE_PATH):
		_load_current()
		return
	if FileAccess.file_exists(LEGACY_SAVE_PATH):
		_migrate_legacy_v1()


func _load_current() -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if not (parsed is Dictionary):
		push_warning("SettingsStore: malformed save; using defaults")
		return
	var loaded := parsed as Dictionary
	if int(loaded.get("schema_version", -1)) != SCHEMA_VERSION:
		push_warning("SettingsStore: unsupported schema; using defaults")
		return
	_data = _merge_with_defaults(loaded)


func _migrate_legacy_v1() -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(LEGACY_SAVE_PATH))
	if not (parsed is Dictionary):
		push_warning("SettingsStore: malformed legacy save; using defaults")
		return
	var legacy := parsed as Dictionary
	if int(legacy.get("schema_version", -1)) != 1:
		push_warning("SettingsStore: unsupported legacy schema; using defaults")
		return
	_data = _merge_with_defaults(legacy)
	_data["schema_version"] = SCHEMA_VERSION
	save()


func _merge_with_defaults(loaded: Dictionary) -> Dictionary:
	var merged := _defaults()
	for section_name: String in ["settings", "accessibility", "tutorials", "local_profiles", "stats", "cache"]:
		var source: Variant = loaded.get(section_name, {})
		if not (source is Dictionary):
			continue
		if not merged.has(section_name) or not (merged[section_name] is Dictionary):
			merged[section_name] = {}
		for key: Variant in (source as Dictionary).keys():
			(merged[section_name] as Dictionary)[key] = (source as Dictionary)[key]
	merged["schema_version"] = SCHEMA_VERSION
	return merged


func _defaults() -> Dictionary:
	return {
		"schema_version": SCHEMA_VERSION,
		"settings": {
			"language": "auto",
			"master_volume": 0.8,
			"music_volume": 0.6,
			"sfx_volume": 0.8,
			"haptics": true,
			"animation_speed": "normal",
			"confirm_leave_restart": true,
		},
		"accessibility": {
			"reduced_motion": false,
			"color_mode": "normal",
			"ui_scale": "normal",
			"high_contrast_board_markers": false,
		},
		"tutorials": {},
		"local_profiles": {},
		"stats": {},
		"cache": {},
	}
