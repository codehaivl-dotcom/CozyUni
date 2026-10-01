# CozyUni — Locked Game Design Set

Status: **GAME-FIRST / FULL GDD v1**

## Authority order

Implementation agents must read in this order:

1. [`00_SHARED_GAME_EXPERIENCE_LOCK.md`](./00_SHARED_GAME_EXPERIENCE_LOCK.md) — shared Start Game flow, multiplayer setup, HUD hierarchy, tutorial behavior, Settings, disconnect, Final Results, rematch, accessibility and no-invention rule.
2. The selected game's full GDD below.
3. `../GAME_MODE_ROADMAP.md` for production order only.
4. `../assets/00_RENDER_RULES_LOCKED.md` for AI→3D art production.

If lower-priority docs or old code/comments conflict with a locked GDD, the locked GDD wins.

If a required behavior is not specified in the shared lock or the selected game GDD, **do not invent it; raise a design question**.

## Current five games

1. [`01_COZY_LUDO.md`](./01_COZY_LUDO.md) — 2–4P race, first production game
2. [`02_COZY_CARO.md`](./02_COZY_CARO.md) — Tic-Tac-Toe 3×3 + Freestyle Five 15×15
3. [`03_COZY_JOURNEY.md`](./03_COZY_JOURNEY.md) — 36-space Goose-family travel race
4. [`04_COZY_CHESS.md`](./04_COZY_CHESS.md) — standard casual human-vs-human chess
5. [`05_COZY_TYCOON.md`](./05_COZY_TYCOON.md) — original 12-round CozyUni economy board

Cozy Checkers is not in the active shortlist.

## What a full GDD must define

Each current game spec now locks:
- product role
- supported player count/device modes
- exact canonical rules
- Start Game/setup flow
- match summary
- tutorial sequence
- board/camera behavior
- HUD contents and action priority
- turn/input state machine
- animation/audio feedback
- pause/help/settings behavior
- Room disconnect/forfeit behavior
- exact match end condition
- Final Results/ranking/tiebreakers
- stored stats
- AI→3D asset requirements
- explicit out-of-scope features
- acceptance tests

No production agent should need to invent gameplay rules to implement the current v1 designs.

## World status

The explorable CozyUni world is **deferred**.

Existing building, transport, nature, food, sports and infrastructure assets are reserved for a later real life-sim/world phase. The current games may reuse them as static board/diorama dressing only.

Do not build a decorative game-select hub and call it the CozyUni world. When world production restarts, it must be designed as a genuinely living Animal-Crossing-like life-sim layer under a separate full design lock.

## Production order

`Cozy Ludo -> Cozy Caro -> Cozy Journey -> Cozy Chess -> Cozy Tycoon`

Do not parallel-build all five gameplay systems.
