#!/usr/bin/env python3
"""Analyze CozyUni headless simulation CSV outputs using Python stdlib only.

Required matches.csv columns:
  run_id,game_id,rules_version,seed,player_count,winner_slot,turns,duration_seconds_est,terminal_reason

Optional players.csv enables per-player/rank metrics.

Usage:
  python tools/analyze_sim_results.py matches.csv
  python tools/analyze_sim_results.py matches.csv --players players.csv --out summary.json
"""

from __future__ import annotations

import argparse
import csv
import json
import math
import statistics
from collections import Counter, defaultdict
from pathlib import Path


REQUIRED_MATCH_COLUMNS = {
    "run_id",
    "game_id",
    "rules_version",
    "seed",
    "player_count",
    "winner_slot",
    "turns",
    "duration_seconds_est",
    "terminal_reason",
}

REQUIRED_PLAYER_COLUMNS = {
    "run_id",
    "seed",
    "player_count",
    "slot",
    "rank",
    "won",
    "final_score",
}


def percentile(values: list[float], p: float) -> float:
    if not values:
        return 0.0
    xs = sorted(values)
    if len(xs) == 1:
        return xs[0]
    idx = (len(xs) - 1) * p
    lo = math.floor(idx)
    hi = math.ceil(idx)
    if lo == hi:
        return xs[lo]
    frac = idx - lo
    return xs[lo] * (1 - frac) + xs[hi] * frac


def numeric_summary(values: list[float]) -> dict:
    if not values:
        return {"count": 0}
    return {
        "count": len(values),
        "mean": statistics.fmean(values),
        "min": min(values),
        "p50": percentile(values, 0.50),
        "p90": percentile(values, 0.90),
        "p95": percentile(values, 0.95),
        "max": max(values),
    }


def read_csv(path: Path) -> tuple[list[dict[str, str]], list[str]]:
    with path.open("r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        fields = reader.fieldnames or []
        rows = list(reader)
    return rows, fields


def coerce_float(v: str) -> float | None:
    if v is None:
        return None
    s = str(v).strip()
    if s == "":
        return None
    try:
        return float(s)
    except ValueError:
        return None


def analyze_matches(path: Path) -> dict:
    rows, fields = read_csv(path)
    missing = REQUIRED_MATCH_COLUMNS - set(fields)
    if missing:
        raise SystemExit(f"{path}: missing required columns: {sorted(missing)}")
    if not rows:
        raise SystemExit(f"{path}: no rows")

    game_ids = sorted({r["game_id"] for r in rows})
    rules_versions = sorted({r["rules_version"] for r in rows})
    player_counts = sorted({int(r["player_count"]) for r in rows})

    result: dict = {
        "matches_file": str(path),
        "match_count": len(rows),
        "game_ids": game_ids,
        "rules_versions": rules_versions,
        "player_counts": player_counts,
        "by_player_count": {},
        "terminal_reasons": dict(Counter(r["terminal_reason"] for r in rows)),
    }

    numeric_fields = []
    for field in fields:
        if field in {"run_id", "game_id", "rules_version", "seed", "winner_slot", "terminal_reason"}:
            continue
        vals = [coerce_float(r.get(field, "")) for r in rows]
        if any(v is not None for v in vals):
            numeric_fields.append(field)

    result["numeric_metrics"] = {}
    for field in numeric_fields:
        vals = [v for r in rows if (v := coerce_float(r.get(field, ""))) is not None]
        result["numeric_metrics"][field] = numeric_summary(vals)

    for pc in player_counts:
        group = [r for r in rows if int(r["player_count"]) == pc]
        wins = Counter()
        draws = 0
        for r in group:
            w = r["winner_slot"].strip()
            if w == "":
                draws += 1
            else:
                wins[int(w)] += 1

        win_rates = {str(slot): wins[slot] / len(group) for slot in range(pc)}
        equal_share = 1.0 / pc
        max_adv_pp = 0.0
        if group:
            max_adv_pp = max(abs(rate - equal_share) * 100 for rate in win_rates.values())

        result["by_player_count"][str(pc)] = {
            "matches": len(group),
            "draws": draws,
            "win_rate_by_slot": win_rates,
            "equal_share_win_rate": equal_share,
            "max_absolute_slot_deviation_percentage_points": max_adv_pp,
            "turns": numeric_summary([float(r["turns"]) for r in group]),
            "duration_seconds_est": numeric_summary([float(r["duration_seconds_est"]) for r in group]),
        }

    return result


def analyze_players(path: Path) -> dict:
    rows, fields = read_csv(path)
    missing = REQUIRED_PLAYER_COLUMNS - set(fields)
    if missing:
        raise SystemExit(f"{path}: missing required columns: {sorted(missing)}")

    result = {
        "players_file": str(path),
        "row_count": len(rows),
        "numeric_metrics_by_slot": {},
    }

    excluded = {"run_id", "seed", "player_count", "slot", "won"}
    candidate_fields = [f for f in fields if f not in excluded]

    by_slot: dict[int, list[dict[str, str]]] = defaultdict(list)
    for r in rows:
        by_slot[int(r["slot"])].append(r)

    for slot, group in sorted(by_slot.items()):
        slot_out = {}
        for field in candidate_fields:
            vals = [v for r in group if (v := coerce_float(r.get(field, ""))) is not None]
            if vals:
                slot_out[field] = numeric_summary(vals)
        wins = sum(1 for r in group if str(r["won"]).strip().lower() in {"1", "true", "yes"})
        slot_out["win_rate"] = wins / len(group) if group else 0.0
        result["numeric_metrics_by_slot"][str(slot)] = slot_out

    return result


def main() -> None:
    parser = argparse.ArgumentParser(description="Analyze CozyUni simulation outputs")
    parser.add_argument("matches", type=Path)
    parser.add_argument("--players", type=Path)
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()

    result = {"matches": analyze_matches(args.matches)}
    if args.players:
        result["players"] = analyze_players(args.players)

    text = json.dumps(result, indent=2, sort_keys=True)
    if args.out:
        args.out.write_text(text + "\n", encoding="utf-8")
        print(f"Wrote {args.out}")
    else:
        print(text)


if __name__ == "__main__":
    main()
