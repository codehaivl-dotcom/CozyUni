class_name LudoRules
extends RefCounted

const PHASE_AWAITING_ROLL := "awaiting_roll"
const PHASE_AWAITING_PIECE_SELECTION := "awaiting_piece_selection"
const PHASE_MATCH_END := "match_end"


static func create_initial_state(config: Dictionary, player_count: int, starting_slot: int) -> Dictionary:
	var pieces_per_player := int(config.get("pieces_per_player", 0))
	var active_on_start := int((config.get("start_state", {}) as Dictionary).get("active_on_start_safe", 0))
	var yard_count := int((config.get("start_state", {}) as Dictionary).get("in_yard", 0))
	assert(pieces_per_player == active_on_start + yard_count)
	assert(starting_slot >= 0 and starting_slot < player_count)

	var players: Array = []
	var colors: Array = config.get("player_colors", []) as Array
	for slot in range(player_count):
		var pieces: Array = []
		for index in range(pieces_per_player):
			pieces.append(1 if index < active_on_start else 0)
		players.append({
			"slot": slot,
			"color": str(colors[slot]) if slot < colors.size() else "",
			"pieces": pieces,
			"captures_made": 0,
		})

	return {
		"revision": 0,
		"starting_player_slot": starting_slot,
		"turn_index": starting_slot,
		"phase": PHASE_AWAITING_ROLL,
		"last_roll": 0,
		"roll_is_bonus": false,
		"bonus_roll_pending": false,
		"bonus_used_this_turn": false,
		"legal_piece_indices": [],
		"players": players,
		"winner_slot": -1,
		"ranking": [],
		"turn_number": 1,
	}


static func get_legal_piece_indices(state: Dictionary, config: Dictionary, player_slot: int, roll: int) -> Array[int]:
	var result: Array[int] = []
	var players: Array = state.get("players", []) as Array
	if player_slot < 0 or player_slot >= players.size():
		return result
	var player := players[player_slot] as Dictionary
	var pieces: Array = player.get("pieces", []) as Array
	for piece_index in range(pieces.size()):
		if is_piece_move_legal(state, config, player_slot, piece_index, roll):
			result.append(piece_index)
	return result


static func is_piece_move_legal(state: Dictionary, config: Dictionary, player_slot: int, piece_index: int, roll: int) -> bool:
	var players: Array = state.get("players", []) as Array
	if player_slot < 0 or player_slot >= players.size():
		return false
	var player := players[player_slot] as Dictionary
	var pieces: Array = player.get("pieces", []) as Array
	if piece_index < 0 or piece_index >= pieces.size():
		return false
	var progress := int(pieces[piece_index])
	var home := int((config.get("progress_values", {}) as Dictionary).get("home", 58))
	if progress >= home:
		return false

	var deploy_roll := int((config.get("dice", {}) as Dictionary).get("deploy_roll", 6))
	var target_progress := progress
	if progress == 0:
		if roll != deploy_roll:
			return false
		target_progress = 1
	else:
		target_progress = min(progress + roll, home)

	if target_progress == home:
		return true

	for other_index in range(pieces.size()):
		if other_index == piece_index:
			continue
		if int(pieces[other_index]) == target_progress:
			return false
	return true


static func apply_piece_move(state: Dictionary, config: Dictionary, player_slot: int, piece_index: int, roll: int) -> Array[Dictionary]:
	var events: Array[Dictionary] = []
	if not is_piece_move_legal(state, config, player_slot, piece_index, roll):
		return events

	var players: Array = state.get("players", []) as Array
	var player := players[player_slot] as Dictionary
	var pieces: Array = player.get("pieces", []) as Array
	var from_progress := int(pieces[piece_index])
	var home := int((config.get("progress_values", {}) as Dictionary).get("home", 58))
	var to_progress: int = 1 if from_progress == 0 else mini(from_progress + roll, home)
	pieces[piece_index] = to_progress
	player["pieces"] = pieces
	players[player_slot] = player
	state["players"] = players

	events.append({
		"type": "piece_moved",
		"player_slot": player_slot,
		"piece_index": piece_index,
		"from_progress": from_progress,
		"to_progress": to_progress,
	})

	if to_progress >= 1 and to_progress <= 52:
		var absolute := absolute_cell(config, player_slot, to_progress)
		if not is_safe_absolute_cell(config, absolute):
			var captured := _capture_enemy_on_cell(state, config, player_slot, absolute)
			if not captured.is_empty():
				events.append(captured)

	if to_progress == home:
		events.append({"type": "piece_home", "player_slot": player_slot, "piece_index": piece_index})

	if all_pieces_home(state, config, player_slot):
		state["winner_slot"] = player_slot
		state["phase"] = PHASE_MATCH_END
		state["ranking"] = compute_ranking(state, config)
		events.append({"type": "match_won", "player_slot": player_slot})

	return events


static func absolute_cell(config: Dictionary, player_slot: int, progress: int) -> int:
	if progress < 1 or progress > 52:
		return -1
	var board := config.get("board", {}) as Dictionary
	var starts: Array = board.get("start_indices", []) as Array
	if player_slot < 0 or player_slot >= starts.size():
		return -1
	var loop_cells := int(board.get("outer_loop_cells", 52))
	return (int(starts[player_slot]) + progress - 1) % loop_cells


static func is_safe_absolute_cell(config: Dictionary, absolute_cell_index: int) -> bool:
	var safe_cells: Array = (config.get("board", {}) as Dictionary).get("safe_cells", []) as Array
	return absolute_cell_index in safe_cells


static func all_pieces_home(state: Dictionary, config: Dictionary, player_slot: int) -> bool:
	var players: Array = state.get("players", []) as Array
	if player_slot < 0 or player_slot >= players.size():
		return false
	var pieces: Array = (players[player_slot] as Dictionary).get("pieces", []) as Array
	var home := int((config.get("progress_values", {}) as Dictionary).get("home", 58))
	var required := int((config.get("win", {}) as Dictionary).get("home_pieces_required", pieces.size()))
	var home_count := 0
	for progress: Variant in pieces:
		if int(progress) == home:
			home_count += 1
	return home_count >= required


static func compute_ranking(state: Dictionary, config: Dictionary) -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	var players: Array = state.get("players", []) as Array
	var home := int((config.get("progress_values", {}) as Dictionary).get("home", 58))
	for slot in range(players.size()):
		var player := players[slot] as Dictionary
		var pieces: Array = player.get("pieces", []) as Array
		var home_count := 0
		var total_progress := 0
		var pieces_in_yard := 0
		for progress_value: Variant in pieces:
			var progress := int(progress_value)
			total_progress += progress
			if progress == home:
				home_count += 1
			elif progress == 0:
				pieces_in_yard += 1
		rows.append({
			"slot": slot,
			"home_count": home_count,
			"total_progress": total_progress,
			"captures_made": int(player.get("captures_made", 0)),
			"pieces_in_yard": pieces_in_yard,
		})

	rows.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var winner := int(state.get("winner_slot", -1))
		if int(a["slot"]) == winner and int(b["slot"]) != winner:
			return true
		if int(b["slot"]) == winner and int(a["slot"]) != winner:
			return false
		if int(a["home_count"]) != int(b["home_count"]):
			return int(a["home_count"]) > int(b["home_count"])
		if int(a["total_progress"]) != int(b["total_progress"]):
			return int(a["total_progress"]) > int(b["total_progress"])
		if int(a["captures_made"]) != int(b["captures_made"]):
			return int(a["captures_made"]) > int(b["captures_made"])
		if int(a["pieces_in_yard"]) != int(b["pieces_in_yard"]):
			return int(a["pieces_in_yard"]) < int(b["pieces_in_yard"])
		return int(a["slot"]) < int(b["slot"])
	)

	var previous: Dictionary = {}
	var rank := 0
	for index in range(rows.size()):
		var row := rows[index]
		if index == 0:
			rank = 1
		elif not _same_rank_metrics(previous, row):
			rank = index + 1
		row["rank"] = rank
		row["shared_rank"] = index > 0 and _same_rank_metrics(previous, row)
		rows[index] = row
		previous = row
	return rows


static func _capture_enemy_on_cell(state: Dictionary, config: Dictionary, moving_slot: int, absolute: int) -> Dictionary:
	var players: Array = state.get("players", []) as Array
	for enemy_slot in range(players.size()):
		if enemy_slot == moving_slot:
			continue
		var enemy := players[enemy_slot] as Dictionary
		var enemy_pieces: Array = enemy.get("pieces", []) as Array
		for enemy_piece_index in range(enemy_pieces.size()):
			var progress := int(enemy_pieces[enemy_piece_index])
			if progress < 1 or progress > 52:
				continue
			if absolute_cell(config, enemy_slot, progress) != absolute:
				continue
			enemy_pieces[enemy_piece_index] = 0
			enemy["pieces"] = enemy_pieces
			players[enemy_slot] = enemy
			var mover := players[moving_slot] as Dictionary
			mover["captures_made"] = int(mover.get("captures_made", 0)) + 1
			players[moving_slot] = mover
			state["players"] = players
			return {
				"type": "piece_captured",
				"by_player_slot": moving_slot,
				"captured_player_slot": enemy_slot,
				"captured_piece_index": enemy_piece_index,
				"absolute_cell": absolute,
			}
	return {}


static func _same_rank_metrics(a: Dictionary, b: Dictionary) -> bool:
	if a.is_empty() or b.is_empty():
		return false
	return (
		int(a.get("home_count", -1)) == int(b.get("home_count", -2))
		and int(a.get("total_progress", -1)) == int(b.get("total_progress", -2))
		and int(a.get("captures_made", -1)) == int(b.get("captures_made", -2))
		and int(a.get("pieces_in_yard", -1)) == int(b.get("pieces_in_yard", -2))
	)
