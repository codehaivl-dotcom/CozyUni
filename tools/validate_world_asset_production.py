#!/usr/bin/env python3
"""Validate CozyUni's locked 150-slot world asset harvest production registry.

This validator only confirms static documentation consistency. It DOES NOT
certify commercial rights, local binary source files, W01 scene existence,
Godot import, live Tripo credits, or readiness to execute paid jobs.
"""
from __future__ import annotations

import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / "docs/data/world_asset_production_lock_v1.json"
MASTER = ROOT / "docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md"
DOC = ROOT / "docs/assets/09_WORLD_ASSET_PRODUCTION_LOCK.md"
STAGES = {"A": 48, "B": 52, "C": 25, "D": 15, "E": 10}
FACES = {"small": 5000, "common": 10000, "hero": 20000}
ZONES = {
    "ENTRANCE", "MAIN_STREET", "SQUARE", "SQUARE_TOWN_HALL",
    "SHOP_STREET", "PARK_LUDO", "RESIDENTIAL",
}
COLLISIONS = {
    "BUILDING_SIMPLIFIED", "TRUNK_ONLY", "SIMPLE_PRIMITIVE_IF_BLOCKING",
    "SIMPLE_PRIMITIVE", "DECORATION_NO_COLLISION", "NO_COLLISION",
}
LINE = re.compile(
    r"^- \[ \] (AST-\d{3}) \| ([^|]+) \| ([^|]+) \| ([A-Z]) \| (.+)$"
)


def validate() -> None:
    assert PATH.is_file() and MASTER.is_file() and DOC.is_file()
    d = json.loads(PATH.read_text(encoding="utf-8"))
    assert d["schema_version"] == 1
    assert d["status"] == "SPEC_LOCKED_PRESPEND_GATES_PENDING"
    assert d["tripo_lock"]["model"] == "P1-20260311"
    assert d["tripo_lock"]["face_profiles"] == FACES
    catalog = {}
    for line in MASTER.read_text(encoding="utf-8").splitlines():
        match = LINE.match(line)
        if match:
            assert match[1] not in catalog, match[1]
            catalog[match[1]] = tuple(x.strip() for x in match.groups()[1:])
    assert len(catalog) == 296, len(catalog)
    entries = d["entries"]
    assert len(entries) == 150
    counts = Counter(e["stage"] for e in entries)
    assert counts == Counter(STAGES), counts
    ids = [e["asset_id"] for e in entries]
    assert len(set(ids)) == 150
    assert [e["queue_index"] for e in entries] == list(range(1, 151))
    for e in entries:
        aid = e["asset_id"]
        assert aid in catalog, aid
        name, category, template, item = catalog[aid]
        assert (e["canonical_name"], e["canonical_category"],
                e["prompt_template"], e["canonical_item_text"]) == (
                    name, category, template, item
                ), aid
        assert e["model"] == "P1-20260311"
        assert e["face_profile"] in FACES
        assert e["texture_quality"] == "detailed"
        assert e["expected_cost_credits"] == 60
        assert e["asset_state"] == "SPEC_LOCKED_PENDING_PREFLIGHT"
        assert e["cost_status"] == "ESTIMATE_NOT_CHARGED"
        assert e["collision_policy"] in COLLISIONS
        sizes = e["footprint_contract_m"]
        assert set(sizes) == {"width_x", "depth_z", "height_y"}
        assert all(isinstance(x, (float, int)) and x > 0 for x in sizes.values())
        if e["stage"] == "A":
            assert e["placement_zone"] in ZONES, aid
        else:
            assert e["placement_zone"].endswith("_BANK"), aid
        assert isinstance(e["target_regions"], list) and e["target_regions"], aid
        assert len(e["target_regions"]) == len(set(e["target_regions"])), aid
        assert all(re.fullmatch(r"W0[1-8]", x) for x in e["target_regions"]), aid
        assert isinstance(e["production_use_case"], str) and len(e["production_use_case"]) > 15, aid
        assert isinstance(e["planned_instance_count"], int) and e["planned_instance_count"] >= 1, aid
        assert e["placement_rule"].startswith("Stage A:"), aid
        if e["stage"] == "A":
            assert e["target_regions"] == ["W01"], aid
        assert e["output_contract"].endswith(f"/{aid}.glb")
        assert e["wrapper_contract"].endswith(f"/{aid}.tscn")

    print("PASS: 296 master AST entries / 150 unique locked production slots")
    print("PASS: A48 B52 C25 D15 E10 / prompts / roles / regions / profiles / colliders")
    print("NOTE: static registry validation != readiness for paid generation")


if __name__ == "__main__":
    validate()
