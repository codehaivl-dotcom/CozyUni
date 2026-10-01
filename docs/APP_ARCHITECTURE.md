# CozyUni — App Architecture v0.5

Status: **current local-first architecture direction**

## 1. Goal

One app, modular internally.

Current production target is a family board-game collection played by multiple local users on one device.

Multi-device gameplay networking and full explorable world remain later milestones.

Gameplay rules are owned by locked GDDs under `docs/games/`; architecture must not reinterpret them.
Global economy/commerce behavior is owned by `docs/ECONOMY_IAP_AND_STORE_LOCK.md` and the locked backend contracts under `docs/backend/`.

## 2. Authority

For player-visible game behavior:
1. `docs/games/00_APP_SHELL_FLOW_LOCK.md`
2. `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
3. selected game GDD
4. this architecture document

For commerce:
1. `docs/ECONOMY_IAP_AND_STORE_LOCK.md`
2. `docs/backend/01_COMMERCE_BACKEND_DESIGN.md`
3. `docs/backend/03_COMMERCE_API_CONTRACT.md`
4. `docs/backend/02_COMMERCE_DATABASE_SCHEMA.md`
5. `docs/data/economy_v1.json`
6. `docs/data/commerce_backend_v1.json`
7. this architecture document

Implementation technology for commerce is locked by `docs/backend/00_BACKEND_TECH_STACK_LOCK.md`.

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
- Sign in with Apple commerce-protection step

Current shell does **not** include:
- room creation/join
- networking for gameplay
- public matchmaking
- full friends/social system

A minimal Commerce Account/backend is explicitly allowed before full social/account systems because paid consumable currency requires durable reconciliation.

Core local games remain playable without commerce authentication.

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
- cached cosmetic entitlements
- cached CC display balance from canonical commerce backend
- Commerce Account session material stored in platform-secure storage

Server-authoritative commerce state once paid CC is enabled:
- Commerce Account
- Sign in with Apple identity mapping
- wallet ledger
- credit lots
- purchased/bonus CC projection
- refund debt
- Apple transaction IDs/JWS audit
- permanent catalog entitlements
- App Store Server Notifications processing

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

## 10. Commerce client architecture

Commerce is separate from all game rules.

Conceptual app modules:

```text
/commerce
  EconomyConfig
  StoreCatalog
  StoreKitAdapter
  PurchaseCoordinator
  WalletClient
  EntitlementClient
  CommerceIdentity
  SecureSessionStore
  CommerceTelemetry
```

Hard boundaries:
- game modules cannot directly call StoreKit
- game modules cannot grant CC
- UI cannot mutate wallet balance locally
- StoreKit callbacks cannot grant twice
- backend grants are idempotent by Apple transaction ID
- catalog spend + entitlement grant is atomic server-side
- paid purchase is not considered delivered until backend confirms it
- client calls `Transaction.finish()` only after server delivery acknowledgement
- `Transaction.updates`/unfinished transactions are processed on launch for recovery

If backend is unavailable before launch, paid CC products stay disabled rather than falling back to local-only balance.

## 11. Commerce backend architecture

Locked commerce v1 backend:

```text
Node.js 22 LTS + TypeScript strict + Fastify 5
               |
               +-- PostgreSQL 16+
               +-- Apple official App Store Server Library
               +-- App Store Server API
               <-- App Store Server Notifications V2
```

No Redis/message broker/microservice split in v1.
PostgreSQL outbox rows support retryable background work.

Backend source structure should follow conceptually:

```text
/backend
  /src
    /auth
    /apple
    /wallet
    /catalog
    /admin
    /worker
    /db
  /migrations
```

Exact DB authority begins at `backend/migrations/001_commerce_v1.sql`.

## 12. Commerce identity boundary

Local game profiles are not paid accounts.

Commerce Account rules:
- no login required to play board games;
- store browsing may be signed out;
- first real-money purchase requires Sign in with Apple;
- server issues one stable Commerce Account and `app_account_token` UUID;
- each StoreKit purchase passes that token;
- paid wallet and cosmetics belong to Commerce Account, not to a local Player 1/2/3/4 slot.

Do not silently promote Commerce Account into friends/social/profile account behavior.

## 13. Assets

Use stable asset IDs.

Examples:
- `characters/rabbit`
- `characters/panda`
- `shared/dice/cozy_d6`
- `shared/results/trophy`
- `games/chess/king`
- `games/tycoon/community_star`

Boards/grids/text/cards generated in engine/UI wherever GDD specifies.

## 14. Deferred multi-device gameplay architecture

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

## 15. World layer

Existing world assets and current visual MVP docs may be developed independently of board rules, but a full life-sim world architecture is still a separate project milestone.

Do not let Store/economy implementation silently define world progression, jobs, quests, housing economy, or world resource loops. Those require a future world gameplay GDD.

## 16. Testing rule

Every shared-system change runs:
- shell navigation tests
- local setup tests
- settings/save tests
- currently integrated game regression tests

Economy/commerce changes also run:
- `docs/data/economy_v1.json` validation
- `docs/data/commerce_backend_v1.json` validation
- fake StoreKit adapter tests
- Sign in with Apple auth tests
- duplicate transaction idempotency tests
- duplicate notification idempotency tests
- wallet atomic spend tests
- refund/debt tests
- projection reconciliation tests
- StoreKit Test / Sandbox scenarios before enablement

Each game also runs acceptance tests listed in its locked GDD.
