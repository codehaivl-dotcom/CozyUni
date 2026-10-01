# CozyUni — StoreKit Client Implementation v1.0

Status: **IMPLEMENTATION LOCK — iOS/iPadOS commerce client**

Purpose: remove ambiguity in app-side Apple IAP flow while keeping all wallet authority on the commerce backend.

Backend authority:
- `docs/backend/01_COMMERCE_BACKEND_DESIGN.md`
- `docs/backend/03_COMMERCE_API_CONTRACT.md`

---

## 1. API choice

Use StoreKit 2 transaction/product APIs.

Do not implement the deprecated Original StoreKit purchase queue for new CozyUni commerce code.

Production real-money pack type:
- consumable IAP credit packs defined in `docs/data/economy_v1.json`.

---

## 2. Client modules

Conceptual ownership:

```text
StoreKitAdapter
  - loadProducts(productIDs)
  - purchase(product, appAccountToken)
  - listenTransactionUpdates()
  - unfinishedTransactions()
  - finish(transaction)

PurchaseCoordinator
  - UI state machine
  - commerce authentication gate
  - backend delivery/retry
  - finish only after delivery

WalletClient
  - GET authoritative wallet

CommerceIdentity
  - Sign in with Apple
  - secure access/refresh session handling
```

Game modules never call StoreKit directly.

---

## 3. Startup order

As soon as commerce subsystem initializes:

1. start one long-lived `Transaction.updates` listener task;
2. authenticate/refresh Commerce Account if refresh token exists;
3. enumerate `Transaction.unfinished`;
4. for each verified unfinished known CozyUni consumable:
   - send JWS to backend claim endpoint;
   - if server returns delivered/already_delivered, call `finish()`;
   - if server temporary error, leave unfinished and retry later;
5. fetch wallet/catalog only after auth is usable where required.

Do not wait for user to open Store before starting transaction listener.

---

## 4. Product loading

Product IDs come from economy config/build-generated typed config.

Client requests StoreKit `Product` objects for enabled IDs.

UI fields:
- localized display name/description as configured in App Store Connect where used;
- StoreKit localized display price;
- CC amount from CozyUni economy config, cross-checked to product ID.

Never construct a player-visible EUR/USD price from `planning_target_eur`.

If one product fails to load:
- hide/disable only that pack;
- log telemetry;
- do not invent price.

If all products fail:
- show Store unavailable state;
- local games remain playable.

---

## 5. Purchase state machine

```text
IDLE
 -> AUTH_REQUIRED? -> AUTHENTICATING
 -> READY
 -> STOREKIT_SHEET
 -> PENDING | CANCELLED | VERIFIED | UNVERIFIED
 -> VERIFIED: SERVER_DELIVERY
 -> DELIVERED: FINISHING_TRANSACTION
 -> COMPLETE

Temporary server failure:
SERVER_DELIVERY -> DELIVERY_PENDING -> retry SERVER_DELIVERY
```

Only one StoreKit purchase flow may be actively initiated by CozyUni UI at a time.

---

## 6. Auth gate

Before calling `product.purchase(...)`:
- require valid Commerce Account access/session;
- if signed out, show `Protect purchases` Sign in with Apple step;
- cancellation returns to Store without error toast implying purchase failure;
- on success obtain stable backend `app_account_token` UUID.

Pass exactly that UUID to StoreKit purchase option `appAccountToken`.

Do not generate a new app account token per purchase.

---

## 7. StoreKit result handling

### User cancelled
- no backend claim;
- no CC change;
- state returns IDLE;
- telemetry `iap_purchase_cancelled`.

### Pending
Examples include approval flows supported by StoreKit.

- show pending state;
- no CC grant;
- do not repeatedly initiate another purchase for same user action;
- later transaction arrives through updates when completed.

### Unverified
- do not deliver credits;
- do not call backend as verified purchase;
- show recoverable support/store verification error;
- log safe telemetry without raw JWS.

### Verified
- obtain `verificationResult.jwsRepresentation`;
- send only signed JWS to `/v1/commerce/apple/transactions/claim`;
- wait for backend authoritative result.

---

## 8. Finishing rule

Call `transaction.finish()` only after backend returns:
- `status=delivered`, or
- `status=already_delivered` for the same verified transaction.

If network/backend delivery fails:
- transaction stays unfinished;
- CC UI does not optimistically grant;
- retry claim;
- startup unfinished recovery will handle app termination/relaunch.

This is mandatory for consumable correctness.

---

## 9. Delivery retry

Retry only backend delivery of an existing verified transaction.
Do not automatically start a second StoreKit purchase.

Suggested client retry schedule while app active:
- immediate first attempt;
- 2 s;
- 5 s;
- 15 s;
- 30 s;
- then stop active loop and rely on foreground/startup recovery.

Retry schedule is UX/network behavior, not a second charge.

---

## 10. Wallet refresh

After successful delivery/finish:
- use wallet state returned by claim response immediately;
- optionally confirm with `GET /wallet` when Store view becomes active again;
- update cached display balance only from server result.

Client local cache may be stale offline and must be labeled/treated as cached display only.

No offline catalog spending in v1.

---

## 11. Catalog spend client flow

For CC cosmetic purchase:

```text
select catalog item
 -> show authoritative current price from server catalog
 -> confirm purchase
 -> generate UUID Idempotency-Key
 -> POST /catalog/purchases
 -> success: update wallet + entitlement UI
 -> failure: map stable error code to UI
```

Do not decrement local wallet before server response.

Retry same spend with same idempotency key until definitive result.

---

## 12. Refund-debt UI

When server wallet says `refund_debt_cc > 0`:
- Store may still display owned items and credit packs;
- catalog CC spend CTA disabled;
- show concise message: refunded credits were previously used and future credit grants first settle the outstanding amount;
- do not show negative spendable CC;
- support link may show transaction/account support identifier, never raw Apple token.

If a new credit pack partly repays debt, delivery result must show:
- CC pack purchased;
- amount applied to prior refund adjustment;
- remaining spendable CC.

---

## 13. Feature flags

Client reads effective remote/build config:
- `commerce_enabled`
- `iap_credit_packs_enabled`
- `catalog_spend_enabled`

When `commerce_enabled=false`:
- no Store purchase UI;
- no login prompt solely for commerce;
- background StoreKit listener may still remain enabled in builds that previously sold IAP so unfinished/updated historical transactions can be safely processed.

Never strand previously purchased unfinished transactions because Store UI feature flag is OFF.

---

## 14. Secure storage

Store in Apple Keychain:
- refresh token;
- active Commerce Account ID reference as needed.

Access token may remain memory-only and be refreshed.

Never store:
- App Store private server key;
- server database credential;
- raw admin credential.

`app_account_token` is not a secret but belongs to Commerce Account state; persist it with commerce session metadata so purchase calls are stable.

---

## 15. Telemetry

Emit safe client events:
- product load success/failure
- purchase started
- cancelled
- pending
- StoreKit verified/unverified
- delivery started/retried/succeeded
- finish succeeded/failed

Never send raw:
- JWS
- identity token
- refresh/access token.

---

## 16. Required StoreKit Test scenarios

Before Sandbox:
- successful purchase each pack;
- cancel;
- pending/approval simulation where available;
- interrupted purchase;
- app killed after StoreKit success before backend delivery;
- backend 500 during delivery;
- duplicate delivery call;
- transaction listener receives update while Store closed;
- unfinished recovery after relaunch;
- account-token mismatch test using backend fixture.

Then repeat critical happy-path/refund flows in App Store Sandbox.

---

## 17. Explicitly forbidden shortcuts

Do not:
- grant CC directly in StoreKit callback;
- call `finish()` before durable backend grant;
- trust client product ID/CC amount;
- store authoritative wallet only in PlayerPrefs/UserDefaults/local save;
- create one appAccountToken per purchase;
- retry a delivery failure by charging again;
- make core board gameplay depend on Store availability.
