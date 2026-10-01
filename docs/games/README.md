# CozyUni — Locked Game Design Set

Status: **GAME-FIRST / SINGLE-DEVICE FULL GDD v1**

## Authority order

Implementation agents must read in this order:

1. [`00_APP_SHELL_FLOW_LOCK.md`](./00_APP_SHELL_FLOW_LOCK.md) — exact app launch, Game Library, game selection, local setup, result navigation; **single-device only for current v1**.
2. [`00_SHARED_GAME_EXPERIENCE_LOCK.md`](./00_SHARED_GAME_EXPERIENCE_LOCK.md) — tutorial, HUD hierarchy, pause/settings, results, rematch, accessibility, no-invention rule.
3. [`00_SHARED_UI_LAYOUT_LOCK.md`](./00_SHARED_UI_LAYOUT_LOCK.md) — exact screen zones and layout hierarchy.
4. Selected game's full GDD below.
5. [`00_GDD_AUDIT_2026-10-01.md`](./00_GDD_AUDIT_2026-10-01.md) — audit record.
6. `../GAME_MODE_ROADMAP.md` for production order only.
7. `../assets/00_RENDER_RULES_LOCKED.md` for AI→3D production.

Higher source wins on conflict.

If a lower-priority game document still mentions Room Mode / Create Room / Join Room, those sections are **FUTURE/DEFERRED and inactive for current v1**. Do not implement them until a new multi-device design lock is approved.

If a required behavior is not specified by current locks/GDD: **do not invent it; raise a design question**.

## Current product flow

```text
APP LAUNCH
 -> GAME LIBRARY
 -> select game card
 -> GAME START SCREEN
 -> PLAY
 -> LOCAL PLAYER SETUP
 -> MATCH SUMMARY
 -> TUTORIAL if needed
 -> COUNTDOWN
 -> MATCH
 -> FINAL RESULTS
      -> REMATCH
      -> CHANGE PLAYERS
      -> GAME LIBRARY
```

Current v1 has no online/multi-device mode selector.

## Current five games

1. [`01_COZY_LUDO.md`](./01_COZY_LUDO.md) — 2–4 local players, first production game
2. [`02_COZY_CARO.md`](./02_COZY_CARO.md) — local 2P Tic-Tac-Toe 3×3 + Freestyle Five 15×15
3. [`03_COZY_JOURNEY.md`](./03_COZY_JOURNEY.md) — 2–4 local players, fixed 36-space travel race
4. [`04_COZY_CHESS.md`](./04_COZY_CHESS.md) — local 2P standard casual chess
5. [`05_COZY_TYCOON.md`](./05_COZY_TYCOON.md) — 2–4 local players, fixed 28-node / 12-round economy board

Cozy Checkers is not active.

## Current production rule

Build one game at a time.

Production order:

`Cozy Ludo -> Cozy Caro -> Cozy Journey -> Cozy Chess -> Cozy Tycoon`

Do not parallel-build all five systems.

## Full-GDD completeness standard

Each active game must lock:
- product role
- supported local player count
- exact rules/constants
- Game Start / Local Setup / Match Summary flow
- tutorial sequence
- board/camera behavior
- HUD/actions
- input/turn state machine
- animation/audio feedback
- pause/help/settings behavior
- exact match end condition
- Final Results/ranking/tiebreakers
- rematch/reset behavior
- stored stats
- AI→3D asset requirements
- explicit out-of-scope features
- acceptance tests

## Multi-device status

Deferred.

Current code should not contain speculative room/network UX simply because future product direction may support it.

When multi-device work begins, it requires separate locked docs for:
- Create/Join Room UX
- network transport
- authoritative host/server model
- action/revision protocol
- reconnect/host loss
- failure states
- privacy/security

## World status

Explorable CozyUni world is deferred.

Existing building/transport/nature/food/sports/infrastructure assets are reserved for a later real life-sim phase.

Do not build a decorative game-select hub and call it the world. When world development restarts, it requires a full Animal-Crossing-like life-sim GDD.
