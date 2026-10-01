# CozyUni — Game Mode Roadmap v0.4

Status: **GAME-FIRST / LOCAL SINGLE-DEVICE FIRST**

## 1. Production decision

CozyUni focuses on board games first.

Current five-game shortlist:
1. Cozy Ludo
2. Cozy Caro — Tic-Tac-Toe + Five-in-a-Row
3. Cozy Journey — Goose-family travel race
4. Cozy Chess
5. Cozy Tycoon — original CozyUni economy board game

Cozy Checkers is not active.

The persistent world and multi-device networking are both deferred.

## 2. Current multiplayer scope

Current v1 is **multiple local players sharing one tablet/screen**.

Supported player counts:
- Ludo: 2–4
- Caro: 2
- Journey: 2–4
- Chess: 2
- Tycoon: 2–4

Current UI does not expose:
- Create Room
- Join Room
- QR join
- public matchmaking
- separate-device play

Multi-device requires a later dedicated milestone and protocol design.

## 3. Exact app flow

Authority: `docs/games/00_APP_SHELL_FLOW_LOCK.md`.

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
```

Results:
- REMATCH
- CHANGE PLAYERS
- GAME LIBRARY

## 4. Reusable engine families

### Path Board Engine
Used by:
- Ludo
- Journey

Shared primitives:
- deterministic D6
- path/node representation
- token movement hooks
- turn lifecycle
- hit/highlight helpers

### Grid Strategy Engine
Used by:
- Caro
- Chess

Shared primitives:
- grid representation
- board renderer
- hit testing
- selection/highlight
- move/action history

### Economy Board Engine
Used by:
- Tycoon

Shared primitives:
- loop nodes
- ownership display
- coin transactions
- event-card presentation

Game rules remain mode-local.

## 5. AI→3D rule

Prefer:
- few unique objects/game
- chunky isolated silhouettes
- runtime recolors
- existing shared assets

Generate in engine/UI:
- board/grid/path
- text
- cards
- values
- highlights
- ownership colors

AI→3D for:
- pieces/tokens
- dice
- hero landmark
- trophy
- limited reusable decor

## 6. Production order

1. **Cozy Ludo** — complete local product flow and Path Board foundation
2. **Cozy Caro** — cheapest Grid Strategy validation
3. **Cozy Journey** — reuse Ludo infrastructure
4. **Cozy Chess** — deeper rules on stable grid framework
5. **Cozy Tycoon** — highest design/economy scope, last

Do not parallel-build all five gameplay systems.

## 7. Gate before next game

Current game must have:
- locked GDD
- end-to-end local flow
- deterministic rules tests
- tutorial working without developer explanation
- result/rematch stable
- bounded AI→3D kit
- playtest evidence that users want another match

## 8. Future multi-device milestone

Only after local product is stable.

Required before implementation:
- UX flow
- authority model
- network transport choice
- room lifecycle
- action/revision schema
- reconnect/host-loss rules
- QR payload
- security/privacy

Do not pre-build speculative networking.

## 9. World status

Explorable CozyUni world is not current production.

Existing world assets remain reserved for a future genuine life-sim phase. They may be reused now only as static board/diorama dressing when useful.
