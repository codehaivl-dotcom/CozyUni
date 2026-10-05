# CozyUni — App Architecture v0.6

Status: **current local-first architecture direction / Godot implementation bound**

## 1. Goal

One app, modular internally.

Current shipping target is a family board-game collection played by multiple local users on one device.

A bounded world visual/environment R&D track is also allowed under `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`, but it is not the shipping critical path and does not authorize deep life-sim systems.

Multi-device gameplay networking remains a later milestone.

Gameplay rules are owned by locked GDDs under `docs/games/`; architecture must not reinterpret them.
Global economy/commerce behavior is owned by `docs/ECONOMY_IAP_AND_STORE_LOCK.md` and the locked backend contracts under `docs/backend/`.

## 2. Authority

Global production order and milestone admission:
1. `AGENTS.md`
2. `docs/PRODUCTION_MASTER_PLAN.md`

For player-visible game behavior:
1. `docs/games/00_APP_SHELL_FLOW_LOCK.md`
2. `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
3. `docs/games/00_SHARED_UI_LAYOUT_LOCK.md`
4. selected game GDD
5. matching data under `docs/data/games/`
6. this architecture document

For client implementation:
1. `docs/engineering/00_ENGINE_TECH_STACK_LOCK.md`
2. `docs/engineering/01_GODOT_PROJECT_ARCHITECTURE.md`
3. other applicable `docs/engineering/` locks
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

Architecture cannot override game rules, rankings, setup flow, results, currency grants, catalog prices, purchase behavior, or production milestone gates.

## 3. Client technology

Current client implementation:
- Godot 4.7.2 stable;
- Mobile renderer production baseline;
- typed GDScript;
- tablet landscape first;
- iPad/iOS release-critical;
- Windows/macOS development/test.

The root Godot project is `project.godot`.

Canonical source layout begins:

```text
project.godot
src/
  app/
  core/
  data/
  modes/
  shared_board/
  world/
  ui/
  commerce/
scenes/
  app/
  modes/
  shared/
  world/
tests/
assets/
```

Detailed rules live in `docs/engineering/01_GODOT_PROJECT_ARCHITECTURE.md`.

## 4. Current shared shell modules

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

## 5. Shared local match services

Reusable services:
- match ID
- deterministic seed/RNG where needed
- local player slots
- starting-player ordering
- action idempotency / double-tap protection
- monotonic state revision
- match result payload
- rematch configuration
- tutorial completion flags

Game modules consume these but own rules.

UI submits semantic intent. The authoritative game-state/rules owner decides legality and advances state exactly once.

## 6. Engine families

### Path Board package
Consumers:
- Cozy Ludo
- Cozy Journey

Provides generic primitives only:
- D6 presentation/service integration
- ordered path/node representation
- token movement presentation hooks
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
- action/move history presentation container

Must not hard-code chess movement or Caro line rules.

### Economy Board package
Consumer:
- Cozy Tycoon

Provides:
- loop-node representation
- ownership display helpers
- match-local coin transaction presentation primitives
- generic event-card presentation

Tycoon values stay game-local data.
Tycoon Coins are never connected to Cozy Credits.

## 7. Game modules

Godot source target:

```text
src/modes/
  cozy_ludo/
  cozy_caro/
  cozy_journey/
  cozy_chess/
  cozy_tycoon/

scenes/modes/
  cozy_ludo/
  cozy_caro/
  cozy_journey/
  cozy_chess/
  cozy_tycoon/
```

Only modes actually admitted/included in the current build appear in Game Library.

## 8. Mode contract

Every game exposes conceptually:
- mode ID/display metadata
- supported local player counts
- start configuration schema
- tutorial completion key
- create/initialize match from seed/config
- get public state
- get legal actions for relevant player
- validate/submit local action with expected revision
- serialize deterministic debug/test state
- pause-compatible presentation hooks
- produce final result payload
- produce rematch config
- game-specific stats payload

Shell must not inspect internal legal-move logic.

## 9. State ownership

Shared persistent local cache:
- global settings
- language/accessibility
- tutorial completion flags
- optional last-used avatar/name preferences
- generic per-game stats
- cached cosmetic entitlements
- cached CC display balance from canonical commerce backend
- Commerce Account session material stored in platform-secure storage when commerce ships

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
- canonical state revision

No match score becomes a global currency.

## 10. Local game authority

Current v1 has one game process/device, but match state still uses a single authoritative game-state owner.

Rules:
- UI submits intent/action
- game rules validate it
- action carries/compares expected state revision
- accepted action advances one canonical state revision
- presentation renders accepted state/events
- double taps/stale UI cannot apply the same action twice

This structure is intentionally clean enough for future networking without implementing gameplay networking now.

Rules code must be runnable headlessly without rendered scenes so tests/simulation can use the production rules rather than a parallel rewrite.

## 11. Data runtime

Canonical design data remains under `docs/data/`.

Current Godot bootstrap loads game JSON directly from:

```text
res://docs/data/games/*.json
```

This intentionally avoids manually divergent runtime copies during bootstrap.

If later packaging requires generated copies under `res://data/`, add a deterministic sync/hash validation step. Never maintain two hand-edited rule datasets.

## 12. Commerce client architecture

Commerce is separate from all game rules.

Conceptual app modules:

```text
src/commerce/
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
- unfinished/updated transactions are processed for recovery

If backend is unavailable before launch, paid CC products stay disabled rather than falling back to local-only balance.

## 13. Commerce backend architecture

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

Backend source target:

```text
backend/
  src/
    auth/
    apple/
    wallet/
    catalog/
    admin/
    worker/
    db/
  migrations/
```

Exact DB authority begins at `backend/migrations/001_commerce_v1.sql`.

The backend implementation is not a prerequisite for local Shell/Ludo vertical-slice work; paid commerce stays feature-flagged until its own gate passes.

## 14. Commerce identity boundary

Local game profiles are not paid accounts.

Commerce Account rules:
- no login required to play board games;
- store browsing may be signed out;
- first real-money purchase requires Sign in with Apple;
- server issues one stable Commerce Account and `app_account_token` UUID;
- each StoreKit purchase passes that token;
- paid wallet and cosmetics belong to Commerce Account, not to a local Player 1/2/3/4 slot.

Do not silently promote Commerce Account into friends/social/profile account behavior.

## 15. Assets

Use stable asset IDs.

Examples:
- `characters/rabbit`
- `characters/panda`
- `shared/dice/cozy_d6`
- `shared/results/trophy`
- `games/chess/king`
- `games/tycoon/community_star`

Boards/grids/text/cards are generated in engine/UI wherever the GDD specifies.

3D import/world assembly authority is `docs/engineering/02_ASSET_IMPORT_AND_WORLD_ASSEMBLY.md`.
Generation routing is `docs/assets/GENERATION_SOURCE_OF_TRUTH.md`.

## 16. World layer

Current world Visual MVP is an independent **Track B** under `docs/PRODUCTION_MASTER_PLAN.md`.

Architecture target:
- reusable world player/camera;
- one scene per admitted world region;
- engine terrain/water/environment;
- GridMap/MeshLibrary only for suitable snap-friendly modules;
- MultiMesh for suitable high-count repeated decoration;
- individual wrapper scenes for buildings/hero/interactable assets;
- collision/navigation proven before final art pass.

Deep life-sim architecture remains deferred.

Do not let Store/economy implementation silently define world progression, jobs, quests, friendship, housing economy, or world resource loops. Those require a future world gameplay GDD.

## 17. Deferred multi-device gameplay architecture

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

## 18. Testing / completion rule

Every shared-system change runs applicable gates from:

`docs/engineering/06_QA_BUILD_RELEASE_GATES.md`

At minimum current CI covers:
- canonical game data validation;
- commerce/catalog data validation;
- Godot import/parse smoke;
- main-scene boot smoke.

As production rules are added, deterministic rules tests become mandatory before the game enters visual polish.

Each game additionally runs acceptance tests listed in its locked GDD.
