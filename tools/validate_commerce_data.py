#!/usr/bin/env python3
"""Validate CozyUni commerce JSON contracts with Python stdlib only.

Usage:
  python tools/validate_commerce_data.py
  python tools/validate_commerce_data.py --economy docs/data/economy_v1.json --backend docs/data/commerce_backend_v1.json
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path


class ValidationError(Exception):
    pass


def load_json(path: Path) -> dict:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        raise ValidationError(f"{path}: invalid JSON: {exc}") from exc
    if not isinstance(value, dict):
        raise ValidationError(f"{path}: top level must be an object")
    return value


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValidationError(message)


def validate_economy(cfg: dict) -> None:
    require(cfg.get("schema_version") == 1, "economy schema_version must be 1")

    currency = cfg.get("currency") or {}
    require(currency.get("code") == "CC", "currency code must be CC")
    require(currency.get("global_spendable_currencies") == 1, "exactly one global spendable currency is allowed")
    require(currency.get("purchased_currency_expires") is False, "purchased CC must not expire")
    require(currency.get("allow_gameplay_power_purchase") is False, "gameplay power purchase must remain disabled")
    require(currency.get("allow_match_currency_conversion") is False, "match currency conversion must remain disabled")

    products = cfg.get("iap_credit_packs")
    require(isinstance(products, list) and products, "iap_credit_packs must be a non-empty list")
    product_ids: set[str] = set()
    for p in products:
        pid = p.get("product_id")
        require(isinstance(pid, str) and pid, "IAP product_id must be non-empty string")
        require(pid not in product_ids, f"duplicate IAP product_id: {pid}")
        product_ids.add(pid)
        require(p.get("type") == "consumable", f"{pid}: only consumable credit packs allowed in v1")
        require(isinstance(p.get("credits"), int) and p["credits"] > 0, f"{pid}: credits must be positive integer")
        require(isinstance(p.get("planning_target_eur"), (int, float)) and p["planning_target_eur"] > 0, f"{pid}: planning_target_eur must be > 0")

    bands = cfg.get("catalog_price_bands_cc") or {}
    require(bands, "catalog_price_bands_cc required")
    band_values = list(bands.values())
    require(all(isinstance(v, int) and v > 0 for v in band_values), "catalog price bands must be positive integers")
    require(band_values == sorted(band_values), "catalog price bands must be ascending in declaration order")

    types = cfg.get("allowed_catalog_types")
    require(isinstance(types, list) and types, "allowed_catalog_types required")
    require(len(types) == len(set(types)), "allowed_catalog_types contains duplicates")

    defaults = cfg.get("simulation_defaults") or {}
    mix = defaults.get("pack_mix") or {}
    require(mix, "simulation_defaults.pack_mix required")
    require(set(mix).issubset(product_ids), "pack_mix references unknown product")
    require(all(isinstance(w, (int, float)) and w >= 0 for w in mix.values()), "pack_mix weights must be non-negative")
    total_mix = sum(mix.values())
    require(abs(total_mix - 1.0) < 1e-9, f"pack_mix must sum to 1.0, got {total_mix}")

    thresholds = cfg.get("review_thresholds") or {}
    require(0 <= thresholds.get("refund_rate_warn", -1) <= 1, "refund_rate_warn must be 0..1")
    require(0 <= thresholds.get("purchase_success_rate_min", -1) <= 1, "purchase_success_rate_min must be 0..1")


def validate_backend(cfg: dict) -> None:
    require(cfg.get("schema_version") == 1, "commerce backend schema_version must be 1")

    auth = cfg.get("auth") or {}
    require(auth.get("provider") == "sign_in_with_apple", "commerce auth provider must be sign_in_with_apple")
    require(auth.get("core_game_requires_login") is False, "core games must remain login-free")
    require(auth.get("real_money_purchase_requires_login") is True, "real-money purchase must require Commerce Account")
    require(auth.get("access_token_ttl_seconds") == 900, "access token TTL must remain 900s")
    require(auth.get("refresh_token_ttl_seconds") == 2592000, "refresh token TTL must remain 30 days")

    apple = cfg.get("apple") or {}
    require(apple.get("storekit_api") == "StoreKit2", "StoreKit2 required")
    require(apple.get("server_notifications_version") == 2, "App Store Server Notifications V2 required")
    require(apple.get("require_app_account_token") is True, "appAccountToken required")
    require(apple.get("finish_transaction_after_server_delivery") is True, "transaction must finish only after server delivery")

    expected_notifications = {
        "ONE_TIME_CHARGE",
        "REFUND",
        "REFUND_REVERSED",
        "REFUND_DECLINED",
        "CONSUMPTION_REQUEST",
    }
    actual_notifications = set(apple.get("relevant_notification_types") or [])
    require(expected_notifications == actual_notifications, "relevant Apple notification set does not match v1 lock")

    wallet = cfg.get("wallet") or {}
    require(wallet.get("currency_code") == "CC", "backend wallet currency must be CC")
    require(wallet.get("integer_only") is True, "CC must remain integer-only")
    require(wallet.get("spend_priority") == ["bonus_oldest_first", "purchased_oldest_first"], "wallet spend priority mismatch")
    require(wallet.get("block_spend_when_refund_debt_positive") is True, "refund debt must block spending")
    require(wallet.get("positive_grants_repay_refund_debt_first") is True, "positive grants must repay debt first")
    require(wallet.get("refund_auto_revoke_entitlements") is False, "v1 refund must not auto-revoke entitlements")

    sessions = cfg.get("sessions") or {}
    require(sessions.get("token_bytes") >= 32, "session token must be at least 32 bytes")
    require(sessions.get("store_raw_tokens_server_side") is False, "server must not store raw tokens")
    require(sessions.get("hash") == "SHA-256", "session token hash must be SHA-256")

    limits = cfg.get("rate_limits_per_minute") or {}
    require(all(isinstance(v, int) and v > 0 for v in limits.values()), "all rate limits must be positive integers")

    admin = cfg.get("admin") or {}
    require(admin.get("direct_balance_set_allowed") is False, "direct balance set must remain forbidden")
    require(admin.get("historical_ledger_mutation_allowed") is False, "historical ledger mutation must remain forbidden")
    require(admin.get("operator_grant_max_cc_per_action", 0) <= admin.get("admin_grant_max_cc_per_action", -1), "operator grant cap must not exceed admin cap")

    flags = cfg.get("feature_flags_production_default") or {}
    require(flags.get("commerce_enabled") is False, "commerce production default must stay OFF until launch gate")
    require(flags.get("iap_credit_packs_enabled") is False, "IAP production default must stay OFF until launch gate")
    require(flags.get("catalog_spend_enabled") is False, "catalog spend production default must stay OFF until launch gate")
    require(flags.get("sign_in_with_apple_required_for_purchase") is True, "Sign in with Apple purchase gate required")


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate CozyUni commerce JSON contracts")
    parser.add_argument("--economy", default="docs/data/economy_v1.json")
    parser.add_argument("--backend", default="docs/data/commerce_backend_v1.json")
    args = parser.parse_args()

    economy_path = Path(args.economy)
    backend_path = Path(args.backend)
    economy = load_json(economy_path)
    backend = load_json(backend_path)

    validate_economy(economy)
    validate_backend(backend)

    print(f"PASS: {economy_path}")
    print(f"PASS: {backend_path}")
    print("Commerce data contracts are internally valid.")


if __name__ == "__main__":
    try:
        main()
    except ValidationError as exc:
        raise SystemExit(f"FAIL: {exc}")
