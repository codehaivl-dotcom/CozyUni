#!/usr/bin/env python3
"""CozyUni economy scenario simulator.

Uses only Python stdlib. This is a planning tool, not a revenue forecast.
The simulation target prices in economy_v1.json are planning inputs only;
production UI must use StoreKit localized pricing.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def load_config(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def weighted_average_packs(cfg: dict) -> tuple[float, float]:
    products = {p["product_id"]: p for p in cfg["iap_credit_packs"] if p.get("enabled", True)}
    mix = cfg["simulation_defaults"]["pack_mix"]
    total_weight = sum(mix.values())
    if total_weight <= 0:
        raise ValueError("pack_mix total must be > 0")
    avg_price = 0.0
    avg_credits = 0.0
    for product_id, weight in mix.items():
        if product_id not in products:
            raise ValueError(f"pack_mix references unknown/disabled product: {product_id}")
        w = weight / total_weight
        avg_price += products[product_id]["planning_target_eur"] * w
        avg_credits += products[product_id]["credits"] * w
    return avg_price, avg_credits


def calculate(cfg: dict, mau: int, payer_rate: float, purchases_per_payer: float,
              refund_rate: float, commission_rate: float) -> dict:
    avg_price, avg_credits = weighted_average_packs(cfg)
    payers = mau * payer_rate
    purchases = payers * purchases_per_payer
    gross = purchases * avg_price
    after_refunds = gross * (1.0 - refund_rate)
    proceeds_est = after_refunds * (1.0 - commission_rate)
    credits_issued = purchases * avg_credits
    return {
        "mau": mau,
        "payer_rate": payer_rate,
        "payers": payers,
        "purchases": purchases,
        "avg_pack_price_eur": avg_price,
        "avg_pack_credits": avg_credits,
        "gross_eur": gross,
        "after_refunds_eur": after_refunds,
        "commission_rate": commission_rate,
        "proceeds_estimate_eur": proceeds_est,
        "credits_issued": credits_issued,
        "gross_arppu_eur": (gross / payers) if payers else 0.0,
        "credits_per_payer": (credits_issued / payers) if payers else 0.0,
    }


def print_result(r: dict) -> None:
    print(f"MAU: {r['mau']:,.0f}")
    print(f"Payer rate: {r['payer_rate']*100:.2f}%")
    print(f"Payers: {r['payers']:,.1f}")
    print(f"Purchases: {r['purchases']:,.1f}")
    print(f"Avg pack: €{r['avg_pack_price_eur']:.2f} / {r['avg_pack_credits']:.0f} CC")
    print(f"Gross: €{r['gross_eur']:,.2f}")
    print(f"After refunds: €{r['after_refunds_eur']:,.2f}")
    print(f"Commission assumption: {r['commission_rate']*100:.0f}%")
    print(f"Estimated proceeds after modeled refunds/commission: €{r['proceeds_estimate_eur']:,.2f}")
    print(f"Gross ARPPU: €{r['gross_arppu_eur']:.2f}")
    print(f"Credits issued: {r['credits_issued']:,.0f} CC")
    print(f"Credits / payer: {r['credits_per_payer']:,.0f} CC")


def print_matrix(cfg: dict, mau: int, purchases_per_payer: float, refund_rate: float) -> None:
    payer_rates = [0.005, 0.01, 0.02, 0.03, 0.05]
    commissions = [0.15, 0.30]
    print("payer% | commission | payers | gross EUR | proceeds est EUR")
    print("-------|------------|--------|-----------|-----------------")
    for pr in payer_rates:
        for cr in commissions:
            r = calculate(cfg, mau, pr, purchases_per_payer, refund_rate, cr)
            print(f"{pr*100:>5.1f}% | {cr*100:>9.0f}% | {r['payers']:>6.0f} | {r['gross_eur']:>9.2f} | {r['proceeds_estimate_eur']:>15.2f}")


def main() -> None:
    parser = argparse.ArgumentParser(description="CozyUni economy scenario simulator")
    parser.add_argument("--config", default="docs/data/economy_v1.json")
    parser.add_argument("--mau", type=int)
    parser.add_argument("--payer-rate", type=float, help="decimal, e.g. 0.02 for 2%%")
    parser.add_argument("--purchases-per-payer", type=float)
    parser.add_argument("--refund-rate", type=float)
    parser.add_argument("--commission", type=float, help="decimal assumption, e.g. 0.15")
    parser.add_argument("--matrix", action="store_true")
    args = parser.parse_args()

    cfg = load_config(Path(args.config))
    d = cfg["simulation_defaults"]
    mau = args.mau if args.mau is not None else d["mau"]
    payer_rate = args.payer_rate if args.payer_rate is not None else d["monthly_payer_rate"]
    ppp = args.purchases_per_payer if args.purchases_per_payer is not None else d["purchases_per_payer"]
    refund = args.refund_rate if args.refund_rate is not None else d["refund_rate"]
    commission = args.commission if args.commission is not None else d["commission_rate"]

    if not (0 <= payer_rate <= 1 and 0 <= refund <= 1 and 0 <= commission <= 1):
        raise SystemExit("rates must be between 0 and 1")
    if mau < 0 or ppp < 0:
        raise SystemExit("mau and purchases-per-payer must be non-negative")

    if args.matrix:
        print_matrix(cfg, mau, ppp, refund)
    else:
        print_result(calculate(cfg, mau, payer_rate, ppp, refund, commission))


if __name__ == "__main__":
    main()
