# CozyUni — App Architecture v0.2

Status: **current game-first architecture direction**

## 1. Goal

One app, modular internally.

The current production app is a **family board-game collection first**. The explorable life-sim world is deferred.

Gameplay rules are owned by the locked GDDs under `docs/games/`; architecture must not reinterpret them.

## 2. Authority rule

For player-visible game behavior:
1. `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
2. selected game GDD
3. this architecture document

Architecture cannot silently override game rules, rankings, setup flow or result behavior.

## 3. Shared shell modules

Shared shell owns:
- boot/update
- game list/navigation
- profile/save
- localization
- global settings/accessibility
- audio service
- analytics plumbing
- room creation/join
- connection/reconnect state
- avatar selection
- common Start Game flow
- common Final Results/rematch shell

Shared shell does **not** own game-specific legal moves or scoring.

## 4. Shared match services

Reusable services:
- authoritative match ID/seed
- player slots
- turn ordering
- room ready state
- action idempotency
- reconnect grace tracking
- match result payload
- rematch readiness

Game modules consume these services but own their rules.

## 5. Engine families

### Path Board package
Consumers:
- Cozy Ludo
- Cozy Journey

Provides only generic primitives:
- D6 service
- ordered path/node representation
- token movement animation hooks
- turn lifecycle hooks
- path hit/highlight helpers

It must not hard-code Ludo safe/capture/home rules or Journey special-space effects.

### Grid Strategy package
Consumers:
- Cozy Caro
- Cozy Chess

Provides:
- grid coordinate representation
- board renderer
- cell hit testing
- selection/highlight layer
- move/action history container

It must not hard-code chess movement or Caro line rules.

### Economy Board package
Consumer:
- Cozy Tycoon

Provides:
- loop-node board representation
- ownership display helpers
- coin transaction primitives
- generic card/event presentation

Tycoon economy constants stay game-local data.

## 6. Current game modules

```text
/modes
  /cozy-ludo
  /cozy-caro
  /cozy-journey
  /cozy-chess
  /cozy-tycoon
```

Old Festival Rush / Firefly Catch / Delivery Dash / Shop Panic examples are not current production modules.

## 7. Mode contract

Every game mode exposes conceptually:
- mode ID / display metadata
- supported player counts
- supported device modes
- start configuration schema
- tutorial completion key
- initialize match from authoritative seed/config
- validate/submit action
- serialize authoritative match state
- restore/reconnect state
- pause-compatible presentation hooks
- produce final result payload
- produce rematch config
- game-specific stats payload

The shell must not inspect internal board rules.

## 8. State ownership

Shared/persistent:
- profile
- avatar preferences
- global settings
- tutorial completion flags
- per-game generic stats

Match-local:
- board position
- dice outcomes
- turn state
- temporary game economy
- ownership
- move history
- result state

No current match score is a global currency.

## 9. Room authority

Room Mode requires one authoritative match state.

Rules:
- clients submit intent/action
- authoritative layer validates against the selected game's rule engine
- accepted actions advance one canonical state revision
- clients render the accepted revision
- reconnect restores canonical state, not a client reconstruction

Transport/backend implementation technology is not locked by the GDD and requires separate engineering design before production Room Mode work.

## 10. Assets

Use stable shared asset IDs.

Examples:
- `characters/rabbit`
- `characters/panda`
- `shared/dice/cozy_d6`
- `shared/results/trophy`
- `games/chess/king`
- `games/tycoon/community_star`

Boards/grids/text/cards are generated in engine/UI wherever specified by the GDD.

## 11. Deferred world layer

Existing world assets remain in the asset catalog but no explorable world scene is required for current game milestones.

Future life-sim world architecture must be designed separately and must not be created as an ad-hoc game-selection lobby.

## 12. Testing rule

Every shared-system change must run:
- shell navigation tests
- settings/save tests
- room/reconnect tests where applicable
- regression tests for every currently integrated game

Each game also runs the acceptance tests listed in its locked GDD.
