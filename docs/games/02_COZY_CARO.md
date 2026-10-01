# G2 — Cozy Caro — Full Game Design v1.1

Status: **DESIGN LOCK — local single-device**

Shared authority:
- `00_APP_SHELL_FLOW_LOCK.md`
- `00_SHARED_GAME_EXPERIENCE_LOCK.md`
- `00_SHARED_UI_LAYOUT_LOCK.md`

## 0. No-invention rule

Implement exactly as written. Regional Caro/Gomoku rules must not be guessed. Only the two v1 presets below exist.

Current v1 is local two-player on one device. Multi-device/Room Mode is deferred and must not be exposed or implemented.

## 1. Product role

Cozy Caro validates the reusable Grid Strategy Engine with almost no bespoke 3D art.

The module contains two presets:
1. **Tic-Tac-Toe** — 3×3, very fast family mode
2. **Five-in-a-Row** — 15×15, deeper Caro/Gomoku-style duel

## 2. Players / modes

- Exactly **2 local human players**
- One Device: supported and required for current v1
- Multi-device/Room Mode: not implemented
- Bots: not implemented
- Public matchmaking: not implemented

## 3. Start Game / setup

Start Screen description:
`Place your Cozy tokens, build a line, and outsmart your opponent.`

Pressing `PLAY` goes directly to Local Player Setup.

Setup contains:
- exactly two player slots
- unique avatar per player
- local names
- Game Type selector:
  - `Tic-Tac-Toe 3×3`
  - `Five-in-a-Row 15×15`

Default: `Tic-Tac-Toe 3×3`.

No other rule toggles.

## 4. Token / side assignment

Sides are not named X/O.

Default visual sides:
- Side A: **Berry** / warm coral
- Side B: **Leaf** / sage green

First match side assignment is random from local authoritative seed.
Rematch swaps sides.

Identity always uses icon shape + color + avatar.

## 5. Tic-Tac-Toe 3×3

### Board
- 3×3
- empty at round start

### Turn
- Side A starts Round 1
- starting side alternates each round
- place one token on one empty cell
- placement commits immediately on tap
- occupied-cell tap is invalid only

### Round win
Win immediately with 3 own cells in any row, column or diagonal.

### Round draw
All 9 occupied without win.

### Match length
Exactly **3 rounds**.

Scoring:
- win = 1.0
- draw = 0.5 each

After Round 3:
- higher score wins
- equal score = match draw

No sudden death.

## 6. Five-in-a-Row 15×15

Canonical ruleset: **Freestyle Five**.

### Board
- 15×15
- empty at start

### Turn
- randomly assigned Side A starts
- players alternate one placement

### Win
Newest placement creates **5 or more contiguous own tokens** horizontally, vertically, or on either diagonal.

Overlines count.
Blocked/open endpoints do not affect validity.

Not used:
- forbidden openings
- captures
- Renju restrictions
- exact-five requirement

### Draw
All 225 cells filled without a winning line.

### Match length
One board per match.
Rematch starts empty board with sides swapped.

## 7. Five-in-a-Row placement confirmation

Tic-Tac-Toe commits on one tap.

Five-in-a-Row:
1. tap empty cell
2. show ghost token
3. bottom-center shows `PLACE`
4. tap another empty cell to move ghost
5. tap `PLACE` to commit
6. tapping selected cell again also commits

No authoritative placement before commit.

## 8. Board coordinates

- x = 0..N-1 left to right
- y = 0..N-1 top to bottom

Win detection uses integer coordinates only.

## 9. State machines

Tic-Tac-Toe:

```text
TURN_START
 -> AWAITING_CELL_SELECTION
 -> PLACE_RESOLVE
 -> CHECK_WIN_DRAW
 -> ROUND_END or TURN_END
```

Five-in-a-Row:

```text
TURN_START
 -> AWAITING_CELL_SELECTION
 -> AWAITING_CONFIRMATION
 -> PLACE_RESOLVE
 -> CHECK_WIN_DRAW
 -> MATCH_END or TURN_END
```

## 10. Tutorial — Tic-Tac-Toe

1. `Take turns placing one token on an empty square.`
   - place Berry in highlighted center
2. script places Leaf
   - `Make a line of three: across, down, or diagonal.`
   - place highlighted Berry
3. create near-win
   - `Complete the line before your opponent does.`
   - place winning Berry
4. highlight line
   - `The match lasts three rounds. Most round points wins.`
   - `Start Match`

Target <30 s.

## 11. Tutorial — Five-in-a-Row

1. `Place tokens on the 15×15 board.`
   - select highlighted cell
2. `Press PLACE to confirm your move.`
   - commit
3. show four Berry in line
   - `Five or more connected tokens in any direction wins.`
   - place fifth
4. `Horizontal, vertical, and both diagonals count.`
   - `Start Match`

Target <35 s.

## 12. Camera / board

### Tic-Tac-Toe
- fixed top-down / very mild perspective
- no zoom/pan

### Five-in-a-Row
- full board visible by default
- pinch zoom 1.0×–1.8×
- pan only when zoom >1.0×
- double tap resets to 1.0×
- no rotation

Hit testing always uses board coordinates.

## 13. HUD

Top-center:
- current local player avatar/name
- Tic-Tac-Toe also `Round X / 3`

Bottom-left:
- two player cards with avatar + side icon
- Tic-Tac-Toe score where relevant

Bottom-center:
- Tic-Tac-Toe: none
- Five-in-a-Row: `PLACE` only while ghost selected

Top-right:
- Pause/Settings

Last move shown by board ring, not text coordinate.

## 14. Feedback

- last committed move: thin gold ring
- winning line: soft gold connection line
- draw: tokens desaturate 0.6 s
- invalid occupied tap: muted thud + 0.15 s cell shake

## 15. Tic-Tac-Toe round transition

After round:
- show Round Win/Draw 1.2 s
- update score
- clear board
- wait 0.8 s
- next round begins
- starting side alternates

No full Results between rounds.

## 16. Pause / Help

No game-specific settings during match.

Help sections:
- Tic-Tac-Toe
- Five-in-a-Row

Five-in-a-Row help must state:
`Five or more connected tokens wins. Overlines count. Blocked ends do not matter.`

## 17. Final Results

### Tic-Tac-Toe
Show:
- avatars/names
- final series score
- Winner or Draw
- round W/L/D breakdown

### Five-in-a-Row
Show:
- Winner/Loser or Draw
- moves played
- winning line length on win

Buttons follow shared local Results:
- REMATCH
- CHANGE PLAYERS
- GAME LIBRARY

## 18. Stats

Generic stats plus:
- Tic-Tac-Toe rounds won/drawn/lost
- Five-in-a-Row total moves played

No ELO/MMR.

## 19. AI→3D assets

Preferred:
- simple generated token discs
- Berry/Leaf identity through material/icon

Maximum bespoke 3D:
1. Berry Token
2. Leaf Token
3. shared Winner Trophy

Do not render boards/cells.

## 20. Explicitly out of scope

- multi-device/Room Mode
- online matchmaking
- bots
- undo
- hints
- analysis
- exact-five/blocked-end/Renju variants
- custom board sizes
- timers
- ranked ladder
- spectators

## 21. Acceptance tests

Tic-Tac-Toe:
- all 8 winning lines
- occupied cell never accepted
- exactly 3 rounds
- scoring 1/0.5 correct
- starting side alternates

Five-in-a-Row:
- all four line directions
- 5/6/7+ contiguous all win
- gaps never count
- full-board draw correct
- ghost never commits before confirm
- zoom/pan does not alter coordinate selection

UX:
- Game Library -> Start -> Local Setup -> Tutorial -> Match -> Results complete
- rematch swaps sides
- no network/Room UI exists
