#!/usr/bin/env python3
"""Analyze CozyUni CC pack value and catalog purchasing power.

Planning only. Real store UI must use StoreKit localized prices.
"""

from __future__ import annotations

import json
from collections import Counter
from pathlib import Path


ECONOMY = Path("docs/data/economy_v1.json")
CATALOG = Path("docs/data/catalog_v1.json")


def load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> None:
    economy = load(ECONOMY)
    catalog = load(CATALOG)

    products = [p for p in economy["iap_credit_packs"] if p.get("enabled", True)]
    items = catalog["items"]
    price_counts = Counter(i["price_cc"] for i in items)

    base = min(products, key=lambda p: p["credits"])
    base_eur_per_cc = base["planning_target_eur"] / base["credits"]

    print("IAP PACK VALUE (planning prices only)")
    print("product_id | credits | target EUR | EUR/100CC | value bonus vs smallest")
    print("-----------|---------|------------|-----------|------------------------")
    for p in products:
        eur_per_100 = p["planning_target_eur"] / p["credits"] * 100
        bonus = (base_eur_per_cc / (p["planning_target_eur"] / p["credits"]) - 1.0) * 100
        print(f"{p['product_id']} | {p['credits']:>7} | {p['planning_target_eur']:>10.2f} | {eur_per_100:>9.3f} | {bonus:>7.1f}%")

    print("\nCATALOG PRICE DISTRIBUTION")
    for price in sorted(price_counts):
        print(f"{price:>4} CC : {price_counts[price]} items")

    print("\nPACK PURCHASING POWER")
    unique_prices = sorted(price_counts)
    for p in products:
        credits = p["credits"]
        print(f"\n{p['product_id']} ({credits} CC)")
        for price in unique_prices:
            count = credits // price
            leftover = credits % price
            print(f"  at {price:>3} CC/item -> {count:>2} item(s), {leftover:>3} CC left")

    cheapest = min(i["price_cc"] for i in items)
    most_expensive = max(i["price_cc"] for i in items)
    print("\nSANITY")
    print(f"Cheapest catalog item: {cheapest} CC")
    print(f"Most expensive catalog item: {most_expensive} CC")
    print(f"Smallest pack can buy at least one item: {base['credits'] >= cheapest}")


if __name__ == "__main__":
    main()
