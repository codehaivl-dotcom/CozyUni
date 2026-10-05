extends Node

const BUS_NAMES := ["Music", "SFX", "UI", "Ambience"]


func _ready() -> void:
	_ensure_buses()
	_apply_saved_volumes()


func set_master_volume(linear_value: float) -> void:
	_set_bus_linear("Master", linear_value)
	SettingsStore.set_value("settings", "master_volume", clampf(linear_value, 0.0, 1.0))


func set_music_volume(linear_value: float) -> void:
	_set_bus_linear("Music", linear_value)
	SettingsStore.set_value("settings", "music_volume", clampf(linear_value, 0.0, 1.0))


func set_sfx_volume(linear_value: float) -> void:
	_set_bus_linear("SFX", linear_value)
	SettingsStore.set_value("settings", "sfx_volume", clampf(linear_value, 0.0, 1.0))


func _ensure_buses() -> void:
	for bus_name_value: Variant in BUS_NAMES:
		var bus_name := str(bus_name_value)
		if AudioServer.get_bus_index(bus_name) == -1:
			AudioServer.add_bus()
			AudioServer.set_bus_name(AudioServer.bus_count - 1, bus_name)


func _apply_saved_volumes() -> void:
	_set_bus_linear("Master", float(SettingsStore.get_value("settings", "master_volume", 1.0)))
	_set_bus_linear("Music", float(SettingsStore.get_value("settings", "music_volume", 1.0)))
	_set_bus_linear("SFX", float(SettingsStore.get_value("settings", "sfx_volume", 1.0)))


func _set_bus_linear(bus_name: String, linear_value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_warning("AudioService: unknown bus %s" % bus_name)
		return
	var value: float = clampf(linear_value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(value, 0.0001)))
	AudioServer.set_bus_mute(bus_index, value <= 0.0001)