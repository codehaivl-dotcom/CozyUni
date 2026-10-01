# CozyUni — Commerce Database Schema Contract v1.0

Status: **IMPLEMENTATION-READY / POSTGRESQL AUTHORITY**

Runtime authority: `backend/migrations/001_commerce_v1.sql`.
This document explains table purpose/invariants. If prose conflicts with SQL DDL, fix both in the same change; do not leave them divergent.

---

## 1. Table map

```text
commerce_accounts
  ├─ commerce_identities
  ├─ commerce_sessions
  ├─ wallet_balance_projection
  ├─ credit_lots
  │    └─ wallet_spend_allocations
  ├─ wallet_ledger
  ├─ catalog_purchases
  │    └─ entitlements
  └─ apple_transactions

apple_notifications
catalog_items
commerce_outbox
admin_audit_events
```

---

## 2. `commerce_accounts`

One row per purchaser wallet/account.

Key fields:
- `id UUID PK`
- `app_account_token UUID UNIQUE NOT NULL`
- `status`: `active | disabled`
- `refund_debt_cc BIGINT >= 0`
- timestamps

Hard rules:
- `app_account_token` never changes during normal account life;
- do not reuse one token across different Commerce Accounts;
- disabling account blocks spend/new purchase claims but does not delete history.

---

## 3. `commerce_identities`

Maps Sign in with Apple identity to Commerce Account.

Key fields:
- internal UUID PK;
- `account_id` FK;
- `provider = 'apple'`;
- `provider_subject_hash BYTEA`;
- timestamps.

Unique invariant:
`(provider, provider_subject_hash)` identifies exactly one Commerce Account.

Do not persist email/name as part of v1 commerce identity.

---

## 4. `commerce_sessions`

Opaque access/refresh token sessions.

Store hashes only:
- `access_token_hash`
- `refresh_token_hash`

Fields include:
- access expiry;
- refresh expiry;
- revoked time;
- rotation parent ID;
- last-used time.

Never store raw tokens.

---

## 5. `apple_transactions`

One row per Apple transaction ID.

Transaction IDs are stored as `TEXT`, not numeric, to avoid client/runtime integer assumptions.

Fields:
- `transaction_id PK`
- original transaction ID
- account ID
- app account token
- product ID
- Apple environment
- purchase/signed dates
- refund/revocation fields
- JWS SHA-256
- raw signed JWS for commerce audit/reverification
- grant status

Unique/integrity rules:
- transaction ID belongs to one account only;
- app account token on row must match the owning account at claim time;
- a transaction creates at most one purchased-credit lot/grant.

---

## 6. `apple_notifications`

Stores every verified App Store Server Notification V2.

Primary key:
- `notification_uuid UUID`

Store:
- type/subtype;
- environment;
- signed date;
- signed payload;
- processing status;
- related transaction ID if available;
- error text safe for operators.

Duplicate notification UUID is success/no-op.

Status values:
- `received`
- `processed`
- `needs_reconciliation`
- `failed_retryable`
- `failed_terminal`

---

## 7. `credit_lots`

Tracks remaining spendable credits by grant origin.

Buckets:
- `purchased`
- `bonus`

Fields:
- original CC
- remaining CC
- source type
- source ID
- optional expiration
- account

Checks:
- original > 0;
- remaining >= 0;
- remaining <= original.

Purchased Apple lot uses `source_type='apple_iap'` and `source_id=transaction_id`.

---

## 8. `wallet_ledger`

Immutable currency movement history.

Every row stores:
- account;
- event type;
- bucket;
- signed integer `delta_cc`;
- source type/id;
- idempotency key where applicable;
- related ledger event where applicable;
- metadata JSON;
- server timestamp.

Example event types:
- `iap_grant`
- `promo_grant`
- `support_grant`
- `catalog_spend`
- `iap_refund_reversal`
- `refund_reversed_restore`
- `refund_debt_created`
- `refund_debt_repaid`
- `admin_adjustment`

Ledger rows are append-only. Correction = compensating row, never UPDATE/DELETE of historical money movement.

---

## 9. `wallet_spend_allocations`

Links one negative catalog-spend ledger event to exact credit lots consumed.

Fields:
- spend ledger ID;
- credit lot ID;
- allocated amount.

Invariant:
Sum allocations for one spend ledger row equals absolute value of its negative CC delta.

This makes refund/audit provenance inspectable.

---

## 10. `wallet_balance_projection`

Derived fast-read/concurrency row.

Fields:
- purchased CC
- bonus CC
- refund debt CC
- revision
- updated timestamp

The projection is mutable but **not source of truth**.

All spend/refund mutations lock this row with `SELECT ... FOR UPDATE`.

Reconciliation verifies projection against lots/account debt.

---

## 11. `catalog_items`

Server catalog source.

Fields:
- stable text ID;
- type;
- price CC;
- active flag;
- stackable flag;
- sort order;
- metadata JSON;
- content version.

Client never defines catalog price.

Initial catalog records may be seeded from a versioned JSON/SQL migration later. The schema is ready before art catalog is finalized.

---

## 12. `catalog_purchases`

One server-side spend transaction for a catalog item.

Fields:
- purchase UUID;
- account;
- catalog ID;
- authoritative charged price;
- client idempotency key;
- spend ledger ID;
- timestamp.

Unique `(account_id, idempotency_key)`.

---

## 13. `entitlements`

Owned cosmetic/content item state.

Fields:
- account;
- catalog item;
- acquisition purchase;
- acquired time;
- optional revoked time/reason;
- metadata.

For non-stackable items, unique active ownership is guaranteed by unique `(account_id, catalog_id)` in v1.

---

## 14. `commerce_outbox`

PostgreSQL-backed retry queue for side effects that must happen after a durable DB event.

Examples:
- send consumption information to Apple;
- transaction reconciliation;
- analytics export;
- operator alert.

Fields:
- event type;
- payload;
- available-at;
- attempts;
- locked-at/worker;
- completed-at;
- terminal-failure flag.

Do not perform irreversible external API work inside a DB transaction before commit.

---

## 15. `admin_audit_events`

Immutable operator audit trail.

Every admin mutation records:
- actor ID;
- role;
- action;
- account;
- source/reference;
- reason;
- request/ticket ID if provided;
- metadata;
- time.

No admin UI feature may bypass this audit table.

---

## 16. Transaction boundaries

### Apple grant transaction
Atomically:
1. insert/resolve Apple transaction;
2. resolve debt repayment;
3. create lot for remaining grant if any;
4. append ledger rows;
5. update wallet projection;
6. commit.

### Catalog spend transaction
Atomically:
1. lock wallet projection;
2. validate item/entitlement/debt/balance;
3. consume lots;
4. append spend ledger;
5. allocations;
6. catalog purchase;
7. entitlement;
8. projection revision;
9. commit.

### Refund transaction
Atomically:
1. lock wallet projection/account;
2. mark Apple transaction refunded if newest signed state;
3. reduce remaining source lot;
4. create debt for consumed portion;
5. append compensating ledger rows;
6. update projection;
7. commit.

---

## 17. Deletion policy

Financial records are not hard-deleted through ordinary application/admin flows.

If a future privacy deletion request legally requires account deletion:
- separate personal identity linkage from non-personal accounting records;
- anonymize identity where allowed;
- preserve financial/audit records only as legally necessary;
- implement this only after a dedicated privacy/legal data-retention spec.

Commerce v1 must not invent destructive deletion behavior.

---

## 18. Required database tests

Before enabling IAP in production:
- duplicate Apple transaction grants once;
- duplicate notification processes once;
- concurrent catalog spend cannot overspend;
- concurrent duplicate idempotency key charges once;
- refund of unspent lot;
- refund of partially spent lot;
- full consumed refund creates debt;
- refund reversal restores debt/credit once;
- positive grant repays debt first;
- projection reconciliation reaches zero mismatch;
- disabled account cannot spend/claim;
- sandbox transaction cannot enter production database.
