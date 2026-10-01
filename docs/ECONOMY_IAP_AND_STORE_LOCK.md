# CozyUni — Economy, IAP & Store Lock v1.1

Status: **DESIGN LOCK / IMPLEMENTATION-READY / STORE UI FEATURE-FLAGGED**

Purpose: define a simple fair monetization system that can be implemented without changing the five game rules or allowing agents to invent prices, currencies, rewards, or purchase behavior.

Authority for economy/commerce behavior:
1. this file
2. `docs/backend/01_COMMERCE_BACKEND_DESIGN.md`
3. `docs/backend/03_COMMERCE_API_CONTRACT.md`
4. `docs/backend/02_COMMERCE_DATABASE_SCHEMA.md`
5. `docs/data/economy_v1.json`
6. `docs/data/catalog_v1.json`
7. `docs/data/commerce_backend_v1.json`
8. `docs/MONETIZATION_AND_APPSTORE.md`
9. game GDDs remain authoritative for match rules

If a commerce behavior is not defined here or in higher backend authority, do not invent it.

---

## 1. Core decision

CozyUni uses exactly **one global spendable premium currency** in monetization v1:

- Display name: **Cozy Credits**
- Short code: **CC**
- Scope: app-wide Commerce Account wallet
- Persistence: persistent across sessions/devices when signed into same Commerce Account
- Purchased through Apple In-App Purchase as consumable credit packs
- May also be granted promotionally/support-side, separately tagged
- Purchased CC never expires
- CC is never awarded for winning board-game matches
- CC cannot buy competitive power

There is **no second spendable soft currency in v1**. Do not add Gems, Energy, Tickets, Hearts, Tokens, or another global spendable currency.

---

## 2. Match currencies are not global currency

Match-local only:
- Cozy Tycoon Coins
- Cozy Tycoon Community Stars
- scores, points, placements, captures, home counts, spaces, round points

Hard rules:
- cannot be purchased
- cannot convert to CC
- cannot transfer to global wallet
- cannot persist as purchasing power after match

`No match score becomes a global currency` remains architectural canon.

---

## 3. Allowed CC sinks

Allowed in v1:
- character outfits
- character cosmetic colorways
- victory poses / emotes
- profile frames / badges
- board skins / table themes
- dice skins
- token/pawn visual skins
- cosmetic environment dressing
- seasonal cosmetic bundles

Forbidden:
- extra dice rolls
- rerolls
- movement boosts
- better RNG/event odds
- Tycoon starting Coins
- Tycoon income bonuses
- chess/Caro hints or evaluation
- extra turns
- capture immunity
- ranking advantages
- gameplay stat advantages

Core game access remains free in current plan unless explicit future product decision changes it.

---

## 4. Apple credit packs

Baseline App Store build uses StoreKit 2.

| Product ID | Type | CC grant | Planning target EUR only | Visible label |
|---|---|---:|---:|---|
| `com.cozyuni.credits.100` | Consumable | 100 | 0.99 | 100 Cozy Credits |
| `com.cozyuni.credits.550` | Consumable | 550 | 4.99 | 550 Cozy Credits |
| `com.cozyuni.credits.1200` | Consumable | 1200 | 9.99 | 1,200 Cozy Credits |
| `com.cozyuni.credits.2500` | Consumable | 2500 | 19.99 | 2,500 Cozy Credits |

Planning EUR values are not customer-facing authority. Runtime displays StoreKit localized price.

No larger packs without product/economy revision.

Direct non-consumable expansions are later scope and must not be invented now.

---

## 5. Catalog price bands

| Band | CC | Intended use |
|---|---:|---|
| S | 80 | profile frame / tiny cosmetic |
| A | 150 | emote / pose / small token/dice/colorway |
| B | 250 | standard outfit |
| C | 400 | board/table premium theme |
| D | 650 | multi-item cosmetic bundle |
| E | 900 | seasonal visual bundle |

A catalog item uses one exact band price unless economy data is versioned/updated.

No randomized paid loot boxes.

Machine-readable starter catalog:
- `docs/data/catalog_v1.json`

Current starter catalog items default `active=false`; art/QA must approve an item before production activation.

---

## 6. Store placement / UX

Store entry points:
- Game Library: one top-level Store entry
- Customization: `Get CC` when needed

Store is not shown:
- during active match
- as interrupting post-match modal
- inside tutorial
- as countdown-pressure prompt

Visible CC balance:
- Store
- customization/catalog
- optional account/profile panel

Do not show CC in normal board-game gameplay HUD.

---

## 7. Commerce Account ownership

Core local games remain login-free.

Real-money commerce requires a **Commerce Account**.

iOS/iPadOS v1 Commerce Account uses Sign in with Apple.

Rules:
- store may be browsed signed out;
- before first real-money purchase, user completes purchase-protection/sign-in step;
- server resolves/creates one stable Commerce Account;
- one `app_account_token` UUID is attached to that account;
- every StoreKit purchase passes same account token;
- wallet + paid cosmetics belong to Commerce Account, not temporary local Player 1/2/3/4 slots;
- on a shared device, any local match slot may equip cosmetics owned by active Commerce Account;
- one active Commerce Account per install in v1;
- account-switching UI is out of scope.

Do not store email/name just to support commerce v1.

---

## 8. Server-backed wallet hard gate

Paid consumable CC must never ship as local-save-only balance.

Production requires:
- locked commerce backend
- PostgreSQL ledger/credit lots
- Apple transaction verification
- App Store Server Notifications V2
- canonical wallet API
- refund reconciliation

If backend is unavailable/not production-ready, paid CC feature flags stay OFF.

No fallback to PlayerPrefs/UserDefaults/local-save money.

---

## 9. Wallet accounting model

Ledger + credit lots are source of truth.

Internal positive buckets:
- `bonus_cc`
- `purchased_cc`

Spend order:
1. bonus oldest first
2. purchased oldest first

UI normally shows combined spendable CC.

A derived wallet projection may cache:
- purchased CC
- bonus CC
- refund debt
- revision

Projection is not primary history.

Detailed schema:
- `docs/ECONOMY_LEDGER_SCHEMA.md`
- `backend/migrations/001_commerce_v1.sql`

---

## 10. Apple purchase flow

Exact flow:

```text
STORE_OPEN
 -> load StoreKit products/localized prices
 -> user selects pack
 -> ensure Commerce Account authenticated
 -> StoreKit purchase using account appAccountToken
 -> StoreKit verified transaction
 -> send signed transaction JWS to backend
 -> backend verifies + idempotently grants
 -> backend returns canonical wallet
 -> client calls transaction.finish()
 -> PURCHASE_COMPLETE
```

Rules:
- one grant per unique Apple transaction ID
- duplicate callback grants zero additional CC
- failed/unverified transaction grants zero
- pending purchase grants zero until verified completion
- transaction is finished only after backend delivery acknowledgement
- if backend delivery fails, leave transaction unfinished and retry/recover on next launch
- client never decides CC grant from StoreKit product string alone

Client implementation lock:
- `docs/commerce/STOREKIT_CLIENT_IMPLEMENTATION.md`

---

## 11. Refund model

Apple refund is applied against original purchased-credit grant.

### Unspent refunded credits
Remove remaining CC from that source lot.

### Already-spent refunded credits
Create non-negative `refund_debt_cc` for consumed refunded amount.

While debt > 0:
- spendable CC = 0
- catalog spending disabled
- future positive grants repay debt first

Existing cosmetic entitlements are not automatically revoked in v1 solely because a pack refund creates debt.

Example:

```text
purchase +550
spend 500
remaining 50
full refund
 -> remove 50
 -> debt 500
 -> spendable 0
```

If refund is later reversed:
- clear debt created by that refund first
- restore any remaining purchased CC effect
- process once only

No negative visible wallet balance.

---

## 12. Catalog purchase flow

```text
CATALOG_ITEM_OPEN
 -> server catalog says active + price
 -> ownership check
 -> user confirms
 -> send catalog_id + idempotency key
 -> backend locks wallet
 -> spend lots atomically
 -> append ledger
 -> grant entitlement
 -> update projection
 -> commit
 -> return wallet + entitlement
```

Client never sends authoritative price.

Duplicate idempotency key must not double-spend.
Permanent cosmetics do not expire.

---

## 13. Starter catalog ratios

Design targets:
- €0.99/100 CC pack buys at least one 80 CC item
- €4.99/550 CC pack buys multiple small cosmetics or two 250 CC outfits with small remainder
- €9.99/1200 CC supports several meaningful cosmetics
- no launch cosmetic >900 CC
- launch catalog contains low-cost 80–150 CC and higher 250–400 CC choices before any 650–900 bundle activation

Tools:

```bash
python tools/analyze_catalog_economy.py
python tools/validate_catalog_data.py
```

Planning analysis does not replace localized StoreKit pricing.

---

## 14. Apple/platform compliance lock

Baseline build:
- digital in-app currency/content uses Apple IAP
- purchased CC does not expire
- StoreKit localized prices displayed
- StoreKit transaction verification required
- App Store Server Notifications V2 configured before production
- StoreKit Test + Sandbox + TestFlight checks before release
- if CozyUni enters Kids Category, purchasing opportunities require appropriate parental gating
- regional/alternative-payment systems are separate legal/product decisions

Recheck current Apple docs before release because platform rules can change.

---

## 15. Feature flags

Canonical backend/client flags:

```text
commerce_enabled
iap_credit_packs_enabled
catalog_spend_enabled
sign_in_with_apple_required_for_purchase
```

Production defaults are OFF except sign-in requirement.

Historical unfinished StoreKit transactions must still be processed safely even when Store UI is disabled.

---

## 16. Telemetry / simulation

Authority:
- `docs/DATA_TELEMETRY_AND_SIMULATION.md`

Tools:
- `tools/sim_economy.py`
- `tools/sim_wallet_policy.py`
- `tools/analyze_catalog_economy.py`

Track purchase funnel, delivery, refund debt, CC grants/spend, reconciliation errors, and payer metrics without sending raw Apple JWS/tokens to analytics.

---

## 17. Explicitly out of scope v1

- subscriptions
- battle pass
- energy
- paid gameplay power
- loot boxes
- player-to-player CC trading/gifting
- cash-out
- crypto/NFT
- external web checkout baseline
- ad network monetization
- dynamic personalized prices
- pressure countdown pricing
- multiple concurrent Commerce Accounts per install
