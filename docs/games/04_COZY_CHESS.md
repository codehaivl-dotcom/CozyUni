# G4 — Cozy Chess — Full Game Design v1.1

Status: **DESIGN LOCK — local single-device**

Shared authority:
- `00_APP_SHELL_FLOW_LOCK.md`
- `00_SHARED_GAME_EXPERIENCE_LOCK.md`
- `00_SHARED_UI_LAYOUT_LOCK.md`

## 0. No-invention rule

Implement exactly this ruleset. Do not add variants, engines, analysis, hints, timers, puzzles, opening books, ratings, matchmaking, or network play unless docs are revised.

Current v1 is local human-vs-human on one device. Multi-device/Room Mode is deferred.

## 1. Product role

Cozy Chess is the deeper evergreen strategy game in the first CozyUni collection.

V1 goal: polished, correct, friendly local two-player chess on one tablet.

## 2. Players / modes

- Exactly 2 local human players
- One Device: supported and required
- Multi-device/Room Mode: not implemented
- Bots: not implemented
- Public matchmaking: not implemented

## 3. Game Start screen

Description:
`Classic chess with a warm CozyUni table, clear pieces, and easy shared-screen play.`

PLAY -> Local Player Setup.
No variant selector.

## 4. Side assignment

First match:
- White/Black assigned uniformly at random from local authoritative seed
- White moves first

Rematch:
- sides swap
- White moves first

Avatar identity remains separate from chess side.

## 5. Board

- standard 8×8
- files a–h
- ranks 1–8
- White ranks 1–2
- Black ranks 7–8
- White queen d1, Black queen d8
- a1 dark

Coordinates are internal game state, never inferred from mesh transforms.

## 6. Piece movement

### King
- one square any direction
- may not move into check
- castling per Section 9

### Queen
- unobstructed horizontal/vertical/diagonal

### Rook
- unobstructed horizontal/vertical

### Bishop
- unobstructed diagonal

### Knight
- ±2/±1 L move
- may jump

### Pawn
White moves toward increasing rank; Black toward decreasing.

Rules:
- one forward if empty
- two from start rank only if intermediate/destination empty
- capture one diagonal forward
- no backward movement
- en passant Section 10
- promotion Section 11

## 7. Legal move

Legal only if:
- movement valid
- path clear where required
- destination empty or opponent
- own king not left in check

Cannot capture own piece.
King capture is never a legal represented move; checkmate ends game first.

## 8. Check / checkmate / stalemate

### Check
Opponent attacks king square.
HUD immediately shows `CHECK` after move resolution.

### Checkmate
If player in check has no legal move:
- loses
- opponent wins
- reason `Checkmate`

### Stalemate
If not in check and no legal move:
- draw
- reason `Stalemate`

## 9. Castling

Legal only when:
- king never moved
- corresponding rook never moved
- squares between empty
- king not currently in check
- king does not pass through attacked square
- king does not end on attacked square

Kingside:
- e1->g1 / e8->g8
- h1->f1 / h8->f8

Queenside:
- e1->c1 / e8->c8
- a1->d1 / a8->d8

Store castling rights explicitly.

## 10. En passant

Available only immediately after opponent pawn advances two from starting rank and lands adjacent.

If not used immediately, expires.
Captured pawn removed from passed-over square.
Move must still satisfy self-check legality.

## 11. Promotion

Pawn reaching final rank must choose exactly one:
- Queen
- Rook
- Bishop
- Knight

No auto-queen.
Promotion choice occurs before turn completion.

## 12. Draw rules

Automatic draw on:
1. stalemate
2. threefold repetition
3. 50-move rule
4. listed insufficient material
5. accepted draw offer

### Threefold
Third occurrence of exact position automatically draws.
Position identity includes:
- piece placement
- side to move
- castling rights
- en-passant availability

### 50-move
100 consecutive halfmoves without pawn move or capture -> draw.

### Insufficient material
Auto-draw only:
- King vs King
- King+Bishop vs King
- King+Knight vs King
- King+Bishop vs King+Bishop with bishops on same-colored squares

### Draw offer
Available from Pause on current player's own turn before moving.

Opponent receives local shared-screen modal:
- `ACCEPT DRAW`
- `DECLINE`

If accepted: draw reason `Draw agreed`.
If declined: current player's turn continues.

Each player may offer at most once every 10 completed own moves.

## 13. Resignation

Pause -> `Resign` / Leave Match confirmation.

After confirmation:
- resigning player loses
- opponent wins
- reason `Resignation`

## 14. No clock

No chess clock or move timer in current v1.

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

Tap selected piece again clears selection.
Selecting another own piece transfers selection.

## 16. Input / legal visualization

Selected piece:
- soft gold base ring
- 4% lift

Legal empty:
- small centered dot

Legal capture:
- thin ring around opponent piece

Illegal:
- no marker

Illegal tap:
- no state change
- muted invalid tick

Legal destination commits immediately.

## 17. Tutorial

Tutorial teaches controls, not strategy.

1. `Tap one of your pieces to see where it can move.`
   - select highlighted pawn
2. `Dots show legal empty squares.`
   - move pawn one square
3. scripted capture
   - `A ring marks a piece you can capture.`
   - capture
4. scripted check
   - `If your king is in check, you must make a move that removes the check.`
   - execute only highlighted legal response
5. `Castling, en passant, promotion, and draw rules are explained in How to Play.`
   - `Start Match`

Target <60 s.

## 18. How to Play

Separate concise cards for:
- board setup
- King
- Queen
- Rook
- Bishop
- Knight
- Pawn
- check/checkmate
- castling
- en passant
- promotion
- draw rules

Piece diagrams generated in UI, not AI art.

## 19. One Device board orientation

Default:
- White at bottom
- Black at top
- no automatic rotation

Chess presentation setting:
- `Rotate board each turn`: Off default / On

If On:
- rotate board 180° after turn-end animation
- HUD labels stay screen-oriented

This is the only current v1 orientation option.

## 20. HUD

Top player bar:
- top-side player avatar/name/side

Center status:
- `White to Move`
- `Black to Move`
- `CHECK`

Bottom player bar:
- bottom-side player avatar/name/side

Bottom-center:
- no normal persistent action button
- promotion tray appears when required

Top-right:
- Pause/Settings

Both players are always visible because this is shared-screen play.

## 21. Promotion UI

When required:
- lock board input
- show Queen/Rook/Bishop/Knight large choices
- current side material/color
- choice commits immediately
- no Cancel

## 22. Animation

Normal:
- move 0.22 s
- capture 0.3 s
- castling total 0.45 s
- promotion 0.45 s
- check emphasis 0.3 s

Fast multiplier 0.6.
No cinematic camera movement.

## 23. Audio/VFX

- move: soft wooden tap
- capture: deeper soft tap
- check: short bell
- castle: two-piece cadence
- promotion: bright chime
- checkmate: restrained victory sting

No combat-style impacts.

## 24. Final Results

Show:
- Winner/Loser or Draw
- both avatars/sides
- end reason exactly one of:
  - Checkmate
  - Resignation
  - Stalemate
  - Threefold repetition
  - 50-move rule
  - Insufficient material
  - Draw agreed
- total moves

Buttons:
- REMATCH
- CHANGE PLAYERS
- GAME LIBRARY

Rematch swaps White/Black.

## 25. Stats

Generic stats plus:
- checkmates won
- draws
- total chess moves played

Do not store ELO, accuracy, centipawn loss or openings.

## 26. AI→3D asset kit

Exactly six piece archetypes:
1. King
2. Queen
3. Bishop
4. Knight
5. Rook
6. Pawn

Requirements:
- standard recognizable silhouette first
- Cozy motifs secondary
- common base diameter
- no thin fragile ornaments
- two sides use runtime materials, not duplicate meshes

Board generated in engine.
Shared trophy reused.

## 27. Explicitly out of scope

- multi-device/Room Mode
- online matchmaking
- bots/engine opponent
- hints
- evaluation/analysis
- puzzles
- clocks
- Chess960
- custom positions
- PGN import/export
- ranking
- spectators
- takebacks
- premoves

## 28. Acceptance tests

Rules:
- every piece movement correct
- self-check rejection
- castling legality
- en passant create/use/expiry
- all promotions
- check/checkmate/stalemate
- threefold identity fields
- 50-move reset rules
- listed insufficient-material cases
- draw-offer cooldown

UX:
- Game Library -> Start -> Local Setup -> Tutorial -> full match -> Results complete
- board readable at tablet scale
- rotation setting deterministic
- promotion cannot leave incomplete state
- rematch swaps sides
- no network/Room UI exists
