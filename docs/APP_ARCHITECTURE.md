# CozyUni — App Architecture v0.3

Status: **current local-first architecture direction**

## 1. Goal

One app, modular internally.

Current production target is a family board-game collection played by multiple local users on one device.

Multi-device networking and explorable world are deferred.

Gameplay rules are owned by locked GDDs under `docs/games/`; architecture must not reinterpret them.

## 2. Authority

For player-visible behavior:
1. `docs/games/00_APP_SHELL_FLOW_LOCK.md`
2. `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
3. selected game GDD
4. this architecture document

Architecture cannot override game rules, rankings, setup flow or result behavior.

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

Current shell does **not** include:
- room creation/join
- networking
- accounts/friends
- public matchmaking
- world traversal

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
- coin transaction primitives
- generic event-card presentation

Tycoon values stay game-local data.

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

Shared persistent:
- global settings
- language/accessibility
- tutorial completion flags
- optional last-used avatar/name preferences
- generic per-game stats

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

## 9. Local authority

Current v1 has one process/device, but match state still uses a single authoritative game-state owner.

Rules:
- UI submits intent/action
- game rules validate it
- accepted action advances one canonical state revision
- presentation renders that accepted state
- double taps/stale UI cannot apply same action twice

This structure is intentionally clean enough for future networking without implementing networking now.

## 10. Assets

Use stable asset IDs.

Examples:
- `characters/rabbit`
- `characters/panda`
- `shared/dice/cozy_d6`
- `shared/results/trophy`
- `games/chess/king`
- `games/tycoon/community_star`

Boards/grids/text/cards generated in engine/UI wherever GDD specifies.

## 11. Deferred multi-device architecture

Do not choose WebSocket/host/server/protocol technology during current local milestone.

Before network work begins, create a dedicated engineering design covering:
- authority model
- transport
- room lifecycle
- action/revision protocol
- reconnect
- host loss
- security/privacy

No speculative networking code is required now.

## 12. Deferred world layer

Existing world assets remain in catalog but no explorable world scene is required.

Future life-sim world architecture is a separate project milestone and must not emerge as an ad-hoc game launcher.

## 13. Testing rule

Every shared-system change runs:
- shell navigation tests
- local setup tests
- settings/save tests
- currently integrated game regression tests

Each game also runs acceptance tests listed in its locked GDD.
