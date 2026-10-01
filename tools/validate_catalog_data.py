#!/usr/bin/env python3
"""Validate CozyUni catalog_v1.json against economy_v1.json."""

from __future__ import annotations

import json
from pathlib import Path


ECONOMY = Path("docs/data/economy_v1.json")
CATALOG = Path("docs/data/catalog_v1.json")
VALID_GAMES = {"shared", "cozy_ludo", "cozy_caro", "cozy_journey", "cozy_chess", "cozy_tycoon"}


class ValidationError(Exception):
    pass


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise ValidationError(msg)


def load(path: Path) -> dict:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        raise ValidationError(f"{path}: invalid JSON: {exc}") from exc
    require(isinstance(value, dict), f"{path}: top level must be object")
    return value


def main() -> None:
    economy = load(ECONOMY)
    catalog = load(CATALOG)

    require(catalog.get("schema_version") == 1, "catalog schema_version must be 1")
    require(catalog.get("currency") == economy["currency"]["code"] == "CC", "catalog/economy currency mismatch")

    allowed_types = set(economy["allowed_catalog_types"])
    bands = economy["catalog_price_bands_cc"]
    items = catalog.get("items") or []
    require(items, "catalog must contain items")

    ids = set()
    display_keys = set()
    for item in items:
        iid = item.get("id")
        require(isinstance(iid, str) and iid, "catalog id must be non-empty string")
        require(iid not in ids, f"duplicate catalog id: {iid}")
        ids.add(iid)

        item_type = item.get("type")
        require(item_type in allowed_types, f"{iid}: disallowed catalog type {item_type}")

        band = item.get("price_band")
        require(band in bands, f"{iid}: unknown price band {band}")
        require(item.get("price_cc") == bands[band], f"{iid}: price_cc must equal band {band}={bands[band]}")
        require(isinstance(item.get("active"), bool), f"{iid}: active must be bool")
        require(isinstance(item.get("stackable"), bool), f"{iid}: stackable must be bool")

        key = item.get("display_key")
        require(isinstance(key, str) and key, f"{iid}: display_key required")
        require(key not in display_keys, f"duplicate display_key: {key}")
        display_keys.add(key)

        preview = item.get("preview_asset_id")
        require(isinstance(preview, str) and preview, f"{iid}: preview_asset_id required")

        game_ids = item.get("game_ids")
        require(isinstance(game_ids, list) and game_ids, f"{iid}: game_ids required")
        require(set(game_ids).issubset(VALID_GAMES), f"{iid}: invalid game_id in {game_ids}")

    active_count = sum(1 for i in items if i["active"])
    print(f"PASS: {CATALOG}")
    print(f"items={len(items)} active={active_count} unique_ids={len(ids)}")
    print("Catalog matches economy price bands and allowed types.")


if __name__ == "__main__":
    try:
        main()
    except ValidationError as exc:
        raise SystemExit(f"FAIL: {exc}")
