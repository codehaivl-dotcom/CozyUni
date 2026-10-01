# CozyUni — Economy, IAP & Store Lock v1.0

Status: **DESIGN LOCK / IMPLEMENTATION-READY / STORE UI MAY REMAIN FEATURE-FLAGGED**

Purpose: define a simple monetization system that can be implemented without changing the five game rules or allowing agents to invent prices, currencies, rewards, or purchase behavior.

Authority for economy/commerce behavior:
1. this file
2. `docs/data/economy_v1.json`
3. `docs/MONETIZATION_AND_APPSTORE.md`
4. game GDDs remain authoritative for match rules

If a commerce behavior is not defined here, do not invent it.

---

## 1. Core decision

CozyUni uses exactly **one global spendable premium currency** in the first monetization version:

- Display name: **Cozy Credits**
- Short code: **CC**
- Scope: app-wide / purchaser wallet
- Persistence: persistent across sessions
- Purchased through Apple In-App Purchase as consumable credit packs
- May also be granted manually/promotionally by CozyUni, but those grants are separately tagged in the ledger
- Purchased CC never expires
- CC is never awarded based on winning a board-game match
- CC cannot buy competitive power

There is **no second spendable soft currency in v1**. Do not add Gems, Coins, Energy, Tickets, Hearts, Tokens, or similar global currencies.

---

## 2. Match currencies are NOT global currency

The following are match-local only:
- Cozy Tycoon Coins
- Cozy Tycoon Community Stars
- scores, points, placements, captures, home counts, spaces, round points

Hard rules:
- they cannot be purchased
- they cannot be converted to CC
- they cannot be transferred to the global wallet
- they cannot persist as purchasing power after the match

`No match score becomes a global currency` remains an architecture rule.

---

## 3. What CC can buy

Allowed CC sinks in v1:
- character outfits
- character cosmetic colorways
- victory poses / emotes
- profile frames / badges
- board skins / table themes
- dice skins
- token/pawn visual skins
- cosmetic environment dressing for board presentation
- seasonal cosmetic bundles

Not allowed:
- extra dice rolls
- rerolls
- movement boosts
- better event odds
- Tycoon starting Coins
- Tycoon income bonuses
- chess hints / engine evaluation
- Caro hints
- extra turns
- immunity from capture
- ranking advantages
- any gameplay stat advantage

Core game access remains free in the current product plan unless a later explicit product decision changes it.

---

## 4. Apple product model

Baseline App Store build uses Apple StoreKit for digital credits and digital content.

### Consumable IAP — credit packs

| Product ID | Type | CC grant | Target base EUR for planning only | Visible label |
|---|---|---:|---:|---|
| `com.cozyuni.credits.100` | Consumable | 100 | 0.99 | 100 Cozy Credits |
| `com.cozyuni.credits.550` | Consumable | 550 | 4.99 | 550 Cozy Credits |
| `com.cozyuni.credits.1200` | Consumable | 1200 | 9.99 | 1,200 Cozy Credits |
| `com.cozyuni.credits.2500` | Consumable | 2500 | 19.99 | 2,500 Cozy Credits |

The EUR values are **planning targets only**. Runtime must display the localized price returned by StoreKit. Agents must never hard-code a customer-facing currency price string.

Approximate bonus relative to 100 CC / €0.99 baseline:
- 100 CC: baseline
- 550 CC: ~9% extra
- 1,200 CC: ~19% extra
- 2,500 CC: ~24% extra

Do not add larger packs without a product decision.

### Non-consumable IAP — later direct purchases

Durable expansions may be sold directly as non-consumable IAP later, for example a future premium region. They are not part of the current catalog and must not be invented by the implementation agent.

---

## 5. Store catalog price bands

CC cosmetic prices use these bands:

| Band | CC | Intended use |
|---|---:|---|
| S | 80 | profile frame / tiny cosmetic |
| A | 150 | emote / victory pose / small token skin |
| B | 250 | standard outfit / simple board skin |
| C | 400 | premium outfit / premium chess or board theme |
| D | 650 | multi-item cosmetic bundle |
| E | 900 | seasonal visual bundle |

A single catalog item must use one of these exact prices unless the economy data file is versioned and updated.

No randomized paid loot boxes.

---

## 6. Store placement / UX

Store entry points:
- Game Library: one `Store` entry in top-level shell
- Customization screen: `Get CC` link if balance is insufficient

Store is NOT shown:
- during an active match
- as an interrupting post-match modal
- inside tutorial steps
- as a countdown pressure prompt

Visible wallet balance:
- Store
- customization/catalog screens
- optional profile panel

Do not show CC in the normal board-game gameplay HUD.

---

## 7. Shared-device ownership model

Current v1 is local multi-player on one device.

Commerce belongs to the **device-owner commerce profile**, not to each temporary local player slot.

Therefore:
- local Player 1/2/3/4 names are guest match identities
- all globally unlocked cosmetics belong to the purchaser/profile library
- any local player slot may select from globally unlocked cosmetics on that device
- guests do not have separate wallets

Do not create four wallets because four people are playing Ludo locally.

Future account/multi-device work may bind the commerce profile to a user account, but current game rules do not depend on that.

---

## 8. Commerce identity — mandatory before paid CC ships

Paid consumable CC must not ship as a local-save-only balance.

Required commerce identity:
- `commerce_user_id`: generated stable UUID
- stored securely on device
- registered with CozyUni commerce backend
- later bindable to a full account without changing ledger IDs

Hard gate:
> If there is no server-backed wallet ledger, paid CC packs stay disabled.

Direct non-consumable purchases can be restored through StoreKit, but CC is maintained by the CozyUni ledger after a verified transaction grant.

---

## 9. Wallet ledger model

Never store only `balance = 1234` as the source of truth.

Use append-only ledger entries.

Required fields:

```text
ledger_id
commerce_user_id
operation_type
source_type
product_id nullable
apple_transaction_id nullable
catalog_item_id nullable
delta_cc signed integer
balance_after integer
idempotency_key unique
created_at_utc
environment sandbox|production
metadata nullable
```

`operation_type` values:
- `IAP_GRANT`
- `PROMO_GRANT`
- `STORE_SPEND`
- `REFUND_ADJUSTMENT`
- `SUPPORT_ADJUSTMENT`

`source_type` values:
- `APPLE_IAP`
- `PROMO`
- `CATALOG`
- `APPLE_REFUND`
- `CUSTOMER_SUPPORT`

Balance constraints:
- integer only
- minimum visible balance = 0
- no floating point
- no expiration timestamp on CC

---

## 10. Credit buckets and spending order

Internally track:
- `bonus_cc`
- `purchased_cc`

UI may show one combined number.

Spend order:
1. bonus CC first
2. purchased CC second
3. purchased CC consumed FIFO by original grant timestamp

---

## 11. Purchase transaction flow

Exact flow:

```text
STORE_OPEN
 -> request products from StoreKit
 -> render StoreKit-localized displayPrice
 -> user selects pack
 -> StoreKit purchase
 -> verify transaction
 -> send verified transaction identity to CozyUni commerce backend
 -> backend idempotently validates/grants CC
 -> backend returns canonical wallet balance
 -> app updates wallet UI
 -> finish StoreKit transaction
 -> PURCHASE_SUCCESS
```

Rules:
- CC is granted once per unique Apple transaction ID
- retries are safe
- duplicate callbacks grant 0 additional CC
- transaction is finished only after grant acknowledgement
- failed/unverified transactions grant 0 CC
- pending/deferred purchase grants 0 CC until verified completion
- UI must survive app termination at any point and reconcile on next launch

---

## 12. Refund / chargeback behavior

When a refund/reversal is confirmed:
1. create `REFUND_ADJUSTMENT`
2. remove remaining unspent CC attributable to the refunded grant up to current balance
3. never display a negative wallet balance
4. if part/all of the refunded grant was already spent, record `refunded_spent_cc` for risk/analytics
5. do not silently remove unrelated previously purchased cosmetics in v1
6. repeated refund abuse may set a server-side commerce review flag; agent must not invent automatic bans

If Apple requests consumption information, backend must be able to report whether credited currency from the transaction has been consumed.

---

## 13. Catalog purchase flow

```text
CATALOG_ITEM_OPEN
 -> verify ownership false
 -> verify item active
 -> verify wallet >= price_cc
 -> user confirms
 -> backend transaction begins
 -> append STORE_SPEND
 -> grant permanent entitlement
 -> commit atomically
 -> return wallet + entitlement
```

Never deduct CC without granting entitlement in the same atomic operation.

Duplicate request uses idempotency key and must not double-spend.

Permanent cosmetic entitlements do not expire.

---

## 14. Initial economy ratios

Design target only — validate by telemetry before changing prices:
- €0.99 pack should buy at least one small cosmetic
- €4.99 pack should buy ~2 standard outfits or one larger theme + small item
- €9.99 pack should buy multiple meaningful cosmetics
- no single launch cosmetic >900 CC
- default catalog should contain both low-cost 80–150 CC items and premium 400–900 CC bundles

---

## 15. Apple / platform compliance lock

For the standard App Store build:
- digital in-app currency/content uses Apple In-App Purchase
- purchased in-game credits do not expire
- runtime uses StoreKit localized prices
- configure Paid Apps Agreement / tax / banking before sale
- StoreKit transaction verification is mandatory
- non-consumable purchases must support restoration
- IAP test plan must include StoreKit Testing, Sandbox, and TestFlight before release
- if CozyUni enters the App Store Kids Category, purchasing opportunities must be behind a parental gate
- alternative payment / regional entitlement systems are a separate legal/product decision and must not be invented into the baseline build

Current Apple documentation should be rechecked before release because platform rules and commissions can change.

Reference starting points:
- https://developer.apple.com/app-store/review/guidelines/
- https://developer.apple.com/help/app-store-connect/reference/in-app-purchases-and-subscriptions/in-app-purchase-types
- https://developer.apple.com/documentation/storekit

---

## 16. Feature flags

Required flags:

```text
commerce.enabled
commerce.credit_packs_enabled
commerce.catalog_enabled
commerce.purchase_enabled
commerce.kids_parental_gate_enabled
```

Development may implement commerce infrastructure while all customer-facing purchase flags remain OFF.

---

## 17. Explicitly out of scope v1

- subscriptions
- battle pass
- energy system
- paid gameplay power
- loot boxes
- player-to-player trading of CC
- gifting CC
- cash-out
- crypto/NFT
- external web checkout in baseline build
- ad network monetization
- dynamic personalized prices
- limited-time countdown pressure pricing
