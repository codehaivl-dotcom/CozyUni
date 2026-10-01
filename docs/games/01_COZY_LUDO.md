# G1 — Cozy Ludo — Full Game Design v1.0

Status: **DESIGN LOCK — first production game**

Shared rules/UI: `00_SHARED_GAME_EXPERIENCE_LOCK.md`

## 0. No-invention rule

Implement this game exactly as written. If a behavior is not defined here or in the shared lock, it is not part of v1.

## 1. Product role

Cozy Ludo is the first production game. It establishes:
- the shared app game flow
- One Device play
- Room Mode
- shared dice/turn systems
- shared result/rematch flow
- the Path Board Engine

Target fantasy: four cute CozyUni residents race home around a compact village board.

Target audience: family/friends, including children who can understand a simple turn-based board game.

## 2. Players / supported modes

- Players: **2–4 humans**
- One Device: supported
- Create/Join Room: supported
- Public matchmaking: not implemented
- Bots: not implemented in v1

## 3. Session target

- Expected: **8–12 minutes**
- Hard design target: most 4-player matches under **15 minutes** at Normal animation speed

## 4. Canonical v1 ruleset

There is exactly one v1 ruleset: **Cozy Quick**.

### 4.1 Pieces

- Each player controls **3 pieces**.
- At match start, **1 piece starts on that player's Start Safe cell**.
- The remaining **2 pieces begin in the Yard**.

### 4.2 Board topology

- Shared outer loop: **52 cells**.
- Each player has a private Home Lane: **5 cells**.
- Final Home position exists after Home Lane cell 5.
- Start indices on the 52-cell loop:
  - Player 1: index 0
  - Player 2: index 13
  - Player 3: index 26
  - Player 4: index 39
- A piece must complete one full outer-loop lap before entering its own Home Lane.

### 4.3 Safe cells

Safe cells are:
- all four Start cells: 0, 13, 26, 39
- four Star Safe cells: 8, 21, 34, 47

Rules:
- pieces on safe cells cannot be captured
- enemy pieces may coexist on a safe cell
- a player may not have two of their own pieces on the same cell

### 4.4 Dice

- One standard D6.
- Roll values: 1–6 uniformly.
- Dice result is authoritative and server/host-seeded in Room Mode.

### 4.5 Deploy from Yard

- A Yard piece may enter the player's Start Safe cell **only on a roll of 6**.
- Deploying consumes the roll.
- If the player's Start Safe cell already contains one of their own pieces, that Yard piece cannot deploy.

### 4.6 Moving on the outer loop

- A selected active piece moves exactly the rolled number of path steps unless finishing rules apply.
- A move is illegal if its final destination contains another piece owned by the same player.
- Intermediate occupied cells do not block movement.

### 4.7 Capture

On a non-safe outer-loop cell:
- landing exactly on one enemy piece captures it
- captured piece returns to its Yard
- capture does **not** grant a bonus roll

If the destination is a safe cell, no capture occurs.

### 4.8 Home Lane entry

After completing a full outer-loop lap, the piece continues into its owner's 5-cell Home Lane.

The Home Lane is private: enemy pieces never enter it.

### 4.9 Finish behavior

Exact roll is **not required**.

If a roll would move a piece beyond the final Home position:
- clamp movement to the final Home position
- mark that piece `HOME`

This rule is intentional to avoid late-game dead turns.

### 4.10 Roll of 6 / bonus roll

After a **successful legal move** using a roll of 6:
- the same player receives exactly **one bonus roll**

The bonus roll cannot generate another bonus roll, even if it is also 6.

Therefore one player's turn contains at most two rolls.

If the original roll of 6 has no legal move, no bonus roll is granted.

### 4.11 No legal move

If no piece has a legal move for the rolled value:
- show `No legal move` toast for 0.8 s
- turn ends automatically

### 4.12 Win condition

The first player with all **3 pieces HOME** wins immediately.

The match ends at that moment. Remaining players do not continue playing.

## 5. Final ranking

Rank 1 is always the winner.

All remaining players are sorted by:
1. `HomeCount` descending
2. `TotalProgress` descending
3. `CapturesMade` descending
4. `PiecesInYard` ascending

Progress value per piece:
- Yard = 0
- active outer-loop progress = 1–52 relative to that piece's personal start
- Home Lane cells = 53–57
- Home = 58

`TotalProgress` is the sum of all three piece progress values.

If players remain tied after all four rules, display a shared rank.

Final Results key stat: `Pieces Home`.

## 6. Turn state machine

Each normal turn:

```text
TURN_START
 -> AWAITING_ROLL
 -> DICE_RESOLVE
 -> COMPUTE_LEGAL_PIECES
 -> if none: NO_MOVE -> TURN_END
 -> else AWAITING_PIECE_SELECTION
 -> MOVE_RESOLVE
 -> LANDING_RESOLVE
 -> if original roll == 6 and bonus unused: BONUS_ROLL
 -> else TURN_END
```

During `MOVE_RESOLVE` and `LANDING_RESOLVE`, piece input is locked.

## 7. Start Game / setup

Game Start Screen description:
`Race your three CozyUni friends around the village and bring them home first.`

### One Device setup

- Player count buttons: 2 / 3 / 4
- Default: 4
- Each slot selects unique avatar
- Slot colors:
  - P1 Red
  - P2 Blue
  - P3 Green
  - P4 Yellow

These colors are fixed in v1 and reinforced with unique slot icons/shapes for accessibility.

### Room setup

Same rules/player count. Host chooses 2–4 slots before Start.

## 8. Match Summary

Show:
- `3 pieces each`
- `Roll 6 to bring a new piece out`
- `Safe stars cannot be captured`
- `Bring all 3 pieces home to win`
- Expected time: `8–12 min`

No rule toggles in v1.

## 9. Tutorial — exact sequence

Tutorial uses two players: Rabbit Red and Bear Blue.

### Step 1 — Roll
Text: `Tap Roll to roll the dice.`
Required action: tap Roll.
Forced result: 4.

### Step 2 — Move
Text: `Glowing pieces can move. Tap the highlighted Rabbit.`
Required action: tap the only legal Rabbit.
Show 4 hop markers.

### Step 3 — Safe space
Script moves piece onto a Star Safe cell.
Text: `Star spaces are safe. Pieces here cannot be captured.`
Button: Continue.

### Step 4 — Capture
Forced state places Bear 3 cells ahead. Forced roll: 3.
Text: `Land on a rival outside a safe space to send them back to the Yard.`
Required action: move Rabbit and trigger capture.

### Step 5 — Bring out a piece
Forced roll: 6.
Text: `Roll a 6 to bring a piece out of the Yard.`
Required action: select Yard piece.

### Step 6 — Finish
Script jumps to Home Lane example.
Text: `Finish all three pieces first to win.`
Button: `Start Match`.

Tutorial length target: under 60 seconds when followed normally.

## 10. Board visual structure

- Square board centered in landscape view.
- Outer loop visually divided into four player quadrants.
- Home Lanes use player color plus icon pattern.
- Safe cells show a gold star emblem.
- Start Safe cells show player icon plus color.
- Yard contains three circular piece sockets.
- Center contains the Cozy Pavilion / final-home presentation.

Decorative village props remain outside interaction cells.

No decorative prop may overlap a legal cell hitbox.

## 11. Camera

- Fixed mild-isometric/tabletop camera.
- No manual camera rotation in v1.
- During movement, camera may perform a maximum 5% framing ease only if the whole board remains visible.
- No cinematic camera cuts during normal turns.

## 12. HUD

### Top-center
`<Avatar> <Player Name> — Your Turn`

During another player's Room Mode turn:
`<Avatar> <Player Name> — Playing`

### Bottom-left
Compact current-player card:
- avatar
- name
- three mini piece-state dots: Yard / Active / Home

### Bottom-center
Primary button:
- `ROLL` while awaiting roll
- hidden after roll

After roll, the dice result remains visible above the board until movement completes.

### Bottom-right
Compact turn order strip with 2–4 avatar chips.

### Top-right
Settings/Pause.

No item bar, quest list, chat box, or permanent rule panel.

## 13. Piece selection feedback

After dice resolve:
- legal pieces receive soft outer glow and 5% idle lift
- illegal own pieces remain unchanged
- tapping illegal own piece plays muted invalid tick and no modal
- tapping a legal piece commits immediately; no confirmation dialog

## 14. Animation timing

Normal speed:
- dice roll: 0.9 s
- per-cell hop: 0.12 s, maximum visual travel time capped at 1.2 s
- capture reaction: 0.45 s
- Yard return: 0.45 s
- Home celebration: 0.5 s

Fast setting multiplies non-essential timings by 0.6.

Rules resolve before animation completes; input remains locked until animation completion.

## 15. Audio/VFX

- Roll: wooden dice tumble
- Each hop: very soft tick, do not play 12 loud footsteps
- Safe landing: small star sparkle
- Capture: playful pop, not aggressive hit
- Home: short chime
- Winner: shared victory sting + light confetti/flowers

## 16. Pause / settings

No Ludo-specific gameplay settings during a match.

Help page contains:
- Piece movement
- Roll 6 deployment
- Safe spaces
- Capture
- Home/finish
- Bonus roll rule

## 17. Room disconnect behavior

Use shared disconnect rules.

When a 3–4 player participant forfeits:
- remove all of their pieces from board/Yard/Home display
- they no longer block any destination
- final ranking places them below all connected players
- among multiple forfeiting players, earlier forfeit ranks lower than later forfeit

For a 2-player match, disconnect forfeit ends match immediately.

## 18. Final Results screen

Show ranked player cards.

Per player:
- rank
- avatar/name
- `Pieces Home: X/3`
- `Captures: N`

Winner card additionally shows trophy.

Buttons follow shared spec.

## 19. Stats stored

In addition to generic stats:
- total captures
- total pieces brought home

Do not store ranked rating/MMR.

## 20. Required AI→3D assets

Essential bespoke assets:
1. `ludo_dice` — one chunky Cozy D6
2. `ludo_finish_pavilion` — center/final hero prop
3. `ludo_shortcut_gate` — **not used by v1 rules; do not render for implementation yet**
4. `shared_winner_trophy`

Piece representation:
- first choice: simplified existing animal character pieces if readable
- fallback: simple medallion/pawn using avatar icon

Important: Shortcut/Lucky systems are removed from the v1 rules lock. Agents must not implement them because old concept docs mentioned them.

## 21. Explicitly out of scope v1

- shortcuts
- lucky gift tiles
- catch-up powerups
- four-piece classic mode
- exact-roll finish
- teams
- bots
- public matchmaking
- ranking/MMR
- custom board themes
- player-created rules

## 22. Acceptance tests

Rules:
- all 52-loop transitions correct for each player start index
- Home Lane entry correct for all four players
- safe cells never capture
- non-safe capture always returns target to Yard
- own-piece destination is illegal
- only 6 deploys Yard piece
- one bonus roll maximum
- overshoot finishes correctly
- ranking formula deterministic

UX:
- full Start Screen -> setup -> tutorial -> match -> Final Results flow works
- 2/3/4 player One Device complete
- 2/3/4 player Room complete
- HUD never obscures legal board cells
- no legal move auto-ends turn
- rematch rotates starting slot

No agent may mark G1 complete while any item above is unresolved.
