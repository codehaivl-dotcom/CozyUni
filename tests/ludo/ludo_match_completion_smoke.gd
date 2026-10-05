extends SceneTree

const LudoMatchScript = preload("res://src/modes/cozy_ludo/ludo_match.gd")
const CONFIG_PATH := "res://data/games/ludo_v1.json"
const RUNS_PER_PLAYER_COUNT := 100
const MAX_ACTIONS_PER_MATCH := 5000

var _config: Dictionary = {}
var _failures := 0


func _initialize() -> void:
	_config = _load_config()
	if _config.is_empty():
		push_error("Ludo completion smoke FAILED: runtime config missing")
		quit(1)
		return

	for player_count in [2, 3, 4]:
		_run_batch(player_count)

	if _failures > 0:
		push_error("Ludo completion smoke FAILED: %d match(es)" % _failures)
		quit(1)
		return
	print("Ludo completion smoke PASS: %d deterministic matches" % (RUNS_PER_PLAYER_COUNT * 3))
	quit(0)


func _load_config() -> Dictionary:
	if not FileAccess.file_exists(CONFIG_PATH):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(CONFIG_PATH))
	return parsed as Dictionary if parsed is Dictionary else {}


func _run_batch(player_count: int) -> void:
	for run_index in range(RUNS_PER_PLAYER_COUNT):
		var seed_value := 1000000 + player_count * 10000 + run_index
		var match_obj = LudoMatchScript.new(_config, player_count, seed_value)
		var actions := 0
		while not match_obj.is_finished() and actions < MAX_ACTIONS_PER_MATCH:
			var state: Dictionary = match_obj.get_public_state()
			var slot := int(state.get("turn_index", -1))
			var legal_actions: Array[Dictionary] = match_obj.get_legal_actions(slot)
			if legal_actions.is_empty():
				_failures += 1
				push_error("Ludo completion failed: no legal action, players=%d seed=%d revision=%d phase=%s" % [
					player_count,
					seed_value,
					int(state.get("revision", -1)),
					str(state.get("phase", "")),
				])
				break
			var action: Dictionary = legal_actions[0]
			var result: Dictionary = match_obj.submit_action(action, int(state.get("revision", 0)))
			if not bool(result.get("accepted", false)):
				_failures += 1
				push_error("Ludo completion failed: rejected legal action, players=%d seed=%d reason=%s" % [
					player_count,
					seed_value,
					str(result.get("reason", "UNKNOWN")),
				])
				break
			actions += 1

		if not match_obj.is_finished():
			if actions >= MAX_ACTIONS_PER_MATCH:
				_failures += 1
				push_error("Ludo completion failed: action cap reached, players=%d seed=%d" % [player_count, seed_value])
			continue

		var payload: Dictionary = match_obj.get_result_payload()
		var ranking: Array = payload.get("ranking", []) as Array
		if ranking.size() != player_count:
			_failures += 1
			push_error("Ludo completion failed: ranking size mismatch, players=%d seed=%d got=%d" % [player_count, seed_value, ranking.size()])
			continue
		if int(payload.get("winner_slot", -1)) < 0 or int(payload.get("winner_slot", -1)) >= player_count:
			_failures += 1
			push_error("Ludo completion failed: invalid winner, players=%d seed=%d" % [player_count, seed_value])
