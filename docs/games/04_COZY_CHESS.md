# G4 — Cozy Chess — Full Game Design v1.0

Status: **DESIGN LOCK — fourth production game**

Shared rules/UI: `00_SHARED_GAME_EXPERIENCE_LOCK.md`

## 0. No-invention rule

Implement this ruleset exactly. Do not add chess variants, engines, analysis, hints, timers, puzzles, opening books, ratings, or matchmaking unless this document is revised.

## 1. Product role

Cozy Chess is the deep evergreen strategy game in the first CozyUni collection.

The v1 goal is not to create a competitive chess platform. It is a polished, correct, friendly human-vs-human chess game for shared-table and private-room play.

## 2. Players / modes

- Exactly **2 players**
- One Device supported
- Room Mode supported
- Bots not implemented
- Public matchmaking not implemented

## 3. Game Start screen

Description:
`Classic chess with a warm CozyUni table, clear pieces, and easy local or room play.`

No variant selector in v1.

## 4. Side assignment

First match:
- White/Black assigned uniformly at random
- White moves first

Rematch:
- sides swap
- White moves first

Player avatar identity remains separate from chess side.

## 5. Board

- Standard 8×8 board
- Files `a` through `h`
- Ranks `1` through `8`
- White starts on ranks 1–2
- Black starts on ranks 7–8
- White queen starts on d1; Black queen on d8
- a1 is a dark square

Coordinates are internal game state, not derived from rendered mesh positions.

## 6. Standard piece movement

### King
- one square in any direction
- may not move into check
- castling per Section 9

### Queen
- any number of unobstructed squares horizontally, vertically, diagonally

### Rook
- any number of unobstructed squares horizontally or vertically

### Bishop
- any number of unobstructed squares diagonally

### Knight
- L-shaped move: ±2/±1
- may jump over pieces

### Pawn
White:
- forward toward increasing rank
Black:
- forward toward decreasing rank

Pawn rules:
- one square forward if empty
- two squares from starting rank only if both intermediate and destination squares are empty
- capture one square diagonally forward
- no backward movement
- en passant per Section 10
- promotion per Section 11

## 7. Legal-move rule

A move is legal only if:
- piece movement pattern is valid
- path is clear where required
- destination is empty or occupied by opponent
- own king is not left in check after move

A player may not capture their own piece.

King capture is never represented as a legal move; game ends by checkmate before king capture.

## 8. Check / checkmate / stalemate

### Check
Player is in check when opponent attacks the king square.

HUD must show `CHECK` status immediately after move resolution.

### Checkmate
If current player is in check and has no legal move:
- current player loses
- opponent wins
- reason: `Checkmate`

### Stalemate
If current player is not in check and has no legal move:
- draw
- reason: `Stalemate`

## 9. Castling

Castling is legal only when all are true:
- king has never moved
- corresponding rook has never moved
- squares between king and rook are empty
- king is not currently in check
- king does not pass through an attacked square
- king does not end on an attacked square

Kingside:
- king e1->g1 / e8->g8
- rook h1->f1 / h8->f8

Queenside:
- king e1->c1 / e8->c8
- rook a1->d1 / a8->d8

Castling rights are stored explicitly in match state.

## 10. En passant

En passant is available only on the immediately following opponent turn after a pawn advances two squares from its starting rank and lands adjacent to an opposing pawn.

If not used immediately, the right expires.

The captured pawn is removed from the square it passed over.

En-passant legality must still respect self-check rules.

## 11. Promotion

When a pawn reaches the final rank:
- White reaches rank 8
- Black reaches rank 1

The moving player must choose exactly one:
- Queen
- Rook
- Bishop
- Knight

No auto-queen in v1.

Promotion choice UI appears before turn completion.

The promoted piece replaces the pawn on the promotion square.

## 12. Draw rules

V1 uses deterministic casual automatic draw rules.

A draw occurs automatically on:
1. stalemate
2. threefold repetition
3. 50-move rule
4. insufficient mating material as explicitly defined below
5. accepted draw offer

### 12.1 Threefold repetition

If the exact same position occurs for the third time, draw automatically.

Position identity includes:
- piece placement
- side to move
- castling rights
- en-passant availability

No player claim is required.

### 12.2 50-move rule

Maintain halfmove clock.

If **100 consecutive halfmoves** occur without:
- pawn move
- capture

the game draws automatically.

### 12.3 Insufficient material

Automatically draw only for these exact material states:
- King vs King
- King + Bishop vs King
- King + Knight vs King
- King + Bishop vs King + Bishop where both bishops are on same-colored squares

Do not attempt broader heuristic dead-position detection in v1.

### 12.4 Draw offer

A player may choose `Offer Draw` from Pause menu during their own turn before moving.

Opponent receives:
- `Accept`
- `Decline`

If accepted: match ends draw, reason `Draw agreed`.

If declined: current player's turn continues.

A player may make at most one draw offer every **10 completed own moves**.

This cooldown is tracked per player.

## 13. Resignation

`Resign` is available from Pause menu.

After confirmation:
- resigning player loses
- opponent wins
- reason: `Resignation`

## 14. No clock in v1

There is no chess clock or move timer in v1.

Do not implement time loss.

## 15. Turn state machine

```text
TURN_START
 -> CHECK_CURRENT_STATUS
 -> AWAITING_PIECE_SELECTION
 -> SHOW_LEGAL_MOVES
 -> AWAITING_DESTINATION
 -> MOVE_RESOLVE
 -> if promotion: AWAITING_PROMOTION
 -> UPDATE_POSITION_STATE
 -> CHECK_END_CONDITIONS
 -> TURN_END or MATCH_END
```

If selected piece is tapped again, selection clears.

Selecting another own piece transfers selection.

## 16. Input / legal-move visualization

Selected piece:
- soft gold base ring
- 4% lift

Legal empty destination:
- small centered dot

Legal capture destination:
- thin ring around opponent piece

Illegal cells:
- no marker

Tapping illegal cell while a piece is selected:
- no state change
- muted invalid tick only

Tapping legal destination commits immediately.

No confirmation dialog for normal moves.

## 17. Tutorial — exact scope

The first-run tutorial teaches **controls**, not the entire strategy of chess.

### Step 1 — Select
Text: `Tap one of your pieces to see where it can move.`
Required: select highlighted pawn.

### Step 2 — Move
Text: `Dots show legal empty squares.`
Required: move pawn one square.

### Step 3 — Capture
Scripted simple board.
Text: `A ring marks a piece you can capture.`
Required: capture highlighted opponent piece.

### Step 4 — Check
Scripted king/rook position.
Text: `If your king is in check, you must make a move that removes the check.`
Required: choose the only highlighted legal response.

### Step 5 — Special rules reference
Text: `Castling, en passant, promotion, and draw rules are explained in How to Play.`
Button: `Start Match`.

Target tutorial: under 60 seconds.

## 18. How to Play pages

Must contain separate concise cards for:
- Board setup
- King
- Queen
- Rook
- Bishop
- Knight
- Pawn
- Check and checkmate
- Castling
- En passant
- Promotion
- Draw rules

Each piece card contains a diagram generated in UI, not AI art.

## 19. One Device board orientation

Default:
- White at bottom
- Black at top
- board does **not** rotate automatically

Chess-specific presentation setting:
- `Rotate board each turn`: Off default / On

If On:
- rotate board 180° after turn-end animation
- HUD player labels remain screen-oriented and do not rotate

## 20. Room Mode orientation

Each device displays:
- local player's side at bottom
- opponent at top

Board coordinates remain canonical internally.

## 21. HUD

### Top player bar
Opponent:
- avatar/name
- side icon/color
- captured-material mini row optional only as icon list

### Center status chip
Possible values:
- `White to Move`
- `Black to Move`
- `CHECK`

`CHECK` replaces the normal status text and uses stronger gold/red accent without flashing.

### Bottom player bar
Local/current lower-side player:
- avatar/name
- side

One Device always shows both player bars.

### Bottom-center
No persistent primary action button during normal play.

Promotion creates temporary bottom-center choice tray.

### Top-right
Settings/Pause.

## 22. Promotion UI

When promotion is required:
- lock board input
- show four large piece choices: Queen, Rook, Bishop, Knight
- each uses current player's material/color
- choice commits immediately
- no Cancel button

## 23. Animation

Normal speed:
- normal move slide/lift: 0.22 s
- capture: 0.3 s
- castling: king move then rook, total 0.45 s
- promotion morph/replace: 0.45 s
- check emphasis: 0.3 s

Fast multiplier: 0.6.

No cinematic camera movement during moves.

## 24. Audio/VFX

- move: soft wooden tap
- capture: deeper soft tap
- check: short bell accent
- castle: two-piece wooden cadence
- promotion: bright chime
- checkmate: restrained victory sting

No combat-style impact effects.

## 25. Room disconnect

2-player shared rule applies.

After 60-second grace expiry:
- disconnected player forfeits
- opponent wins
- result reason `Opponent disconnected`

## 26. Final Results

Show:
- Winner / Loser, or Draw
- both avatars and sides
- end reason exactly one of:
  - Checkmate
  - Resignation
  - Opponent disconnected
  - Stalemate
  - Threefold repetition
  - 50-move rule
  - Insufficient material
  - Draw agreed
- total moves

Buttons follow shared spec.

Rematch swaps White/Black.

## 27. Stats stored

Generic stats plus:
- checkmates won
- draws
- total chess moves played

Do not store:
- ELO
- accuracy
- centipawn loss
- opening names

## 28. AI→3D asset kit

Exactly six essential piece archetypes:
1. King
2. Queen
3. Bishop
4. Knight
5. Rook
6. Pawn

Requirements:
- recognizable standard silhouette first
- Cozy animal/leaf motifs only as secondary detail
- common base diameter
- no thin fragile accessories
- White/Black are runtime materials, not duplicate meshes

Board is generated in engine.

Optional shared trophy is reused.

## 29. Explicitly out of scope v1

- bots/engine opponent
- move hints
- evaluation bar
- analysis board
- puzzles
- clocks
- Chess960
- custom positions
- PGN import/export
- online ranking
- spectators
- takebacks
- premoves

## 30. Acceptance tests

Rules:
- every piece move correct
- self-check rejection correct
- castling all legality conditions correct
- en passant create/use/expiry correct
- all four promotions correct
- check/checkmate/stalemate correct
- threefold key includes side/castling/en-passant
- 50-move reset on pawn move/capture
- listed insufficient-material states draw
- draw-offer cooldown correct

UX:
- board readable at tablet scale
- Room local side always bottom
- One Device rotation setting deterministic
- promotion cannot leave match in incomplete state
- Start -> setup -> tutorial -> full game -> Final Results complete
