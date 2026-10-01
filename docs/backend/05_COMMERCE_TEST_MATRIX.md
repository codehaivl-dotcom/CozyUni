# CozyUni — Commerce Test Matrix v1.0

Status: **REQUIRED BEFORE ENABLING PRODUCTION IAP**

Purpose: exact QA gate for StoreKit, backend, wallet, refund, and admin behavior.

---

## 1. Unit/data tests

- [ ] `tools/validate_commerce_data.py` passes.
- [ ] every IAP product ID unique.
- [ ] pack mix sums to 1.0.
- [ ] catalog price bands positive/ascending.
- [ ] paid CC never expires.
- [ ] forbidden gameplay-power purchase list non-empty and unchanged without design review.
- [ ] production feature flags default OFF.

---

## 2. Commerce authentication

- [ ] Sign in with Apple valid token creates account.
- [ ] repeat sign-in resolves same Commerce Account.
- [ ] invalid signature rejected.
- [ ] wrong audience rejected.
- [ ] expired token rejected.
- [ ] disabled account rejected for mutation.
- [ ] access token expires after configured TTL.
- [ ] refresh rotates refresh token.
- [ ] previous refresh token invalid after rotation.
- [ ] logout revokes active session.
- [ ] core local game launch works without commerce login.

---

## 3. StoreKit purchase delivery

Using StoreKit Test first, then App Store Sandbox.

For every configured credit pack:
- [ ] localized StoreKit product loads.
- [ ] app uses server-issued `appAccountToken`.
- [ ] verified transaction sent as JWS to backend.
- [ ] backend grants exact configured CC.
- [ ] balance only updates after server delivery response.
- [ ] client finishes StoreKit transaction after server delivery.
- [ ] product price shown from StoreKit, not planning EUR config.

Failure scenarios:
- [ ] user cancels StoreKit sheet -> no server grant.
- [ ] StoreKit transaction unverified -> no grant.
- [ ] backend offline after successful App Store purchase -> transaction remains unfinished.
- [ ] restart app -> unfinished transaction reprocessed and delivered.
- [ ] same JWS submitted twice -> one grant only.
- [ ] same transaction claimed by different Commerce Account -> rejected.
- [ ] sandbox transaction against production backend -> rejected.
- [ ] unknown product ID -> rejected/no grant.

---

## 4. App Store Server Notifications V2

- [ ] valid signed payload accepted.
- [ ] invalid signature rejected.
- [ ] duplicate notification UUID processes once.
- [ ] `ONE_TIME_CHARGE` can deliver known transaction when client never claimed it.
- [ ] `ONE_TIME_CHARGE` with unknown/missing app account token -> `needs_reconciliation`, no guessed grant.
- [ ] `REFUND` applies once.
- [ ] duplicate `REFUND` no duplicate debt/removal.
- [ ] `REFUND_REVERSED` restores once.
- [ ] `REFUND_DECLINED` makes no wallet mutation.
- [ ] `CONSUMPTION_REQUEST` persisted and queued when applicable.
- [ ] unknown future notification type persisted without wallet mutation.
- [ ] transient DB failure returns retryable HTTP status.

---

## 5. Wallet lot/spend tests

- [ ] bonus CC spent before purchased CC.
- [ ] within bucket, oldest lot spent first.
- [ ] exact-balance spend reaches zero.
- [ ] insufficient balance rejected atomically.
- [ ] concurrent spends cannot overspend.
- [ ] same catalog idempotency key charges once.
- [ ] reused idempotency key with different body -> `IDEMPOTENCY_CONFLICT`.
- [ ] already-owned non-stackable item charges zero.
- [ ] price from client ignored/not accepted.
- [ ] inactive catalog item rejected.
- [ ] entitlement and spend commit atomically.
- [ ] rollback before commit creates neither entitlement nor charge.

---

## 6. Refund/debt matrix

### Case A — unspent full refund

Start:
`+550 purchased, spend 0`

Expected after refund:
- purchased = 0
- bonus = 0
- debt = 0
- entitlement unchanged

### Case B — partial consumption

Start:
`+550 purchased, spend 100`

Expected after full refund:
- remove 450 remaining
- debt = 100
- spendable = 0

### Case C — mostly consumed

Start:
`+550 purchased, spend 500`

Expected:
- remove 50 remaining
- debt = 500
- spendable = 0

### Case D — fully consumed

Start:
`+550 purchased, spend 550`

Expected:
- remove 0
- debt = 550
- spendable = 0

### Case E — future grant smaller than debt

State:
`debt = 500`
Then grant `+250`.

Expected:
- debt = 250
- new spendable = 0
- no new positive lot remainder

### Case F — future grant larger than debt

State:
`debt = 500`
Then grant `+700 purchased`.

Expected:
- debt = 0
- new purchased lot = 200
- spendable = 200

### Case G — refund reversed

Start from Case C refund state (`debt=500`).
Full refund reversed.

Expected:
- debt returns to 0;
- 50 purchased CC is restored as spendable recovery amount after debt restoration accounting so total economic effect equals original +550 transaction less historical 500 spend;
- no duplicate restore if notification repeated.

Implementation test should validate exact ledger rows and projection, not only final balance.

---

## 7. Projection/reconciliation

- [ ] projection equals sum of purchased lots.
- [ ] projection equals sum of bonus lots.
- [ ] projection debt equals account debt.
- [ ] one intentionally corrupted sandbox projection is detected.
- [ ] reconciliation never deletes ledger history.
- [ ] repair is explicit/audited, not silent.

---

## 8. Admin tool tests

- [ ] readonly role cannot mutate.
- [ ] operator grant 500 succeeds.
- [ ] operator grant 501 rejected.
- [ ] operator daily >1000/account rejected, including concurrent requests.
- [ ] admin grant <=5000 succeeds.
- [ ] direct `set balance` action does not exist.
- [ ] admin adjustment writes compensating ledger + audit event.
- [ ] account disable blocks spend/claim but not local games.
- [ ] Apple reconcile uses normal transaction update path.
- [ ] raw auth tokens never visible.
- [ ] production rejects sandbox-only admin action.

---

## 9. Security tests

- [ ] normal client cannot post arbitrary CC delta.
- [ ] normal client cannot choose `purchased` vs `bonus` bucket.
- [ ] normal client cannot forge catalog price.
- [ ] normal client cannot mark transaction refunded.
- [ ] invalid/modified Apple JWS rejected.
- [ ] request rate limits enforced.
- [ ] SQL injection tests on all identifiers/search endpoints.
- [ ] secrets absent from repository/log output.
- [ ] access/refresh tokens logged only as redacted hashes/identifiers, never raw.

---

## 10. Load/concurrency smoke tests

Minimum sandbox/backend CI target:
- 50 concurrent wallet reads/account set;
- 20 concurrent duplicate claim requests for same Apple transaction;
- 20 concurrent catalog purchase requests sharing same idempotency key;
- 10 concurrent valid different purchase attempts against one wallet near insufficient-balance boundary.

Required outcome:
- no double grant;
- no negative lot balance;
- no duplicate entitlement charge;
- no projection mismatch.

---

## 11. Production enablement gate

All must be true:
- [ ] migration applied to production DB.
- [ ] database backup/restore tested.
- [ ] Apple production bundle/app IDs configured.
- [ ] App Store Server Notifications V2 production URL configured.
- [ ] sandbox URL/config separated.
- [ ] StoreKit products approved/available as required.
- [ ] Sign in with Apple production config verified.
- [ ] all tests above pass.
- [ ] admin readonly/search available.
- [ ] alerting for notification/reconciliation failures active.
- [ ] `commerce_enabled=true` only after above.
- [ ] enable `iap_credit_packs_enabled` after commerce health verified.
- [ ] enable `catalog_spend_enabled` only when at least one validated cosmetic SKU exists.

No agent may turn these production flags on merely because code compiles.
