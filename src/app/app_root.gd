extends Control

const SHELL_FLOW = preload("res://src/app/shell_flow.gd")
const GameLibraryScreenScript = preload("res://src/ui/shell/game_library_screen.gd")
const GameStartScreenScript = preload("res://src/ui/shell/game_start_screen.gd")
const LocalPlayerSetupScreenScript = preload("res://src/ui/shell/local_player_setup_screen.gd")
const MatchSummaryScreenScript = preload("res://src/ui/shell/match_summary_screen.gd")
const TutorialScreenScript = preload("res://src/ui/shell/tutorial_screen.gd")
const CountdownScreenScript = preload("res://src/ui/shell/countdown_screen.gd")
const StubMatchScreenScript = preload("res://src/ui/shell/stub_match_screen.gd")
const FinalResultsScreenScript = preload("res://src/ui/shell/final_results_screen.gd")
const SettingsScreenScript = preload("res://src/ui/shell/settings_screen.gd")
const PauseOverlayScript = preload("res://src/ui/shell/pause_overlay.gd")

@onready var screen_host: Control = %ScreenHost

var _current_screen: Control
var _pause_overlay: Control
var _selected_game_id := ""
var _session: Dictionary = {}
var _settings_return_route := SHELL_FLOW.GAME_LIBRARY
var _tutorial_return_route := SHELL_FLOW.GAME_START
var _tutorial_step := 0
var _tutorial_starts_match := false


func _ready() -> void:
	AppRouter.route_changed.connect(_on_route_changed)
	_show_splash()
	call_deferred("_complete_boot")


func _complete_boot() -> void:
	var errors := GameData.get_load_errors()
	if not errors.is_empty():
		_show_init_error(errors)
		return
	if GameData.get_available_game_ids().is_empty():
		_show_init_error(PackedStringArray(["No games are admitted to the current build"]))
		return
	AppRouter.navigate(SHELL_FLOW.GAME_LIBRARY)


func _on_route_changed(route_id: String, _payload: Dictionary) -> void:
	match route_id:
		SHELL_FLOW.GAME_LIBRARY:
			_show_game_library()
		SHELL_FLOW.GAME_START:
			_show_game_start()
		SHELL_FLOW.LOCAL_PLAYER_SETUP:
			_show_local_player_setup()
		SHELL_FLOW.MATCH_SUMMARY:
			_show_match_summary()
		SHELL_FLOW.TUTORIAL:
			_show_tutorial()
		SHELL_FLOW.COUNTDOWN:
			_show_countdown()
		SHELL_FLOW.MATCH:
			_show_match()
		SHELL_FLOW.FINAL_RESULTS:
			_show_final_results()
		SHELL_FLOW.SETTINGS:
			_show_settings()
		_:
			push_error("AppRoot: unsupported route '%s'" % route_id)


func _show_splash() -> void:
	var screen := Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.add_child(center)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 14)
	center.add_child(box)
	var title := Label.new()
	title.text = "CozyUni"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	box.add_child(title)
	var status := Label.new()
	status.text = "Loading…"
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.add_theme_font_size_override("font_size", 18)
	box.add_child(status)
	_replace_screen(screen, false)


func _show_init_error(errors: PackedStringArray) -> void:
	var screen := Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.add_child(center)
	var box := VBoxContainer.new()
	box.custom_minimum_size = Vector2(620, 260)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 18)
	center.add_child(box)
	var title := Label.new()
	title.text = "Initialization failed"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	box.add_child(title)
	var detail := Label.new()
	detail.text = "Canonical runtime data could not be loaded.\n%s" % "\n".join(errors)
	detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(detail)
	var retry := Button.new()
	retry.text = "RETRY"
	retry.custom_minimum_size = Vector2(220, 64)
	retry.pressed.connect(_retry_initialization)
	box.add_child(retry)
	_replace_screen(screen, false)


func _retry_initialization() -> void:
	_show_splash()
	if GameData.load_all():
		AppRouter.navigate(SHELL_FLOW.GAME_LIBRARY)
	else:
		_show_init_error(GameData.get_load_errors())


func _show_game_library() -> void:
	_selected_game_id = ""
	_session.clear()
	var screen = GameLibraryScreenScript.new()
	screen.game_selected.connect(_on_game_selected)
	screen.settings_requested.connect(func() -> void: _open_settings(SHELL_FLOW.GAME_LIBRARY))
	_replace_screen(screen)


func _on_game_selected(game_id: String) -> void:
	if not GameData.has_game(game_id):
		push_error("AppRoot: selected unavailable game '%s'" % game_id)
		return
	_selected_game_id = game_id
	_session = _create_default_session(game_id)
	AppRouter.navigate(SHELL_FLOW.GAME_START, {"game_id": game_id})


func _show_game_start() -> void:
	if not _require_selected_game():
		return
	var screen = GameStartScreenScript.new()
	screen.configure(_selected_game_id)
	screen.back_requested.connect(func() -> void: AppRouter.navigate(SHELL_FLOW.GAME_LIBRARY))
	screen.play_requested.connect(func() -> void: AppRouter.navigate(SHELL_FLOW.LOCAL_PLAYER_SETUP))
	screen.tutorial_requested.connect(func() -> void: _open_manual_tutorial(SHELL_FLOW.GAME_START))
	screen.settings_requested.connect(func() -> void: _open_settings(SHELL_FLOW.GAME_START))
	_replace_screen(screen)


func _show_local_player_setup() -> void:
	if not _require_selected_game():
		return
	_ensure_session()
	var screen = LocalPlayerSetupScreenScript.new()
	screen.configure(_selected_game_id, _session)
	screen.back_requested.connect(func() -> void: AppRouter.navigate(SHELL_FLOW.GAME_START))
	screen.continue_requested.connect(func() -> void: AppRouter.navigate(SHELL_FLOW.MATCH_SUMMARY))
	screen.player_count_changed.connect(_change_player_count)
	screen.avatar_cycle_requested.connect(_cycle_avatar)
	screen.player_name_changed.connect(_change_player_name)
	_replace_screen(screen)


func _change_player_count(count: int) -> void:
	var config := GameData.get_game(_selected_game_id)
	var allowed: Array = config.get("player_counts", []) as Array
	if count not in allowed:
		push_error("AppRoot: invalid player count %d for %s" % [count, _selected_game_id])
		return
	_session["player_count"] = count
	_ensure_player_records(count)
	_show_local_player_setup()


func _cycle_avatar(slot: int) -> void:
	var players: Array = _session.get("players", []) as Array
	var player_count := int(_session.get("player_count", 0))
	if slot < 0 or slot >= player_count or slot >= players.size():
		return
	var roster := GameData.get_avatar_roster()
	if roster.is_empty():
		return
	var used := PackedStringArray()
	for index in range(player_count):
		if index == slot or index >= players.size():
			continue
		used.append(str((players[index] as Dictionary).get("avatar_id", "")))
	var current_id := str((players[slot] as Dictionary).get("avatar_id", ""))
	var current_index := -1
	for index in range(roster.size()):
		if str(roster[index].get("id", "")) == current_id:
			current_index = index
			break
	for offset in range(1, roster.size() + 1):
		var candidate: Dictionary = roster[(current_index + offset + roster.size()) % roster.size()]
		var candidate_id := str(candidate.get("id", ""))
		if candidate_id in used:
			continue
		(players[slot] as Dictionary)["avatar_id"] = candidate_id
		(players[slot] as Dictionary)["avatar_name"] = str(candidate.get("name", candidate_id))
		break
	_session["players"] = players
	_show_local_player_setup()


func _change_player_name(slot: int, value: String) -> void:
	var players: Array = _session.get("players", []) as Array
	if slot < 0 or slot >= players.size():
		return
	var safe_name := value.left(16)
	if safe_name.strip_edges().is_empty():
		safe_name = "Player %d" % (slot + 1)
	(players[slot] as Dictionary)["name"] = safe_name
	_session["players"] = players


func _show_match_summary() -> void:
	if not _require_selected_game():
		return
	var screen = MatchSummaryScreenScript.new()
	screen.configure(_selected_game_id, _session)
	screen.back_requested.connect(func() -> void: AppRouter.navigate(SHELL_FLOW.LOCAL_PLAYER_SETUP))
	screen.start_requested.connect(_start_match_flow)
	screen.tutorial_requested.connect(func() -> void: _open_manual_tutorial(SHELL_FLOW.MATCH_SUMMARY))
	_replace_screen(screen)


func _start_match_flow() -> void:
	_session["match_seed"] = MatchSeedService.create_seed()
	_session["stub_result"] = {}
	if not SettingsStore.is_tutorial_completed(_selected_game_id):
		_tutorial_starts_match = true
		_tutorial_return_route = SHELL_FLOW.MATCH_SUMMARY
		_tutorial_step = 0
		AppRouter.navigate(SHELL_FLOW.TUTORIAL)
		return
	AppRouter.navigate(SHELL_FLOW.COUNTDOWN)


func _open_manual_tutorial(return_route: String) -> void:
	_tutorial_starts_match = false
	_tutorial_return_route = return_route
	_tutorial_step = 0
	AppRouter.navigate(SHELL_FLOW.TUTORIAL)


func _show_tutorial() -> void:
	var screen = TutorialScreenScript.new()
	screen.configure(_selected_game_id, _tutorial_step, _tutorial_starts_match)
	screen.next_requested.connect(_tutorial_next)
	screen.skip_requested.connect(_tutorial_skip)
	_replace_screen(screen)


func _tutorial_next() -> void:
	var meta := GameData.get_game_metadata(_selected_game_id)
	var steps: Array = meta.get("tutorial_steps", []) as Array
	if steps.is_empty():
		_finish_tutorial()
		return
	if _tutorial_step < steps.size() - 1:
		_tutorial_step += 1
		_show_tutorial()
		return
	_finish_tutorial()


func _tutorial_skip() -> void:
	_finish_tutorial()


func _finish_tutorial() -> void:
	if _tutorial_starts_match:
		SettingsStore.set_tutorial_completed(_selected_game_id, true)
		_tutorial_starts_match = false
		_tutorial_step = 0
		AppRouter.navigate(SHELL_FLOW.COUNTDOWN)
		return
	var return_route := _tutorial_return_route
	_tutorial_step = 0
	AppRouter.navigate(return_route)


func _show_countdown() -> void:
	var screen = CountdownScreenScript.new()
	screen.completed.connect(func() -> void: AppRouter.navigate(SHELL_FLOW.MATCH))
	_replace_screen(screen)


func _show_match() -> void:
	if not _require_selected_game():
		return
	var screen = StubMatchScreenScript.new()
	screen.configure(_selected_game_id)
	screen.pause_requested.connect(_open_pause)
	screen.finish_requested.connect(_finish_stub_match)
	_replace_screen(screen)


func _finish_stub_match() -> void:
	_session["stub_result"] = {"development_stub": true}
	AppRouter.navigate(SHELL_FLOW.FINAL_RESULTS)


func _open_pause() -> void:
	if is_instance_valid(_pause_overlay):
		return
	_pause_overlay = PauseOverlayScript.new()
	_pause_overlay.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_pause_overlay.resume_requested.connect(_resume_from_pause)
	_pause_overlay.tutorial_requested.connect(_tutorial_from_pause)
	_pause_overlay.settings_requested.connect(_settings_from_pause)
	_pause_overlay.restart_requested.connect(_restart_from_pause)
	_pause_overlay.leave_requested.connect(_leave_from_pause)
	screen_host.add_child(_pause_overlay)
	get_tree().paused = true


func _resume_from_pause() -> void:
	_close_pause()


func _tutorial_from_pause() -> void:
	_close_pause()
	_open_manual_tutorial(SHELL_FLOW.MATCH)


func _settings_from_pause() -> void:
	_close_pause()
	_open_settings(SHELL_FLOW.MATCH)


func _restart_from_pause() -> void:
	_close_pause()
	_confirm_or_run("Restart this match?", _restart_stub_match)


func _leave_from_pause() -> void:
	_close_pause()
	_confirm_or_run("Leave this match?", func() -> void: AppRouter.navigate(SHELL_FLOW.GAME_START))


func _close_pause() -> void:
	get_tree().paused = false
	if is_instance_valid(_pause_overlay):
		_pause_overlay.queue_free()
	_pause_overlay = null


func _restart_stub_match() -> void:
	_rotate_starting_player()
	_session["match_seed"] = MatchSeedService.create_seed()
	_session["stub_result"] = {}
	AppRouter.navigate(SHELL_FLOW.COUNTDOWN)


func _show_final_results() -> void:
	var screen = FinalResultsScreenScript.new()
	screen.configure(_session)
	screen.rematch_requested.connect(_rematch)
	screen.change_players_requested.connect(func() -> void: AppRouter.navigate(SHELL_FLOW.LOCAL_PLAYER_SETUP))
	screen.library_requested.connect(func() -> void: AppRouter.navigate(SHELL_FLOW.GAME_LIBRARY))
	_replace_screen(screen)


func _rematch() -> void:
	_rotate_starting_player()
	_session["match_seed"] = MatchSeedService.create_seed()
	_session["stub_result"] = {}
	AppRouter.navigate(SHELL_FLOW.COUNTDOWN)


func _rotate_starting_player() -> void:
	var player_count := int(_session.get("player_count", 0))
	if player_count <= 0:
		return
	var current := int(_session.get("starting_player_slot", 0))
	_session["starting_player_slot"] = (current + 1) % player_count


func _open_settings(return_route: String) -> void:
	_settings_return_route = return_route
	AppRouter.navigate(SHELL_FLOW.SETTINGS)


func _show_settings() -> void:
	var screen = SettingsScreenScript.new()
	screen.close_requested.connect(func() -> void: AppRouter.navigate(_settings_return_route))
	screen.replay_tutorials_requested.connect(SettingsStore.reset_tutorials)
	_replace_screen(screen)


func _confirm_or_run(message: String, callback: Callable) -> void:
	if not bool(SettingsStore.get_value("settings", "confirm_leave_restart", true)):
		callback.call()
		return
	var dialog := ConfirmationDialog.new()
	dialog.title = "Confirm"
	dialog.dialog_text = message
	dialog.ok_button_text = "CONFIRM"
	dialog.confirmed.connect(func() -> void:
		callback.call()
		dialog.queue_free()
	)
	dialog.close_requested.connect(dialog.queue_free)
	add_child(dialog)
	dialog.popup_centered(Vector2i(520, 220))


func _create_default_session(game_id: String) -> Dictionary:
	var config := GameData.get_game(game_id)
	var counts: Array = config.get("player_counts", [2]) as Array
	var default_count := int(config.get("default_players", counts[0] if not counts.is_empty() else 2))
	if default_count not in counts and not counts.is_empty():
		default_count = int(counts[0])
	var result := {
		"game_id": game_id,
		"player_count": default_count,
		"players": [],
		"starting_player_slot": 0,
		"match_seed": 0,
		"stub_result": {},
	}
	_session = result
	_ensure_player_records(default_count)
	return _session.duplicate(true)


func _ensure_session() -> void:
	if _session.is_empty() and not _selected_game_id.is_empty():
		_session = _create_default_session(_selected_game_id)


func _ensure_player_records(required_count: int) -> void:
	var players: Array = _session.get("players", []) as Array
	var roster := GameData.get_avatar_roster()
	while players.size() < required_count:
		var slot := players.size()
		var avatar: Dictionary = roster[slot % roster.size()] if not roster.is_empty() else {"id": "", "name": "Avatar"}
		players.append({
			"slot": slot,
			"name": "Player %d" % (slot + 1),
			"avatar_id": str(avatar.get("id", "")),
			"avatar_name": str(avatar.get("name", "Avatar")),
		})
	_session["players"] = players


func _require_selected_game() -> bool:
	if not _selected_game_id.is_empty() and GameData.has_game(_selected_game_id):
		return true
	push_error("AppRoot: route requires selected game")
	if AppRouter.get_route() != SHELL_FLOW.GAME_LIBRARY:
		AppRouter.navigate(SHELL_FLOW.GAME_LIBRARY)
	return false


func _replace_screen(screen: Control, animate: bool = true) -> void:
	_close_pause()
	if is_instance_valid(_current_screen):
		_current_screen.queue_free()
	_current_screen = screen
	if animate:
		screen.modulate.a = 0.0
	screen_host.add_child(screen)
	if animate:
		var tween := create_tween()
		tween.tween_property(screen, "modulate:a", 1.0, 0.2)
