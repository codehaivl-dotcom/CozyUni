#!/usr/bin/env python3
"""Validate the locked CozyUni MVP execution task graph.

Stdlib-only on purpose so CI and cloned agent environments can run it immediately.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = ROOT / "docs" / "data" / "mvp_execution_v1.json"
PLAYBOOK_PATH = ROOT / "docs" / "MVP_EXECUTION_PLAYBOOK.md"


def fail(message: str) -> None:
    print(f"[FAIL] MVP execution: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    if not DATA_PATH.is_file():
        fail(f"missing {DATA_PATH.relative_to(ROOT)}")
    if not PLAYBOOK_PATH.is_file():
        fail(f"missing {PLAYBOOK_PATH.relative_to(ROOT)}")

    try:
        data = json.loads(DATA_PATH.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"invalid JSON: {exc}")

    if data.get("schema_version") != 1:
        fail("schema_version must be 1")
    if data.get("mvp_id") != "MVP-01":
        fail("mvp_id must be MVP-01")
    if data.get("execution_model") != "one_step_per_agent_run":
        fail("execution_model must remain one_step_per_agent_run")

    statuses = set(data.get("allowed_statuses", []))
    required_statuses = {"READY", "LOCKED", "PASS", "FAIL", "BLOCKED"}
    if not required_statuses.issubset(statuses):
        fail("allowed_statuses is missing required values")

    steps = data.get("steps")
    if not isinstance(steps, list) or not steps:
        fail("steps must be a non-empty list")

    ids: list[str] = []
    by_id: dict[str, dict] = {}
    for step in steps:
        if not isinstance(step, dict):
            fail("every step must be an object")
        step_id = step.get("id")
        if not isinstance(step_id, str) or not step_id.startswith("MVP01-S"):
            fail(f"invalid step id: {step_id!r}")
        if step_id in by_id:
            fail(f"duplicate step id: {step_id}")
        ids.append(step_id)
        by_id[step_id] = step

        status = step.get("status")
        if status not in statuses:
            fail(f"{step_id}: invalid status {status!r}")

        budget = step.get("render_budget")
        if not isinstance(budget, dict):
            fail(f"{step_id}: missing render_budget")
        for key in ("concept_images", "three_d_generations", "batch_sheets"):
            value = budget.get(key)
            if not isinstance(value, int) or value < 0:
                fail(f"{step_id}: {key} must be a non-negative integer")

        allowlist = step.get("render_allowlist")
        if not isinstance(allowlist, list):
            fail(f"{step_id}: render_allowlist must be a list")
        if sum(budget.values()) == 0 and allowlist:
            fail(f"{step_id}: zero render budget requires empty render_allowlist")

        work = step.get("work")
        gate = step.get("gate")
        if not isinstance(work, list) or not work:
            fail(f"{step_id}: work list is required")
        if not isinstance(gate, list) or not gate:
            fail(f"{step_id}: gate list is required")

    expected_ids = [f"MVP01-S{i:02d}" for i in range(11)]
    if ids != expected_ids:
        fail(f"step order must be exactly {expected_ids}")

    for index, step_id in enumerate(ids):
        next_id = by_id[step_id].get("next_step")
        expected_next = ids[index + 1] if index + 1 < len(ids) else None
        if next_id != expected_next:
            fail(f"{step_id}: next_step must be {expected_next!r}, got {next_id!r}")

    current = data.get("current_step")
    if current not in by_id:
        fail(f"current_step {current!r} does not exist")
    if by_id[current].get("status") != "READY":
        fail("current_step must have status READY")

    ready_ids = [step_id for step_id in ids if by_id[step_id].get("status") == "READY"]
    if ready_ids != [current]:
        fail(f"exactly current_step may be READY; got {ready_ids}")

    current_index = ids.index(current)
    for step_id in ids[current_index + 1 :]:
        if by_id[step_id].get("status") != "LOCKED":
            fail(f"future step {step_id} must remain LOCKED")

    cumulative = data.get("cumulative_render_budget")
    if not isinstance(cumulative, dict):
        fail("missing cumulative_render_budget")

    budget_keys = {
        "concept_images_max": "concept_images",
        "three_d_generations_max": "three_d_generations",
        "batch_sheets_max": "batch_sheets",
    }
    for max_key, step_key in budget_keys.items():
        max_value = cumulative.get(max_key)
        if not isinstance(max_value, int) or max_value < 0:
            fail(f"{max_key} must be a non-negative integer")
        planned = sum(int(step["render_budget"][step_key]) for step in steps)
        if planned > max_value:
            fail(f"planned {step_key} budget {planned} exceeds cumulative max {max_value}")

    allowed_games = data.get("game_scope", {}).get("allowed_games", [])
    if allowed_games != ["cozy_ludo"]:
        fail("MVP-01 must admit only cozy_ludo")

    allowed_maps = data.get("world_scope", {}).get("allowed_maps", [])
    if allowed_maps != ["W01_Moonberry_Village"]:
        fail("MVP-01 must admit only W01_Moonberry_Village")

    print(f"MVP execution PASS — current_step={current}, steps={len(steps)}")


if __name__ == "__main__":
    main()
