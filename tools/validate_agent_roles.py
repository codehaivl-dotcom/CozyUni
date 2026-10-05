#!/usr/bin/env python3
"""Validate CozyUni role registry, Codex role configs, and MVP role assignments."""

from __future__ import annotations

import json
import sys
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROLE_PATH = ROOT / "docs" / "data" / "agent_roles_v1.json"
ASSIGN_PATH = ROOT / "docs" / "data" / "mvp_role_assignments_v1.json"
MVP_PATH = ROOT / "docs" / "data" / "mvp_execution_v1.json"
WORKFLOW_PATH = ROOT / "docs" / "agents" / "00_MULTI_AGENT_WORKFLOW.md"


def fail(message: str) -> None:
    print(f"[FAIL] agent roles: {message}", file=sys.stderr)
    raise SystemExit(1)


def load_json(path: Path) -> dict:
    if not path.is_file():
        fail(f"missing {path.relative_to(ROOT)}")
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"invalid JSON in {path.relative_to(ROOT)}: {exc}")
    if not isinstance(data, dict):
        fail(f"{path.relative_to(ROOT)} must contain an object")
    return data


def main() -> None:
    if not WORKFLOW_PATH.is_file():
        fail(f"missing {WORKFLOW_PATH.relative_to(ROOT)}")

    registry = load_json(ROLE_PATH)
    assignments = load_json(ASSIGN_PATH)
    mvp = load_json(MVP_PATH)

    if registry.get("schema_version") != 1:
        fail("agent_roles schema_version must be 1")
    if assignments.get("schema_version") != 1:
        fail("mvp_role_assignments schema_version must be 1")
    if assignments.get("mvp_id") != "MVP-01":
        fail("role assignments must target MVP-01")

    roles = registry.get("roles")
    if not isinstance(roles, list) or not roles:
        fail("roles must be a non-empty list")

    role_ids: set[str] = set()
    for role in roles:
        if not isinstance(role, dict):
            fail("each role must be an object")
        role_id = role.get("id")
        if not isinstance(role_id, str) or not role_id:
            fail("role id must be a non-empty string")
        if role_id in role_ids:
            fail(f"duplicate role id: {role_id}")
        role_ids.add(role_id)

        config_file = role.get("config_file")
        if not isinstance(config_file, str) or not config_file.startswith(".codex/agents/"):
            fail(f"{role_id}: invalid config_file")
        config_path = ROOT / config_file
        if not config_path.is_file():
            fail(f"{role_id}: missing {config_file}")
        try:
            config = tomllib.loads(config_path.read_text(encoding="utf-8"))
        except tomllib.TOMLDecodeError as exc:
            fail(f"{role_id}: invalid TOML: {exc}")
        instructions = config.get("developer_instructions")
        if not isinstance(instructions, str) or "Role purpose:" not in instructions:
            fail(f"{role_id}: developer_instructions must contain Role purpose")

        if not isinstance(role.get("may_write"), bool):
            fail(f"{role_id}: may_write must be boolean")
        if not isinstance(role.get("purpose"), str) or not role["purpose"]:
            fail(f"{role_id}: purpose is required")

    required_roles = {
        "producer",
        "game-designer",
        "lead-programmer",
        "godot-specialist",
        "gameplay-programmer",
        "ux-designer",
        "ui-programmer",
        "art-director",
        "level-designer",
        "world-builder",
        "asset-pipeline-specialist",
        "qa-lead",
        "performance-analyst",
        "devops-engineer",
        "accessibility-specialist",
        "release-manager",
    }
    if role_ids != required_roles:
        fail(f"role registry must contain exactly {sorted(required_roles)}")

    steps = mvp.get("steps")
    if not isinstance(steps, list) or not steps:
        fail("MVP steps missing")
    step_ids = [step.get("id") for step in steps]

    rows = assignments.get("assignments")
    if not isinstance(rows, list):
        fail("assignments must be a list")
    assigned_ids = [row.get("step_id") for row in rows]
    if assigned_ids != step_ids:
        fail("role assignment step order must exactly match MVP execution step order")

    for row in rows:
        step_id = row["step_id"]
        lead = row.get("lead_role")
        support = row.get("support_roles")
        review = row.get("review_roles")
        escalation = row.get("escalation_roles")
        if lead not in role_ids:
            fail(f"{step_id}: invalid lead_role {lead!r}")
        for field_name, values in (("support_roles", support), ("review_roles", review), ("escalation_roles", escalation)):
            if not isinstance(values, list):
                fail(f"{step_id}: {field_name} must be a list")
            if len(values) != len(set(values)):
                fail(f"{step_id}: duplicate roles in {field_name}")
            unknown = [role for role in values if role not in role_ids]
            if unknown:
                fail(f"{step_id}: unknown roles in {field_name}: {unknown}")
        if not review:
            fail(f"{step_id}: at least one review role is required")
        active = [lead] + support + review
        if len(active) != len(set(active)):
            fail(f"{step_id}: lead/support/review roles must be disjoint")
        if "qa-lead" not in active and step_id != "MVP01-S03":
            fail(f"{step_id}: qa-lead must participate in every step except the read-only camera shortlist review step")

    print(f"Agent roles PASS — roles={len(role_ids)}, step_assignments={len(rows)}")


if __name__ == "__main__":
    main()
