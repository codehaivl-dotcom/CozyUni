# CozyUni — App Architecture v0.4

Status: **current local-first architecture direction**

## 1. Goal

One app, modular internally.

Current production target is a family board-game collection played by multiple local users on one device.

Multi-device networking and full explorable world remain later milestones.

Gameplay rules are owned by locked GDDs under `docs/games/`; architecture must not reinterpret them.
Global economy/commerce behavior is owned by `docs/ECONOMY_IAP_AND_STORE_LOCK.md`.

## 2. Authority

For player-visible game behavior:
1. `docs/games/00_APP_SHELL_FLOW_LOCK.md`
2. `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
3. selected game GDD
4. this architecture document

For commerce:
1. `docs/ECONOMY_IAP_AND_STORE_LOCK.md`
2. `docs/data/economy_v1.json`
3. `docs/MONETIZATION_AND_APPSTORE.md`
4. this architecture document

Architecture cannot override game rules, rankings, setup flow, results, currency grants, catalog prices, or purchase behavior.

## 3. Current shared shell modules

Current shell owns:
- boot/splash
- Game Library
- Game Start Screen
- local player setup
- avatar/name selection
- settings/accessibility
- localization
- audio service
- common tutorial framework
- pause/help
- common Final Results/rematch
- local save/stats
- deterministic match seed service

Commerce-capable shell modules behind feature flags:
- Store entry
- customization/catalog screen
- visible CC wallet balance outside matches
- purchase status UI

Current shell does **not** include:
- room creation/join
- networking for gameplay
- public matchmaking
- full friends/social system

A minimal commerce identity/backend is allowed before full account/social systems because paid consumable currency requires durable server reconciliation.

## 4. Shared local match services

Reusable services:
- match ID
- deterministic seed/RNG where needed
- local player slots
- starting-player ordering
- action idempotency / double-tap protection
- match result payload
- rematch configuration
- tutorial completion flags

Game modules consume these but own rules.

## 5. Engine families

### Path Board package
Consumers:
- Cozy Ludo
- Cozy Journey

Provides generic primitives only:
- D6 service
- ordered path/node representation
- token movement hooks
- turn lifecycle hooks
- path hit/highlight helpers

Must not hard-code game-specific capture/safe/event rules.

### Grid Strategy package
Consumers:
- Cozy Caro
- Cozy Chess

Provides:
- grid coordinates
- board renderer
- cell hit testing
- selection/highlight layer
- action/move history container

Must not hard-code chess movement or Caro line rules.

### Economy Board package
Consumer:
- Cozy Tycoon

Provides:
- loop-node representation
- ownership display helpers
- match-local coin transaction primitives
- generic event-card presentation

Tycoon values stay game-local data.
Tycoon Coins are never connected to Cozy Credits.

## 6. Game modules

```text
/modes
  /cozy-ludo
  /cozy-caro
  /cozy-journey
  /cozy-chess
  /cozy-tycoon
```

Only modules actually included in current build appear in Game Library.

## 7. Mode contract

Every game exposes conceptually:
- mode ID/display metadata
- supported local player counts
- start configuration schema
- tutorial completion key
- initialize match from seed/config
- validate/submit local action
- serialize match state for save/debug/test if needed
- pause-compatible presentation hooks
- produce final result payload
- produce rematch config
- game-specific stats payload

Shell must not inspect internal legal-move logic.

## 8. State ownership

Shared persistent local cache:
- global settings
- language/accessibility
- tutorial completion flags
- optional last-used avatar/name preferences
- generic per-game stats
- cached global cosmetic entitlements
- cached CC display balance from canonical commerce backend
- stable `commerce_user_id` credential/token material stored securely

Server-authoritative commerce state once paid CC is enabled:
- wallet ledger
- purchased/bonus CC buckets
- IAP grant transaction IDs
- permanent catalog entitlements
- refund adjustments

Match-local:
- player slots
- board state
- dice outcomes
- turn state
- temporary economy
- ownership
- move history
- result state

No match score becomes a global currency.

## 9. Local game authority

Current v1 has one game process/device, but match state still uses a single authoritative game-state owner.

Rules:
- UI submits intent/action
- game rules validate it
- accepted action advances one canonical state revision
- presentation renders that accepted state
- double taps/stale UI cannot apply same action twice

This structure is intentionally clean enough for future networking without implementing gameplay networking now.

## 10. Commerce architecture

Commerce is a separate subsystem from all game rules.

Conceptual modules:

```text
/commerce
  EconomyConfig
  StoreCatalog
  StoreKitAdapter
  PurchaseCoordinator
  WalletClient
  EntitlementClient
  CommerceIdentity
  CommerceTelemetry
```

Hard boundaries:
- game modules cannot directly call StoreKit
- game modules cannot grant CC
- UI cannot mutate wallet balance locally
- StoreKit callbacks cannot grant twice
- backend grants are idempotent by Apple transaction ID
- catalog spend + entitlement grant is atomic
- purchase/customer-facing feature flags may stay OFF while test adapters exist

Production paid-CC flow requires:
- verified StoreKit transaction
- commerce backend
- append-only wallet ledger
- canonical balance response

If backend is unavailable before launch, paid CC products stay disabled rather than falling back to local-only balance.

## 11. Assets

Use stable asset IDs.

Examples:
- `characters/rabbit`
- `characters/panda`
- `shared/dice/cozy_d6`
- `shared/results/trophy`
- `games/chess/king`
- `games/tycoon/community_star`

Boards/grids/text/cards generated in engine/UI wherever GDD specifies.

## 12. Deferred multi-device gameplay architecture

Do not choose WebSocket/host/server/protocol technology during current local match milestone.

Before multi-device gameplay work begins, create a dedicated engineering design covering:
- authority model
- transport
- room lifecycle
- action/revision protocol
- reconnect
- host loss
- security/privacy

Commerce backend existence does not imply gameplay networking is implemented.

## 13. World layer

Existing world assets and current visual MVP docs may be developed independently of the board rules, but a full life-sim world architecture is still a separate project milestone.

Do not let Store/economy implementation silently define world progression, jobs, quests, housing economy, or world resource loops. Those require a future world gameplay GDD.

## 14. Testing rule

Every shared-system change runs:
- shell navigation tests
- local setup tests
- settings/save tests
- currently integrated game regression tests

Economy/commerce changes also run:
- `docs/data/economy_v1.json` validation
- fake StoreKit adapter tests
- duplicate transaction idempotency tests
- wallet atomic spend tests
- StoreKit Test / Sandbox scenarios before enablement

Each game also runs acceptance tests listed in its locked GDD.
