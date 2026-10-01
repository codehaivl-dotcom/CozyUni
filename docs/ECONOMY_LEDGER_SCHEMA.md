# CozyUni — Economy Ledger Schema v1.1

Status: **IMPLEMENTATION SPEC / SUPERSEDED DETAILS MOVED TO BACKEND CONTRACTS**

Purpose: define the economic accounting model. Detailed DB/API behavior is authoritative in:

1. `docs/ECONOMY_IAP_AND_STORE_LOCK.md`
2. `docs/backend/01_COMMERCE_BACKEND_DESIGN.md`
3. `docs/backend/02_COMMERCE_DATABASE_SCHEMA.md`
4. `docs/backend/03_COMMERCE_API_CONTRACT.md`
5. `backend/migrations/001_commerce_v1.sql`

---

## 1. Wallet principle

A wallet is not a client-editable mutable number.

Authoritative state comes from:
- immutable ledger events;
- credit lots with remaining balances;
- refund debt;
- derived server projection.

Player UI may show one combined spendable CC balance, but the server tracks provenance.

---

## 2. Internal buckets

Exactly two positive credit buckets:
- `purchased` — Cozy Credits originating from validated Apple IAP;
- `bonus` — support/promotion/manual non-paid grants.

Refund debt is not a third spendable bucket.

Spend order:
1. oldest bonus lots first;
2. oldest purchased lots first.

Purchased CC never expires.

---

## 3. Credit lot model

Every positive grant has an origin lot.

Example Apple grant:

```json
{
  "bucket": "purchased",
  "source_type": "apple_iap",
  "source_id": "2000000123456789",
  "original_cc": 550,
  "remaining_cc": 550
}
```

A spend reduces lot `remaining_cc` and creates allocation rows that explain exactly which lots funded the spend.

---

## 4. Ledger event examples

### Apple grant

```json
{
  "event_type": "iap_grant",
  "bucket": "purchased",
  "delta_cc": 550,
  "source_type": "apple_transaction",
  "source_id": "2000000123456789"
}
```

### Cosmetic spend

```json
{
  "event_type": "catalog_spend",
  "delta_cc": -150,
  "source_type": "catalog_purchase",
  "source_id": "purchase_uuid"
}
```

### Refund of unspent credit

```json
{
  "event_type": "iap_refund_reversal",
  "bucket": "purchased",
  "delta_cc": -50,
  "source_type": "apple_refund",
  "source_id": "2000000123456789"
}
```

### Refund debt creation

```json
{
  "event_type": "refund_debt_created",
  "bucket": "debt",
  "delta_cc": 500,
  "source_type": "apple_refund",
  "source_id": "2000000123456789"
}
```

Debt events are accounting history; debt is stored separately as a non-negative amount and blocks spending until cleared.

---

## 5. Refund policy

Example:

```text
Apple grant          +550 purchased CC
Player spent          500 CC
Lot remaining          50 CC
Apple full refund

Result:
- remove remaining 50 CC
- create refund debt 500 CC
- spendable balance becomes 0
- existing cosmetic entitlements stay owned in v1
- future positive grants repay debt first
```

Do not make historical spends disappear.
Do not mutate/decrease old ledger rows.
Do not create negative lot balances.

Refund reversal reduces debt first, then recreates purchased credit for any remaining restored amount.

---

## 6. Projection

Backend maintains a fast projection:

```json
{
  "purchased_cc": 400,
  "bonus_cc": 70,
  "refund_debt_cc": 0,
  "revision": 18
}
```

Projection is a cache/concurrency primitive, not primary accounting history.

Daily reconciliation must prove:

```text
projection purchased == sum purchased lot remaining
projection bonus     == sum bonus lot remaining
projection debt      == account refund debt
```

Any mismatch is an operator alert.

---

## 7. Required protections

- Apple transaction ID idempotency;
- App Store notification UUID idempotency;
- catalog purchase idempotency key;
- immutable ledger history;
- exact spend-to-lot allocations;
- server timestamp;
- no client-authoritative balance;
- no client-authoritative price;
- refund reconciliation;
- entitlement validation;
- account/appAccountToken validation;
- environment separation: Sandbox vs Production.

---

## 8. Commerce identity

The old placeholder `anonymous player identity later` is no longer the commerce design.

Current commerce v1 rule:
- core local games require no account;
- real-money commerce requires a Commerce Account;
- iOS/iPadOS Commerce Account uses Sign in with Apple;
- backend creates a stable internal account + `app_account_token` UUID;
- every StoreKit purchase supplies that token;
- wallet/entitlements restore by signing back into the same Commerce Account.

This is intentionally narrower than a future social/game account system.

---

## 9. Analytics events

Minimum wallet/store events:
- `store_open`
- `catalog_item_view`
- `iap_purchase_started`
- `iap_purchase_pending`
- `iap_purchase_success`
- `iap_purchase_failed`
- `iap_delivery_retry`
- `iap_delivery_success`
- `catalog_purchase_success`
- `catalog_purchase_insufficient_balance`
- `refund_received`
- `refund_debt_created`
- `refund_reversed`
- `wallet_reconciliation_mismatch`

Do not send raw Apple JWS/tokens as analytics properties.
