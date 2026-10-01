#!/usr/bin/env python3
"""Validate CozyUni machine-readable game data against structural invariants.

This does not replace gameplay-rule tests. It catches data drift before runtime/simulation.

Usage:
  python tools/validate_game_data.py
"""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path("docs/data/games")


class ValidationError(Exception):
    pass


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise ValidationError(msg)


def load(name: str) -> dict:
    path = ROOT / name
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        raise ValidationError(f"{path}: invalid JSON: {exc}") from exc
    require(data.get("schema_version") == 1, f"{path}: schema_version must be 1")
    return data


def validate_ludo(d: dict) -> None:
    require(d["game_id"] == "cozy_ludo", "ludo game_id mismatch")
    require(d["pieces_per_player"] == d["start_state"]["active_on_start_safe"] + d["start_state"]["in_yard"], "ludo starting piece counts must sum to pieces_per_player")
    board = d["board"]
    n = board["outer_loop_cells"]
    starts = board["start_indices"]
    safe = board["safe_cells"]
    stars = board["star_safe_cells"]
    require(n == 52, "ludo outer loop must remain 52")
    require(starts == [0, 13, 26, 39], "ludo start indices drifted")
    require(len(set(starts)) == 4, "ludo start indices must be unique")
    require(all(0 <= x < n for x in safe), "ludo safe cell out of range")
    require(set(stars).issubset(set(safe)), "ludo star safe cells must be safe")
    require(d["dice"]["sides"] == 6 and d["dice"]["deploy_roll"] == 6, "ludo D6/deploy rule drifted")
    p = d["progress_values"]
    require((p["outer_loop_min"], p["outer_loop_max"]) == (1, 52), "ludo outer progress mismatch")
    require((p["home_lane_min"], p["home_lane_max"]) == (53, 57), "ludo home lane progress mismatch")
    require(p["home"] == 58, "ludo home progress mismatch")
    require(d["bonus_roll"]["max_bonus_rolls_per_turn"] == 1, "ludo bonus max must remain one")


def validate_caro(d: dict) -> None:
    require(d["game_id"] == "cozy_caro", "caro game_id mismatch")
    require(d["player_counts"] == [2], "caro must remain 2P")
    t = d["presets"]["tic_tac_toe_3x3"]
    require(t["board_size"] == 3 and t["rounds_per_match"] == 3 and t["win_length"] == 3, "tic-tac-toe lock drifted")
    require(abs(t["round_win_points"] - 1.0) < 1e-9, "tic-tac-toe win points drifted")
    require(abs(t["round_draw_points_each"] - 0.5) < 1e-9, "tic-tac-toe draw points drifted")
    f = d["presets"]["five_in_a_row_15x15"]
    require(f["board_size"] == 15, "five-in-a-row board must remain 15")
    require(f["cells_total"] == f["board_size"] ** 2, "five-in-a-row cells_total mismatch")
    require(f["win_length_min"] == 5 and f["overline_counts"] is True, "Freestyle Five win rule drifted")
    require(f["exact_five_required"] is False and f["renju_restrictions"] is False, "Caro variant drifted")


def validate_journey(d: dict) -> None:
    require(d["game_id"] == "cozy_journey", "journey game_id mismatch")
    board = d["board"]
    require(board["spaces"] == 36, "journey spaces must remain 36")
    covered = []
    last_end = 0
    for region in board["regions"]:
        require(region["start"] == last_end + 1, "journey regions must be contiguous")
        require(region["end"] >= region["start"], "journey region invalid")
        covered.extend(range(region["start"], region["end"] + 1))
        last_end = region["end"]
    require(covered == list(range(1, 37)), "journey regions must cover exactly 1..36")
    specials = d["special_spaces"]
    spaces = [s["space"] for s in specials]
    require(len(specials) == 9 and len(set(spaces)) == 9, "journey must have exactly 9 unique specials")
    require(all(1 <= s <= 36 for s in spaces), "journey special out of range")
    require(d["finish"]["target_space"] == 36 and d["finish"]["exact_roll_required"] is False, "journey finish rule drifted")
    picnic = next(x for x in specials if x["space"] == 14)
    require(picnic["effect"] == "extra_roll" and picnic["count"] == 1, "journey picnic rule drifted")


def validate_chess(d: dict) -> None:
    require(d["game_id"] == "cozy_chess", "chess game_id mismatch")
    require(d["player_counts"] == [2], "chess must remain 2P")
    board = d["board"]
    require(board["files"] == 8 and board["ranks"] == 8 and board["a1_color"] == "dark", "chess board lock drifted")
    rules = d["rules"]
    require(rules["promotion"]["choices"] == ["queen", "rook", "bishop", "knight"], "promotion choices drifted")
    require(rules["promotion"]["auto_queen"] is False, "auto queen must remain off")
    require(rules["draw"]["fifty_move_halfmoves"] == 100, "50-move halfmove count must remain 100")
    require(rules["clock"] is False and rules["bots"] is False, "v1 chess clock/bot scope drifted")


def validate_tycoon(d: dict) -> None:
    require(d["game_id"] == "cozy_tycoon", "tycoon game_id mismatch")
    require(d["rounds"] == 12, "tycoon must remain 12 rounds")
    require(d["starting_state"]["coins"] == 100, "tycoon start coins drifted")
    require(d["core_rules"]["bankruptcy"] is False and d["core_rules"]["elimination"] is False, "tycoon no-bankruptcy rule drifted")

    nodes = d["board_nodes"]
    require(len(nodes) == 28, "tycoon must have 28 nodes")
    require([n["node"] for n in nodes] == list(range(28)), "tycoon node indices must be 0..27")

    properties = d["properties"]
    require(len(properties) == 12, "tycoon must have 12 properties")
    district_names = [p for names in d["districts"].values() for p in names]
    require(len(district_names) == 12 and len(set(district_names)) == 12, "district property membership must be unique")
    require(set(district_names) == set(properties), "district/property table mismatch")

    board_property_names = {n["name"] for n in nodes if n["type"] == "PROPERTY"}
    require(board_property_names == set(properties), "board PROPERTY nodes mismatch property table")

    for name, p in properties.items():
        require(p["buy"] > 0 and p["l1_cost"] > 0 and p["l2_cost"] > 0, f"{name}: costs must be positive")
        require(p["income_l0"] < p["income_l1"] < p["income_l2"], f"{name}: incomes must strictly increase")
        require(name in d["districts"][p["district"]], f"{name}: district mismatch")

    transports = d["transports"]
    board_transports = {n["name"] for n in nodes if n["type"] == "TRANSPORT"}
    require(board_transports == set(transports["names"]), "transport node/name mismatch")
    require(transports["buy_price"] == 30, "transport buy price drifted")
    require(transports["fast_travel"]["delta_nodes"] == 4 and transports["fast_travel"]["max_per_turn"] == 1, "fast travel rule drifted")

    require(set(d["community"]["nodes"]) == {5, 17, 24}, "community nodes drifted")
    require(d["community"]["contribution_cost"] == 10 and d["community"]["max_stars"] == 3, "community rule drifted")

    cards = d["event_deck"]["cards"]
    require(len(cards) == 12, "tycoon must have exactly 12 event cards")
    require([c["id"] for c in cards] == list(range(1, 13)), "event card ids must be 1..12")

    trade = d["trade"]
    require(trade["max_proposals_per_turn"] == 1 and trade["counteroffer"] is False, "trade scope drifted")
    require(trade["recipient_timeout_seconds"] == 20, "trade timeout drifted")


def main() -> None:
    validators = [
        ("ludo_v1.json", validate_ludo),
        ("caro_v1.json", validate_caro),
        ("journey_v1.json", validate_journey),
        ("chess_v1.json", validate_chess),
        ("tycoon_v1.json", validate_tycoon),
    ]
    for name, fn in validators:
        data = load(name)
        fn(data)
        print(f"PASS: {ROOT / name}")
    print("All CozyUni game data structural invariants passed.")


if __name__ == "__main__":
    try:
        main()
    except ValidationError as exc:
        raise SystemExit(f"FAIL: {exc}")
