# CozyUni — Commerce Backend Design v1.0

Status: **IMPLEMENTATION-READY DESIGN LOCK**

Purpose: define exactly how Cozy Credits, Apple consumable IAP, catalog spending, refunds, account recovery, and server notifications work.

This document does not modify any board-game rules.

---

## 1. Core principles

1. Apple purchase transaction is authoritative for real-money credit grant.
2. Backend ledger is authoritative for Cozy Credit ownership and spend.
3. Client UI is never authoritative for wallet balance, catalog price, ownership, refund state, or Apple transaction validity.
4. Every external event is idempotent.
5. Every wallet mutation is auditable.
6. A StoreKit transaction is finished only after the server has durably accepted/delivered its grant.
7. Paid currency cannot buy competitive power.
8. Gameplay stays usable without login; commerce login is required only for real-money wallet usage.

---

## 2. Commerce identity

### 2.1 Commerce Account

A Commerce Account is not a gameplay profile.

It owns:
- Cozy Credit wallet;
- cosmetic entitlements;
- Apple IAP transaction associations;
- commerce audit history.

Local player slots/avatars are presentation/gameplay identities and do not own paid currency.

### 2.2 Sign in with Apple

Before the first real-money purchase, the app requires Sign in with Apple.

Server validates the Apple identity token and resolves/creates one Commerce Account.

Store only:
- internal `commerce_account_id` UUID;
- SHA-256 hash of Apple provider subject;
- one random UUID `app_account_token`;
- account state/timestamps.

Do not require or persist Apple email/name for commerce v1.

### 2.3 Shared-device behavior

One active Commerce Account per install in v1.

All local players on that device may equip cosmetics owned by the active Commerce Account.

Purchases/spending always affect the active Commerce Account only.

Account switching is future work.

---

## 3. StoreKit purchase flow

Canonical flow:

```text
STORE ITEM / CREDIT PACK
 -> ensure Commerce Account authenticated
 -> fetch/display StoreKit localized product
 -> call StoreKit purchase with appAccountToken(account.app_account_token)
 -> StoreKit returns verification result
 -> if unverified: do not grant; show recoverable error
 -> if verified: send transaction.jwsRepresentation to backend
 -> backend verifies Apple JWS and all business invariants
 -> backend atomically records transaction + credit grant + wallet projection
 -> backend returns new wallet state
 -> client calls transaction.finish()
 -> refresh wallet/catalog UI
```

### 3.1 Client failure rule

If backend claim fails because of timeout/network/server unavailability:
- do NOT finish the StoreKit transaction;
- show `Purchase received — finishing delivery` or equivalent non-alarming recoverable state;
- retry claim with exponential backoff while app remains active;
- on next app launch, process `Transaction.updates` and `Transaction.unfinished`;
- duplicate claims are safe because transaction ID is unique and grant is idempotent.

### 3.2 Claim verification

Backend must verify:
- JWS signature using Apple official App Store Server Library;
- expected bundle ID;
- expected Apple app ID when configured;
- transaction environment matches backend environment;
- product ID exists and is enabled in `docs/data/economy_v1.json` production equivalent;
- product type is permitted for this endpoint;
- verified transaction `appAccountToken` equals authenticated account token;
- transaction ID has not already been attached to a different Commerce Account;
- transaction is not already refunded/revoked at the latest known signed state.

Never trust these from client JSON outside the signed JWS:
- product ID;
- credit amount;
- price;
- purchase date;
- transaction ID;
- account token.

### 3.3 Grant idempotency

For one Apple transaction ID:
- at most one `apple_transactions` purchase record;
- at most one purchased-credit lot;
- at most one positive IAP ledger grant.

A duplicate valid claim returns the current authoritative wallet without granting again.

---

## 4. Server notification flow

Use **App Store Server Notifications V2 only**.

Endpoint:
`POST /v1/commerce/apple/notifications`

Notification processing:

```text
receive signedPayload
 -> verify signed JWS
 -> read notificationUUID / signedDate / environment / type
 -> insert notification row with unique notificationUUID
 -> duplicate UUID: return success without reprocessing
 -> process recognized event in DB transaction
 -> mark notification processed
 -> return HTTP 200
```

### 4.1 Relevant v1 notification types

#### `ONE_TIME_CHARGE`
For known consumable Cozy Credit product:
- verify signed transaction;
- locate Commerce Account by verified `appAccountToken`;
- create Apple transaction + credit grant if not already present;
- this provides delivery even if the client crashed after App Store purchase.

If account token is missing/unknown:
- persist notification;
- mark `needs_reconciliation`;
- do not guess account ownership.

#### `REFUND`
- identify original transaction;
- apply refund policy in Section 8;
- mark transaction refunded/revoked with signed dates/reason;
- idempotent if already processed.

#### `REFUND_REVERSED`
- reverse the refund adjustment exactly once;
- restore credit/debt state according to Section 8.5.

#### `REFUND_DECLINED`
- audit only;
- no wallet mutation.

#### `CONSUMPTION_REQUEST`
- persist request;
- if Apple payload indicates customer consent and required data is available, queue a response through App Store Server API;
- response worker target is within 12 hours;
- do not fabricate consumption information.

Unknown notification type:
- persist;
- no wallet mutation;
- log warning;
- do not fail the whole notification endpoint merely because the type is new, unless JWS verification failed.

---

## 5. Wallet model

Authoritative currency: integer Cozy Credits (`CC`).

Two grant buckets exist internally:
- `bonus_cc`
- `purchased_cc`

Player UI may show one combined spendable CC balance unless debt exists.

Spend priority:
1. bonus CC oldest lot first;
2. purchased CC oldest lot first.

Purchased CC never expires.
Bonus CC may expire only if a future promo definition explicitly sets `expires_at`; v1 default promo grants do not expire unless admin grant says so.

---

## 6. Credit lots

Every positive grant creates or contributes to one immutable-origin lot.

Examples:
- Apple purchase -> purchased lot;
- support compensation -> bonus lot;
- promotion -> bonus lot.

A lot stores:
- original amount;
- remaining amount;
- source type/id;
- creation time;
- optional expiry;
- account owner.

Spend never edits historical ledger events. It only:
- reduces remaining amount on locked lots;
- records spend allocations;
- writes a negative ledger event.

---

## 7. Catalog purchase flow

Request contains only:
- `catalog_id`;
- client-generated UUID idempotency key.

Server determines price and eligibility.

Canonical transaction:

```text
BEGIN
 -> lock wallet projection row FOR UPDATE
 -> load catalog item from server catalog
 -> reject inactive/unknown item
 -> if non-stackable entitlement already owned: return already_owned without charge
 -> reject if refund debt > 0
 -> calculate spendable balance
 -> reject if insufficient
 -> consume credit lots in configured priority
 -> insert negative wallet ledger event
 -> insert spend allocations
 -> insert catalog purchase
 -> insert entitlement
 -> update projection/revision
COMMIT
```

No client-side price is accepted.

If the same idempotency key is retried, return the original purchase result.

---

## 8. Refund policy

### 8.1 Goal

Refund handling must be deterministic and must not create negative normal lot balances.

### 8.2 Refund amount

Determine the refunded CC amount from the original Apple product grant and Apple refund/revocation percentage where applicable.

Never infer refund amount from current wallet balance.

### 8.3 Unspent portion

For the refunded purchased-credit lot:
- remove up to the lot's remaining CC;
- write negative `iap_refund_reversal` ledger event;
- reduce projection.

### 8.4 Already-spent portion

If refunded CC was already consumed:
- do not delete old ledger/spend rows;
- do not silently revoke cosmetics;
- add the consumed refunded amount to `refund_debt_cc`;
- account cannot spend CC while refund debt > 0.

Future positive CC grants repay refund debt before any new spendable lot balance is created.

Example:

```text
purchase +550 CC
spend 500 CC
remaining 50 CC
Apple refunds full pack
 -> remove 50 remaining
 -> refund debt becomes 500
 -> spendable wallet = 0
```

### 8.5 Refund reversed

On `REFUND_REVERSED`:
1. reduce refund debt created by that refund first;
2. if reversed amount remains, recreate purchased CC as a new recovery lot linked to the original Apple transaction/refund reversal;
3. write positive audit ledger event;
4. never duplicate recovery for the same reversed refund event.

### 8.6 Entitlements

V1 policy: cosmetic entitlements already purchased with credits are not automatically revoked solely because a credit-pack refund creates debt.

Reason:
- avoids non-deterministic mapping of mixed bonus/purchased lots to historical cosmetic value;
- debt model still prevents repeated refund abuse from producing free future spending power.

Admin can investigate abuse but must not edit history.

---

## 9. Positive grant while refund debt exists

For any incoming positive grant:

```text
incoming = X
debt_payment = min(X, refund_debt_cc)
refund_debt_cc -= debt_payment
remaining = X - debt_payment
if remaining > 0:
    create normal credit lot for remaining
```

Ledger must record both:
- the external grant source;
- debt repayment effect.

UI shows a clear support-oriented message if an Apple purchase was fully/partially used to settle prior refund debt.

---

## 10. Wallet projection

Ledger + credit lots are source of truth.

A `wallet_balance_projection` row exists only for fast reads and concurrency control.

Fields:
- purchased_cc;
- bonus_cc;
- refund_debt_cc;
- revision.

Invariant after each committed mutation:

```text
projection.purchased_cc == SUM(active purchased lot remaining)
projection.bonus_cc == SUM(active bonus lot remaining)
projection.refund_debt_cc == account refund debt
```

A reconciliation job verifies these invariants.

---

## 11. Reconciliation

Scheduled worker jobs:

### Wallet reconciliation
Daily minimum:
- compare projection vs lot sums;
- compare ledger totals vs expected movement;
- flag mismatch; never auto-delete history.

### Apple transaction reconciliation
For transactions marked suspicious/unknown/refund-pending:
- query App Store Server API using transaction ID;
- verify returned signed transaction;
- update transaction status only through normal idempotent mutation path.

### Notification retry jobs
Failed Apple API response tasks use exponential retry with bounded attempts and operator-visible dead-letter state.

---

## 12. Commerce API error codes

Stable public error codes:

- `AUTH_REQUIRED`
- `AUTH_INVALID`
- `ACCOUNT_DISABLED`
- `APPLE_TRANSACTION_INVALID`
- `APPLE_TRANSACTION_ACCOUNT_MISMATCH`
- `APPLE_TRANSACTION_ENVIRONMENT_MISMATCH`
- `APPLE_PRODUCT_UNKNOWN`
- `PURCHASE_ALREADY_DELIVERED`
- `CATALOG_ITEM_UNKNOWN`
- `CATALOG_ITEM_INACTIVE`
- `ENTITLEMENT_ALREADY_OWNED`
- `INSUFFICIENT_CC`
- `REFUND_DEBT_ACTIVE`
- `IDEMPOTENCY_CONFLICT`
- `STORE_TEMPORARILY_UNAVAILABLE`
- `INTERNAL_ERROR`

Do not expose stack traces or raw Apple validation errors to player UI.

---

## 13. Security invariants

- No endpoint accepts arbitrary `delta_cc` from a normal client.
- No endpoint accepts `price_cc` from a normal client.
- No normal client can select grant bucket.
- No normal client can mark Apple transaction verified/refunded.
- All Apple JWS data verified before use.
- Admin grants require authenticated admin actor, reason, request/ticket reference, and audit event.
- Database credentials and Apple private keys are server-side only.
- Rate-limit authentication, purchase claim, and admin mutation endpoints.

---

## 14. Player-visible states

Store/wallet UI must support:
- signed out;
- signed in / wallet ready;
- StoreKit loading;
- purchase pending;
- delivery pending;
- purchase delivered;
- insufficient CC;
- refund debt active;
- store unavailable.

Never show a fake optimistic CC balance before server confirmation.

---

## 15. Feature flags

Required server/client feature flags:
- `commerce_enabled`
- `iap_credit_packs_enabled`
- `catalog_spend_enabled`
- `sign_in_with_apple_required_for_purchase` = true in production v1

If commerce backend health is degraded:
- existing local games remain playable;
- disable new real-money purchase CTA;
- do not block core game startup.

---

## 16. Apple implementation references

Implementation agents should verify against current official Apple docs before coding package/API calls:
- StoreKit 2 transaction/JWS verification
- `Transaction.updates`
- `Transaction.unfinished`
- `Product.PurchaseOption.appAccountToken`
- App Store Server API `Get Transaction Info`
- App Store Server Notifications V2
- Apple official App Store Server Library

Behavior in this document remains CozyUni authority unless an Apple platform requirement makes it impossible; in that case, raise a design change instead of silently altering wallet behavior.
