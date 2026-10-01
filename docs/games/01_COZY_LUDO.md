# G1 — Cozy Ludo — Full Game Design v1.1

Status: **DESIGN LOCK — first production game / local single-device**

Shared authority:
- `00_APP_SHELL_FLOW_LOCK.md`
- `00_SHARED_GAME_EXPERIENCE_LOCK.md`
- `00_SHARED_UI_LAYOUT_LOCK.md`

## 0. No-invention rule

Implement exactly as written. If behavior is not defined here or in shared locks, it is not part of current v1.

Current v1 is local multiplayer on one tablet. Multi-device/Room Mode is deferred.

## 1. Product role

Cozy Ludo is first production game. It establishes:
- Game Library -> Start -> Local Setup flow
- shared local multiplayer shell
- dice/turn systems
- results/rematch
- Path Board Engine

Fantasy: cute CozyUni residents race around a compact village board and bring all pieces home.

## 2. Players / modes

- 2–4 local human players
- One Device: required/current v1
- Multi-device/Room Mode: not implemented
- Bots: not implemented
- Public matchmaking: not implemented

## 3. Session target

- Expected 8–12 min
- Hard target: most 4P matches <15 min at Normal animation speed

## 4. Canonical ruleset: Cozy Quick

### Pieces
- 3 pieces/player
- 1 piece starts on player's Start Safe cell
- 2 pieces start in Yard

### Board topology
- 52-cell outer loop
- 5-cell private Home Lane/player
- final Home position after Home Lane cell 5
- Start indices: P1=0, P2=13, P3=26, P4=39
- piece must complete one outer-loop lap before Home Lane

### Safe cells
- Start cells: 0,13,26,39
- Star Safe: 8,21,34,47

Rules:
- safe pieces cannot be captured
- enemy pieces may coexist on safe cell
- same player may not stack two pieces on same cell

### Dice
- standard D6
- uniform 1–6
- result comes from local authoritative match RNG/seed

### Deploy from Yard
- Yard piece enters Start Safe only on roll 6
- deployment consumes roll
- if Start Safe occupied by own piece, that Yard piece cannot deploy

### Outer-loop movement
- selected piece moves exactly roll unless finish clamp applies
- destination with own piece = illegal
- occupied intermediate cells do not block

### Capture
On non-safe outer-loop cell:
- landing exactly on one enemy captures it
- captured piece returns Yard
- capture gives no bonus roll

Safe destination never captures.

### Home Lane
After full lap, piece continues into own private Home Lane.
Enemy pieces never enter.

### Finish
Exact roll not required.
If roll overshoots final Home:
- clamp to Home
- mark piece HOME

### Roll 6 bonus
After a successful legal move using an original roll of 6:
- same player gets exactly one bonus roll
- bonus roll cannot create another bonus roll
- max two rolls in one turn
- if original 6 has no legal move, no bonus

### No legal move
- show `No legal move` 0.8 s
- turn ends automatically

### Win
First player with all 3 pieces HOME wins immediately.
Remaining players do not continue.

## 5. Final ranking

Rank 1 = winner.
Others sort by:
1. HomeCount descending
2. TotalProgress descending
3. CapturesMade descending
4. PiecesInYard ascending

Piece progress:
- Yard 0
- outer loop 1–52 relative to personal start
- Home Lane 53–57
- Home 58

TotalProgress = sum of three pieces.
If still tied: shared rank.

Results key stat: `Pieces Home`.

## 6. Turn state machine

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

Input locked during movement/landing resolve.

## 7. Start Game / Local Setup

Start Screen description:
`Race your three CozyUni friends around the village and bring them home first.`

PLAY -> Local Player Setup.

Setup:
- player count 2 / 3 / 4
- default 4
- unique avatar per slot
- fixed colors: P1 Red, P2 Blue, P3 Green, P4 Yellow
- identity reinforced with avatar/icon, not color alone

No rule toggles.

## 8. Match Summary

Show:
- `3 pieces each`
- `Roll 6 to bring a new piece out`
- `Safe stars cannot be captured`
- `Bring all 3 pieces home to win`
- `A 6 can give one bonus roll`
- Expected `8–12 min`

## 9. Tutorial

Rabbit Red vs Bear Blue scripted sandbox.

1. `Tap Roll to roll the dice.`
   - forced 4
2. `Glowing pieces can move. Tap the highlighted Rabbit.`
   - show 4 hop markers
3. move onto Star Safe
   - `Star spaces are safe. Pieces here cannot be captured.`
4. scripted Bear 3 ahead, forced roll 3
   - `Land on a rival outside a safe space to send them back to the Yard.`
   - capture
5. forced roll 6
   - `Roll a 6 to bring a piece out of the Yard.`
   - deploy
6. show Home Lane
   - `Finish all three pieces first to win.`
   - `Start Match`

Target <60 s.

## 10. Board visual structure

- square centered board
- outer loop divided visually into four quadrants
- Home Lanes use player color + icon pattern
- Safe cells show gold star emblem
- Start cells show player icon + color
- Yard has three piece sockets
- center contains Cozy Pavilion/final-home presentation
- decor remains outside interaction cells

## 11. Camera

- fixed mild-isometric/tabletop
- no manual rotation
- max 5% framing ease during movement only if whole board remains visible
- no normal-turn cinematic cuts

## 12. HUD

Top-center:
`<Avatar> <Player Name> — Your Turn`

Bottom-left current-player card:
- avatar/name
- 3 mini piece-state dots: Yard / Active / Home

Bottom-center:
- `ROLL` while awaiting roll
- hidden after roll
- die result remains visible until move completes

Bottom-right:
- compact turn-order avatar strip

Top-right:
- Pause/Settings

No item bar, quest list, chat or rule rail.

## 13. Piece selection feedback

After dice:
- legal pieces soft glow + 5% lift
- illegal own pieces unchanged
- illegal tap = muted invalid tick only
- legal tap commits immediately
- no confirmation modal

## 14. Animation timing

Normal:
- dice 0.9 s
- hop 0.12 s/cell, visual travel cap 1.2 s
- capture reaction 0.45 s
- Yard return 0.45 s
- Home celebration 0.5 s

Fast = non-essential timing ×0.6.
Rules resolve before animation completes; input unlocks after animation.

## 15. Audio/VFX

- roll: wooden dice tumble
- hop: very soft tick
- safe: star sparkle
- capture: playful pop
- Home: short chime
- win: victory sting + light flowers/confetti

## 16. Pause / Help

No Ludo-specific settings during match.

Help sections:
- movement
- roll 6 deployment
- safe spaces
- capture
- home/finish
- bonus roll

## 17. Final Results

Per player:
- rank
- avatar/name
- `Pieces Home: X/3`
- `Captures: N`

Winner shows trophy.

Buttons:
- REMATCH
- CHANGE PLAYERS
- GAME LIBRARY

## 18. Stats

Generic stats plus:
- total captures
- total pieces brought home

No ranked rating/MMR.

## 19. AI→3D assets

Essential:
1. `ludo_dice`
2. `ludo_finish_pavilion`
3. `shared_winner_trophy`

Piece representation:
- first choice: simplified existing animal character pieces if readable
- fallback: simple medallion/pawn with avatar icon

Do **not** render shortcut gate for current v1. Shortcut/Lucky mechanics are not active.

## 20. Explicitly out of scope

- multi-device/Room Mode
- online matchmaking
- shortcuts
- lucky gift tiles
- catch-up powerups
- four-piece classic mode
- exact-roll finish
- teams
- bots
- ranking/MMR
- custom board themes
- player-created rules

## 21. Acceptance tests

Rules:
- all 52-loop transitions correct for each start index
- Home Lane entry correct for all players
- safe cells never capture
- non-safe capture returns target Yard
- own-piece destination illegal
- only 6 deploys Yard piece
- one bonus roll maximum
- overshoot finishes correctly
- ranking deterministic

UX:
- Game Library -> Start -> Local Setup -> Tutorial -> Match -> Results works
- 2/3/4 local matches complete
- HUD never obscures legal cells
- no-legal-move auto-ends turn
- rematch rotates starting slot
- no network/Room UI exists

Do not mark G1 complete while any item above is unresolved.
