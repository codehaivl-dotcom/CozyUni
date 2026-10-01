# CozyUni — Monetization & App Store Strategy v0.2

Status: **CURRENT / ECONOMY DESIGN DEFINED / LAUNCH ENABLEMENT GATED**

Detailed commerce behavior is authoritative in:
- `docs/ECONOMY_IAP_AND_STORE_LOCK.md`
- `docs/data/economy_v1.json`

## Product position

CozyUni is one coherent app containing the five current local board games and, later, a deeper life-sim world. Do not split near-duplicate game binaries merely to reuse the same asset library.

Current games:
1. Cozy Ludo
2. Cozy Caro
3. Cozy Journey
4. Cozy Chess
5. Cozy Tycoon

## Monetization principle

Monetization must not alter match fairness.

Current monetization architecture:
- one premium currency: **Cozy Credits (CC)**
- CC purchased through Apple IAP consumable packs
- cosmetics are the primary sink
- no paid gameplay power
- no loot boxes
- no energy system
- no subscription at initial implementation
- no forced advertising

Store infrastructure may be implemented behind feature flags before store UI is enabled to customers.

## Apple baseline

For digital goods/currency in the standard App Store build, use Apple In-App Purchase / StoreKit.

Important current platform rules to recheck at release:
- digital in-app currency and premium digital content generally use IAP in the baseline App Store flow
- credits purchased through IAP may not expire
- IAP products include consumable and non-consumable types
- localized customer pricing must come from StoreKit / App Store Connect
- Paid Apps Agreement, tax, and banking setup is required to sell paid content
- if the app is submitted to the Kids Category, purchase opportunities must be behind a parental gate

Apple offers many price points and automatically localized storefront pricing. Do not hard-code Euro strings in the product UI.

## Launch catalog direction

Sell attachment, not power:
- character outfits
- colorways
- profile cosmetics
- victory poses / emotes
- board/table themes
- dice/token skins
- seasonal visual bundles

Do not sell:
- rerolls
- extra turns
- better RNG
- Tycoon starting wealth
- Chess/Caro hints for money
- capture protection
- ranking boosts

## Ads

No ads in current monetization design.

If ads are reconsidered later, create a separate product decision and privacy review first. Do not let an agent add an ad SDK opportunistically.

## Subscription

No subscription in current scope.

A subscription requires recurring value and content cadence; platform support alone is not justification.

## Store listing

Store screenshots and metadata must reflect the actual current game-first product. Do not use stale Festival Rush / Firefly Catch copy.

Preferred screenshot themes once present in build:
1. Choose a CozyUni game
2. Play together on one screen
3. Cozy Ludo
4. Cozy Caro / Chess strategy
5. Cozy Journey / Tycoon world-like boards
6. Customize your CozyUni style (only if customization/store ships)

## Monetization gate

Do not enable paid CC merely because StoreKit works.

Minimum product signals before scaling monetization:
- onboarding completion is healthy
- matches complete reliably
- repeat sessions exist
- testers voluntarily rematch
- players show interest in character/board customization

Implementation safety gates are listed in `docs/DATA_TELEMETRY_AND_SIMULATION.md`.

## Platform economics

Never hard-code a single Apple commission assumption into design math. Program eligibility, region and platform terms may change.

The simulator supports configurable commission scenarios (including 15% and 30%) and refunds. App Store Connect financial reports remain accounting authority for real proceeds.
