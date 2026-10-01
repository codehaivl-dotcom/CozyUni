#!/usr/bin/env python3
"""Reference simulator for CozyUni CC wallet policy.

This is a policy/regression helper, not the production wallet implementation.
It models the locked grant/spend/refund/debt rules from
`docs/backend/01_COMMERCE_BACKEND_DESIGN.md`.

Usage:
  python tools/sim_wallet_policy.py --matrix
  python tools/sim_wallet_policy.py --purchase 550 --spend 500 --refund-percent 100
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass, field


@dataclass
class Lot:
    bucket: str
    original: int
    remaining: int


@dataclass
class Wallet:
    lots: list[Lot] = field(default_factory=list)
    debt: int = 0

    @property
    def purchased(self) -> int:
        return sum(x.remaining for x in self.lots if x.bucket == "purchased")

    @property
    def bonus(self) -> int:
        return sum(x.remaining for x in self.lots if x.bucket == "bonus")

    @property
    def spendable(self) -> int:
        if self.debt > 0:
            return 0
        return self.purchased + self.bonus

    def grant(self, amount: int, bucket: str) -> tuple[int, int]:
        assert amount >= 0
        debt_repaid = min(amount, self.debt)
        self.debt -= debt_repaid
        remainder = amount - debt_repaid
        if remainder:
            self.lots.append(Lot(bucket=bucket, original=remainder, remaining=remainder))
        return debt_repaid, remainder

    def spend(self, amount: int) -> None:
        if self.debt > 0:
            raise ValueError("refund debt blocks spending")
        if amount > self.spendable:
            raise ValueError("insufficient balance")
        remaining = amount
        for bucket in ("bonus", "purchased"):
            for lot in self.lots:
                if lot.bucket != bucket or lot.remaining <= 0:
                    continue
                take = min(remaining, lot.remaining)
                lot.remaining -= take
                remaining -= take
                if remaining == 0:
                    return
        assert remaining == 0

    def refund_purchase_lot(self, lot: Lot, refund_percent: float) -> tuple[int, int]:
        if lot.bucket != "purchased":
            raise ValueError("refund source must be purchased lot")
        if not 0 <= refund_percent <= 1:
            raise ValueError("refund_percent must be 0..1")

        target = round(lot.original * refund_percent)
        target = min(target, lot.original)
        remove_unspent = min(target, lot.remaining)
        lot.remaining -= remove_unspent
        consumed_refund = target - remove_unspent
        self.debt += consumed_refund
        return remove_unspent, consumed_refund


def show(label: str, w: Wallet) -> None:
    print(
        f"{label:>18}: purchased={w.purchased:4d} bonus={w.bonus:4d} "
        f"debt={w.debt:4d} spendable={w.spendable:4d}"
    )


def scenario(purchase: int, spend: int, refund_percent: float, later_grant: int = 0) -> None:
    w = Wallet()
    _, _ = w.grant(purchase, "purchased")
    purchase_lot = w.lots[-1]
    show("after purchase", w)

    if spend:
        w.spend(spend)
        show("after spend", w)

    removed, debt_created = w.refund_purchase_lot(purchase_lot, refund_percent)
    show("after refund", w)
    print(f"  refund removed_unspent={removed} debt_created={debt_created}")

    if later_grant:
        repaid, remainder = w.grant(later_grant, "purchased")
        show("after later grant", w)
        print(f"  later grant debt_repaid={repaid} new_credit={remainder}")


def matrix() -> None:
    cases = [
        (550, 0, 1.0, 0),
        (550, 100, 1.0, 0),
        (550, 500, 1.0, 0),
        (550, 550, 1.0, 0),
        (550, 500, 1.0, 250),
        (550, 500, 1.0, 700),
        (1200, 800, 0.5, 0),
    ]
    for i, case in enumerate(cases, 1):
        print(f"\nCASE {i}: purchase={case[0]} spend={case[1]} refund={case[2]*100:.0f}% later_grant={case[3]}")
        scenario(*case)


def main() -> None:
    parser = argparse.ArgumentParser(description="Simulate CozyUni wallet refund/debt policy")
    parser.add_argument("--purchase", type=int, default=550)
    parser.add_argument("--spend", type=int, default=500)
    parser.add_argument("--refund-percent", type=float, default=100.0)
    parser.add_argument("--later-grant", type=int, default=0)
    parser.add_argument("--matrix", action="store_true")
    args = parser.parse_args()

    if args.matrix:
        matrix()
        return

    if args.purchase < 0 or args.spend < 0 or args.later_grant < 0:
        raise SystemExit("amounts must be non-negative")
    if args.spend > args.purchase:
        raise SystemExit("this simple scenario requires spend <= purchase")
    if not 0 <= args.refund_percent <= 100:
        raise SystemExit("refund-percent must be 0..100")

    scenario(args.purchase, args.spend, args.refund_percent / 100.0, args.later_grant)


if __name__ == "__main__":
    main()
