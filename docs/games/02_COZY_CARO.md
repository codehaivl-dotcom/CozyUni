# G2 — Cozy Caro

Status: **second prototype / lowest-cost grid game**

## 1. Product role

Cozy Caro is the cheapest way to validate the shared Grid Strategy Engine. It combines two closely related rule presets under one module:

- **Tic-Tac-Toe** — very fast 3×3 family mode
- **Caro / Five-in-a-Row** — larger grid, deeper duel

This is intentionally a lightweight game with near-zero bespoke environment cost.

## 2. Players / modes

- 2 players
- One Device / Table Mode
- Room Mode
- human-vs-human first
- optional bot later

## 3. Rule presets

### Quick 3×3
- 3×3 grid
- alternate placement
- first line of 3 wins
- short draw condition
- target session: 30 seconds–3 minutes

### Caro / Five-in-a-Row
Initial recommended test:
- 15×15 board
- alternate placement
- first valid line of 5 wins
- no capture mechanics

Regional Caro/Gomoku restrictions vary. The shipped rules must be explicitly defined in-app rather than assuming every player uses the same local convention.

Potential later presets:
- freestyle five-in-a-row
- exact-five
- blocked-end Caro variant

Do not launch with several confusing presets before one is tested.

## 4. Core loop

1. Select empty grid cell.
2. Place token.
3. Check horizontal/vertical/diagonal win lines.
4. Switch player.
5. End instantly on win/draw.

## 5. CozyUni visual direction

Avoid plain X/O if possible while preserving instant readability.

Possible token families:
- Rabbit paw / Panda bamboo
- flower / berry
- sun / moon
- two simple animal-face medallions

Tokens must be simple discs/markers suitable for AI→3D and must read clearly at small size.

The board itself is generated in engine.

## 6. Digital value

- instant win-line highlight
- last-move marker
- move history / undo only in casual private rules if allowed
- fast rematch
- optional board zoom/pan on larger Caro grid
- Room Mode with reaction/emote layer
- match series: best-of-3 / best-of-5

## 7. AI→3D asset kit

Required:
1. Player token A
2. Player token B
3. optional winner crown/trophy

Potentially even fewer if token geometry is generated procedurally and only icons/textures vary.

Target: **0–3 bespoke 3D assets**.

Do not render:
- the full 15×15 board
- every grid cell
- multiple physical board variants

## 8. UI / camera

Tic-Tac-Toe:
- board nearly fills screen
- very large touch targets
- minimal HUD

Caro:
- top-down or very mild perspective
- pan/zoom if the board is larger than one screen
- current-player indicator
- last-move indicator
- clear winning-line animation

One-device play must remain usable with the tablet lying flat between two players.

## 9. First playable acceptance

- no invalid double-placement
- win detection correct for all four line directions
- grid remains readable at target device sizes
- rematch starts in one tap
- players can complete a best-of-3 series without UI friction
- larger Caro mode does not become awkward to pan/select

## 10. Main risks

- game feels too plain if presentation is weak
- decorative board art hurts cell readability
- unclear distinction between Tic-Tac-Toe and Caro rules
- Caro match can become long on an oversized empty board

The solution is presentation, quick presets and series play — not extra gameplay systems.
