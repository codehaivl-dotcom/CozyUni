# CozyUni — Game Mode Roadmap v0.3

Status: **GAME-FIRST / CURRENT DIRECTION**

## 1. Production decision

CozyUni will focus on board games first. The persistent world is **deferred** until the games themselves are fun, polished and reusable systems are stable.

Current five-game shortlist:

1. **Cozy Ludo**
2. **Cozy Caro** — Tic-Tac-Toe + Five-in-a-Row/Caro family
3. **Cozy Journey** — Goose-family path race
4. **Cozy Chess**
5. **Cozy Tycoon** — original CozyUni property/economy board game

**Cozy Checkers is removed from the current shortlist.**

The product should not attempt to build all five at once. One game is implemented, tested and polished before the next game becomes production work.

Detailed specs live under `docs/games/`.

## 2. Shared multiplayer requirement

Every suitable game should support two presentation modes while sharing one authoritative rules engine.

### One Device / Table Mode
- 2–4 players share one tablet/device where the rules allow it.
- Turn-based public-information games should feel like a physical tabletop game.
- No account or second device should be required.

### Room Mode
- One player creates a room.
- Other players join by code / QR / invite.
- Each player uses a separate device.
- The room shares one authoritative match state.

Do not fork game logic for the two modes. Input and presentation may differ; rules must remain shared.

## 3. Reusable engine families

### Path Board Engine
Used by:
- Cozy Ludo
- Cozy Journey

Shared systems:
- turn order
- dice
- path nodes
- piece movement
- safe/special nodes
- jump/shortcut events
- finish conditions
- replay/rematch

### Grid Strategy Engine
Used by:
- Cozy Caro
- Cozy Chess

Shared systems:
- grid board
- cell selection
- legal action highlighting
- move placement/movement
- win-state detection
- turn switching
- move history
- replay/rematch

### Economy Board Engine
Used by:
- Cozy Tycoon

This is the highest-scope engine and should be built last.

## 4. Art / AI→3D production rule

CozyUni does not have a traditional 3D art team. Game design must respect the AI-render → image-to-3D pipeline.

Prefer:
- few unique 3D objects per game
- simple chunky silhouettes
- board/grid/path generated in engine
- runtime material/color variants
- existing shared characters and world props

Avoid:
- rendering a whole board as one monolithic AI asset
- unique 3D prop for every board tile
- large bespoke environments before gameplay is validated
- thin mechanical details and assets requiring manual sculpt cleanup

Engine/UI should generate:
- board grids and paths
- labels/text
- ownership color
- highlights
- cards and values
- rule markers

AI→3D should be reserved for:
- pieces/tokens
- dice
- hero landmarks
- trophies/reward objects
- a small number of reusable decorative props

## 5. Current production order

Recommended order:

1. **Cozy Ludo** — first complete prototype; tests Path Board Engine + family play.
2. **Cozy Caro** — cheapest second game; tests Grid Strategy Engine quickly.
3. **Cozy Journey** — reuses Path Board Engine and existing transport/world assets.
4. **Cozy Chess** — evergreen strategy mode after grid framework is stable.
5. **Cozy Tycoon** — only after the shared architecture and audience are proven.

This is a research/production order, not a promise that all five ship.

## 6. Research gate before implementation

Every game must answer:
- Can the goal be understood in roughly one minute?
- Is it enjoyable for family/friends at the same table?
- Is downtime acceptable?
- Does One Device mode feel natural?
- Does Room Mode add useful value?
- Is the first playable possible with a very small bespoke art kit?
- Can the required 3D assets be generated reliably by AI→3D?
- Does the digital version add feedback, convenience or social value over a paper board?
- After one match, do test players voluntarily want another?

If not, redesign before adding content.

## 7. IP rule

Use generic/public game mechanics as mechanical foundations, but create original CozyUni names, art, board layouts, wording, UI and presentation.

Do not copy branded board artwork, logos, distinctive commercial presentation or rulebook text.

## 8. World status

The CozyUni world is intentionally **not being built now**.

Existing buildings, transport, nature, props, food and infrastructure assets remain valuable and are reserved for a later real life-sim/world phase.

When world production resumes, it should aim for a genuinely living social/life-sim experience rather than a decorative game-selection lobby. See `docs/COZYUNI_WORLD_BIBLE.md`.
