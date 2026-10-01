# CozyUni — Data, Telemetry & Simulation Plan v1.0

Status: **IMPLEMENTATION SPEC / NO-INVENTION DATA CONTRACT**

Purpose: stop agents from hard-coding tuning values and provide measurable gates before game/economy numbers are changed.

---

## 1. Source-of-truth split

Use machine-readable data for numeric configuration.

```text
docs/data/economy_v1.json     economy / IAP / catalog bands / simulation defaults
future game data files        game-specific tuning values once implementation starts
```

Markdown explains behavior. JSON contains exact numeric values.

Rules:
- code does not duplicate constants already present in data
- tests load the same data as runtime where practical
- simulators load the same data
- a changed number requires versioned data + changelog note

---

## 2. Economy metrics

Required commerce metrics:

### Funnel
- `store_open`
- `iap_product_impression`
- `iap_purchase_started`
- `iap_purchase_pending`
- `iap_purchase_success`
- `iap_purchase_failed`
- `iap_purchase_cancelled`
- `catalog_item_view`
- `catalog_purchase_success`
- `catalog_purchase_insufficient_balance`

### Wallet
- CC granted by IAP
- CC granted by promo/support
- CC spent
- ending wallet balance distribution
- purchased CC outstanding
- bonus CC outstanding
- refund-adjusted CC

### Business calculations
- payer conversion = unique purchasers / eligible active users
- ARPPU = gross purchase revenue / unique purchasers
- ARPDAU = gross purchase revenue / DAU
- purchase success rate = successful purchases / purchase starts
- refund rate = refunded transactions / successful transactions
- CC burn rate = CC spent / CC granted
- CC outstanding = total granted - total spent - refund adjustments

Never call revenue `profit`; Apple commission, tax, refunds, hosting, marketing and business costs are separate.

---

## 3. Core product telemetry

Required before monetization is scaled:
- app first open
- Game Library viewed
- game selected
- local setup started/completed
- tutorial started/completed/skipped
- match started/completed/abandoned
- rematch selected
- game menu return
- session duration
- matches/session
- game mix

Retention cohorts:
- D1
- D7
- D30 when enough time/data exists

Do not require personal names, email, precise location or chat content for these metrics.

---

## 4. Game simulation gates

When each rules engine becomes headless-callable, create a deterministic simulator that uses the exact production rule engine, not a rewritten approximate copy.

### Cozy Ludo
Run >=100,000 seeded matches for each 2P/3P/4P configuration.
Measure:
- win rate by starting slot
- turns/match mean, median, P90, P95
- estimated session duration
- no-legal-move rate
- captures/player
- bonus-roll frequency
- pieces home distribution at end
- first-player advantage

Review trigger:
- any starting slot deviates >3 percentage points from equal-share win rate over sufficiently large sample
- P95 4P session >15 minutes under timing model

### Cozy Caro
Tic-Tac-Toe exhaustive state tests; Five-in-a-Row property-based tests.
Measure/test:
- no illegal occupied overwrite
- win detector directions
- 5+ overline accepted
- board-full draw
- deterministic side assignment from seed

No balance bot tuning is required for human-v-human v1.

### Cozy Journey
Run >=100,000 matches each 2P/3P/4P.
Measure:
- win rate by starting slot
- turns to finish
- time estimate
- landing frequency for every special space
- transport benefit distribution
- negative-space frequency
- Picnic extra-roll frequency

Review trigger:
- any slot >3 percentage points from equal-share expectation
- P95 4P >12 minutes

### Cozy Chess
Do not balance chess rules.
Use legal-rule regression suites/perft-style position tests for move generation, castling, en passant, promotion, repetition and draw conditions.

### Cozy Tycoon
Run >=100,000 seeded matches per 2P/3P/4P once a deterministic policy-bot harness exists.
At minimum use three bot policies:
- `CONSERVATIVE`
- `BALANCED`
- `AGGRESSIVE`

Measure:
- Prosperity mean/P10/P50/P90
- Coins end distribution
- property ownership count
- district completion rate
- L1/L2 upgrades
- transport ownership
- Community Stars
- event impact by card
- starting-slot win rate
- runaway-leader index
- decision/no-choice turn ratio
- trade offer/acceptance rate when trade policies enabled

Review triggers:
- starting-slot advantage >3 percentage points
- one event card contributes >10% of average final Prosperity swing by itself
- one property district produces clearly dominant expected value without compensating cost/risk
- >20% of turns have no meaningful decision after opening phase

---

## 5. Economy simulator

Repository tool:

```text
tools/sim_economy.py
```

It reads:

```text
docs/data/economy_v1.json
```

It estimates:
- monthly payers
- purchase count
- gross revenue
- configurable post-store-commission proceeds estimate
- refund-adjusted estimate
- credits issued
- average credits/payer
- average revenue/payer

Use it for scenario comparison only, not as a forecast guarantee.

Required scenarios:
- payer rate 0.5%, 1%, 2%, 3%, 5%
- store commission assumptions 15% and 30%
- refund rate default 2%

Commission is configurable because Apple terms/program eligibility/region may differ and can change.

---

## 6. Economy launch gates

Paid CC remains disabled until all are true:
- StoreKit products load in Sandbox
- transaction verification passes
- duplicate transaction test passes
- app-killed-mid-purchase recovery passes
- deferred/Ask-to-Buy state passes where applicable
- server wallet idempotency test passes
- catalog atomic spend/entitlement test passes
- refund adjustment path tested
- localized price display verified
- privacy policy / purchase terms prepared
- parental gate added if Kids Category is selected

---

## 7. Data quality rules

- every event has `event_id` and UTC timestamp
- commerce events include environment `sandbox|production`
- purchase transaction IDs are never duplicated in grant ledger
- analytics failure must never block gameplay or purchase acknowledgement
- debug builds can log full test IDs; production telemetry minimizes raw identifiers
- no agent may add a new tracked personal-data field without a privacy review
