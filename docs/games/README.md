# CozyUni — Five Game Specs

Status: **current GAME-FIRST design set**

The active shortlist contains five games only:

1. [Cozy Ludo](./01_COZY_LUDO.md)
2. [Cozy Caro](./02_COZY_CARO.md) — Tic-Tac-Toe + Five-in-a-Row
3. [Cozy Journey](./03_COZY_JOURNEY.md) — Goose-family path game
4. [Cozy Chess](./04_COZY_CHESS.md)
5. [Cozy Tycoon](./05_COZY_TYCOON.md)

Cozy Checkers is not in the current production shortlist.

## Shared product rules

- Build one game at a time.
- Familiar mechanics first; CozyUni adds presentation and light twists.
- Support One Device / Table Mode where natural.
- Support Room Mode through the same authoritative rules engine.
- Do not require the future CozyUni world to exist before a game can ship.
- Boards/grids/paths/text/cards should be generated in engine/UI whenever possible.
- AI→3D is reserved for small, simple, reusable hero asset kits.
- No large bespoke art batch before a playable proves the rules are fun.

## Shared production gates

Before full polish, every game must pass:

1. **Rules gate** — new player understands the objective quickly.
2. **Family gate** — enjoyable with mixed ages/skill levels where relevant.
3. **Session gate** — target duration is predictable enough for casual play.
4. **Input gate** — both device modes are comfortable.
5. **Art gate** — bespoke AI→3D assets are few and reliable.
6. **Replay gate** — testers voluntarily choose rematch.

## Current suggested order

`Cozy Ludo → Cozy Caro → Cozy Journey → Cozy Chess → Cozy Tycoon`

This order is intended to build reusable Path Board and Grid Strategy foundations before the higher-risk economy game.
