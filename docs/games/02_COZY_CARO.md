# G2 — Cozy Caro — Full Game Design v1.0

Status: **DESIGN LOCK — second production game**

Shared rules/UI: `00_SHARED_GAME_EXPERIENCE_LOCK.md`

## 0. No-invention rule

Implement this game exactly as written. Regional Caro/Gomoku rules must not be guessed. The two v1 presets below are the only supported rule sets.

## 1. Product role

Cozy Caro validates the reusable Grid Strategy Engine with almost no bespoke 3D art.

The module contains two clearly separated presets:
1. **Tic-Tac-Toe** — 3×3, very fast family mode
2. **Five-in-a-Row** — 15×15, deeper Caro/Gomoku-style duel

The two presets share board input, turn handling, result presentation and Room Mode.

## 2. Players / modes

- Exactly **2 players**
- One Device: supported
- Room Mode: supported
- Bots: not implemented in v1
- Public matchmaking: not implemented

## 3. Start Game screen

Description:
`Place your Cozy tokens, build a line, and outsmart your opponent.`

After `Play`, the normal Mode Select appears.

After device mode, setup must include **Game Type**:
- `Tic-Tac-Toe 3×3`
- `Five-in-a-Row 15×15`

Default selection: `Tic-Tac-Toe 3×3`.

No additional rule toggles in v1.

## 4. Shared token assignment

Player sides are not named X/O.

Default visual sides:
- Side A: **Berry** marker / warm coral accent
- Side B: **Leaf** marker / sage-green accent

Player avatars remain visible in HUD.

Side assignment for first match is random.

Rematch swaps sides.

Critical token identity uses both icon shape and color.

## 5. Preset A — Tic-Tac-Toe 3×3

### 5.1 Board

- 3 columns × 3 rows
- all cells empty at round start

### 5.2 Turn

- Side A moves first in Round 1
- starting side alternates each subsequent round
- players alternate placing one token into one empty cell
- placement commits immediately on tap
- occupied cell tap is invalid and does nothing except invalid feedback

### 5.3 Round win

A player wins the round immediately when they occupy all 3 cells of any:
- row
- column
- diagonal

### 5.4 Round draw

If all 9 cells are occupied and no win line exists, the round is a draw.

### 5.5 Match length

A Tic-Tac-Toe match contains **exactly 3 rounds**.

Scoring:
- round win = 1.0 point
- round draw = 0.5 point to each player

After Round 3:
- higher score wins match
- equal score = match draw

There is no sudden death in v1.

## 6. Preset B — Five-in-a-Row 15×15

This is a deliberately simple **Freestyle Five** rule set to avoid regional ambiguity.

### 6.1 Board

- 15 columns × 15 rows
- all cells empty at match start

### 6.2 Turn

- randomly assigned Side A moves first
- players alternate placing exactly one token on one empty cell

### 6.3 Win rule

A player wins immediately when their newest placement creates **5 or more contiguous own tokens** in any one direction:
- horizontal
- vertical
- diagonal down-right
- diagonal up-right

Overlines of 6+ count as a win.

Blocked/open endpoints do not change validity.

There are:
- no forbidden opening moves
- no capture mechanics
- no Renju restrictions
- no exact-five requirement

### 6.4 Draw

If all 225 cells are occupied without a winning line, the match is a draw.

### 6.5 Match length

Five-in-a-Row is **one board per match** in v1.

Rematch starts a new board with sides swapped.

## 7. Caro placement confirmation flow

Tic-Tac-Toe commits on one tap.

Five-in-a-Row uses confirmation to prevent mis-taps:
1. Tap an empty cell.
2. Show a semi-transparent ghost token at that cell.
3. Bottom-center button changes to `PLACE`.
4. Tapping a different empty cell moves the ghost selection.
5. Tapping `PLACE` commits the selected cell.
6. Tapping the selected cell a second time also commits.

No placement is authoritative before commit.

## 8. Board coordinates

Internal coordinates:
- column `x = 0..N-1`, left to right
- row `y = 0..N-1`, top to bottom

Win detection must use integer coordinate state only, never visual transforms.

## 9. Turn state machine

Tic-Tac-Toe:

```text
TURN_START
 -> AWAITING_CELL_SELECTION
 -> PLACE_RESOLVE
 -> CHECK_WIN_DRAW
 -> if round over: ROUND_END
 -> else TURN_END
```

Five-in-a-Row:

```text
TURN_START
 -> AWAITING_CELL_SELECTION
 -> AWAITING_CONFIRMATION
 -> PLACE_RESOLVE
 -> CHECK_WIN_DRAW
 -> if match over: MATCH_END
 -> else TURN_END
```

## 10. Tutorial — Tic-Tac-Toe

Shown if the first chosen preset is Tic-Tac-Toe.

### Step 1
Text: `Take turns placing one token on an empty square.`
Required action: place Berry in highlighted center cell.

### Step 2
Script places Leaf elsewhere.
Text: `Make a line of three: across, down, or diagonal.`
Required action: place Berry in highlighted cell.

### Step 3
Script creates a near-win.
Text: `Complete the line before your opponent does.`
Required action: place winning Berry.

### Step 4
Show highlighted win line.
Text: `The match lasts three rounds. Most round points wins.`
Button: `Start Match`.

Target: under 30 seconds.

## 11. Tutorial — Five-in-a-Row

### Step 1
Text: `Place tokens on the 15×15 board.`
Required action: select highlighted cell.

### Step 2
Text: `Press PLACE to confirm your move.`
Required action: Place.

### Step 3
Script shows four Berry tokens in a line.
Text: `Five or more connected tokens in any direction wins.`
Required action: place fifth token.

### Step 4
Text: `Horizontal, vertical, and both diagonals count.`
Button: `Start Match`.

Target: under 35 seconds.

## 12. Camera / board presentation

### Tic-Tac-Toe
- fixed top-down / very mild perspective
- board occupies the central gameplay area
- no zoom/pan

### Five-in-a-Row
- board must fit fully on a landscape tablet by default
- pinch zoom supported from 1.0× to 1.8×
- pan only when zoom >1.0×
- double tap resets zoom to 1.0×
- placement hit testing uses board coordinates, not screen-space approximation

No camera rotation.

## 13. HUD

### Top-center
- player turn chip: `<Avatar> <Name> — Your Turn`
- Tic-Tac-Toe additionally displays `Round X / 3`

### Bottom-left
Two compact player cards with:
- avatar
- side icon
- Tic-Tac-Toe series score when relevant

### Bottom-center
- Tic-Tac-Toe: no persistent primary button
- Five-in-a-Row: `PLACE` only while a ghost cell is selected

### Bottom-right
- last-move coordinate indicator is not shown as text
- use a visual ring on board instead

### Top-right
Settings/Pause.

## 14. Board feedback

- Last committed move: thin gold ring for current turn only
- Winning line: animated soft gold connection line through the winning tokens
- Draw: all tokens desaturate slightly for 0.6 s before result panel
- Invalid occupied-cell tap: muted thud + 0.15 s cell shake

## 15. Round transition — Tic-Tac-Toe

After a round ends:
- show `Round Win`, `Round Draw`, or equivalent for 1.2 s
- update score
- clear board
- next round begins after 0.8 s
- starting side alternates

Do not open a full Final Results screen between rounds.

## 16. Pause / settings

No game-specific rule settings during match.

Help pages must show separate sections for:
- Tic-Tac-Toe
- Five-in-a-Row

Five-in-a-Row Help must explicitly state:
`Five or more connected tokens wins. Overlines count. Blocked ends do not matter.`

## 17. Room disconnect behavior

This is a 2-player game.

If a player exceeds the shared 60-second reconnect grace:
- disconnected player forfeits
- connected opponent wins match
- Tic-Tac-Toe series score is ignored for result winner because forfeit overrides it

Result reason shown: `Opponent disconnected`.

## 18. Final Results

### Tic-Tac-Toe
Show:
- player names/avatars
- final series points, e.g. `2.0 – 1.0`
- `Winner` or `Draw`
- round breakdown icons: W / L / D

### Five-in-a-Row
Show:
- Winner / Loser or Draw
- moves played
- winning line length if win occurred

No third-place/ranking concept because exactly two players.

## 19. Stats stored

Generic stats plus:
- Tic-Tac-Toe rounds won/drawn/lost
- Five-in-a-Row total moves played

Do not store ELO/MMR.

## 20. AI→3D assets

Essential art can remain extremely small.

Preferred implementation:
- token discs generated as simple game meshes
- Berry/Leaf identity applied through material/icon

If AI→3D is used, maximum bespoke assets:
1. Berry Token
2. Leaf Token
3. shared Winner Trophy

Do not render boards or cell sets.

## 21. Explicitly out of scope v1

- bots
- public matchmaking
- undo
- hints
- move analysis
- forbidden-move rules
- exact-five Caro
- blocked-end Caro
- Renju
- custom board sizes
- timers
- ranked ladder
- spectators

## 22. Acceptance tests

Tic-Tac-Toe:
- detect all 8 possible winning lines
- never allow occupied-cell placement
- exactly 3 rounds
- scoring 1/0.5 deterministic
- side alternation correct

Five-in-a-Row:
- horizontal/vertical/both diagonal detection correct
- lines of 5, 6, 7+ all win
- no false win across gaps
- full-board draw correct
- ghost selection never commits before confirmation
- zoom/pan never changes selected board coordinate

UX:
- both presets complete Start -> setup -> tutorial -> match -> Final Results
- rematch swaps sides
- Room reconnect/forfeit deterministic
