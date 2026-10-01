# G4 — Cozy Chess

Status: **evergreen strategy mode after Grid Strategy Engine is stable**

## 1. Product role

Cozy Chess gives CozyUni one deeper strategy game with almost no bespoke environment requirement.

The first version should be standard human-vs-human chess presented in CozyUni style. Do not turn the initial scope into a chess-engine research project.

## 2. Players / modes

- 2 players
- One Device / Table Mode
- Room Mode
- standard human-vs-human first
- optional clock presets later
- strong bot/analysis features are separate future work

## 3. Rules

Use standard chess rules:
- normal piece movement
- check/checkmate
- stalemate
- castling
- en passant
- promotion
- standard draw conditions required by the chosen implementation

Rules should be correct before visual polish.

## 4. Target sessions

Initial casual presets:
- **Relaxed** — no clock
- **Quick** — optional simple per-player timer later

Do not make timed chess mandatory for family/table play.

## 5. Core loop

1. Select own piece.
2. Highlight legal destinations.
3. Select destination.
4. Resolve move/capture/promotion.
5. Detect check/end state.
6. Switch turn.

## 6. CozyUni contribution

Chess itself does not need new gameplay twists to justify inclusion.

Value comes from:
- extremely readable cute 3D set
- CozyUni avatar/player identity around the board
- subtle capture/move VFX
- warm board/table presentation
- satisfying promotion/check/checkmate feedback
- fast local or room rematch

Avoid rule-changing powerups in the standard mode.

## 7. Board / camera

Board should be generated in engine.

Recommended:
- top-down or low isometric with optional camera flip/rotate
- square coordinates optionally hidden for casual mode, available when needed
- strong contrast between board cells and pieces
- legal-move indicators simple and non-intrusive
- selected piece clearly elevated/highlighted

One Device mode should offer:
- fixed neutral orientation, or
- optional board rotate after each turn

Test which is less annoying on a tablet between two people.

## 8. AI→3D asset kit

Only six unique chess archetypes are needed:
1. King
2. Queen
3. Bishop
4. Knight
5. Rook
6. Pawn

Two sides should use runtime materials/colors, not separate rendered meshes.

Optional shared assets:
- winner crown/trophy
- chess clock later
- simple decorative table/club prop later

Target: **6 essential bespoke 3D assets**.

Piece design requirements:
- silhouettes must remain recognizable as chess pieces
- cute animal theming is allowed but cannot destroy standard piece readability
- avoid tiny accessories and complex thin geometry
- pieces should share one coherent base footprint

## 9. UI

Minimal HUD:
- player names/avatars
- side/color
- turn indicator
- optional timer
- resign / draw / settings
- rematch after result

Promotion UI must be obvious and fast.

## 10. Engine scope

Grid Strategy Engine should provide:
- board state
- selection/highlight framework
- move submission
- history stack
- turn state
- result state

Chess-specific rules layer provides:
- move generation
- attack maps
- check legality
- special moves
- draw/checkmate detection

Do not hardwire Chess-only assumptions into the generic grid renderer where Caro can reuse it.

## 11. First playable acceptance

- all standard moves validated correctly
- illegal self-check moves rejected
- castling/en-passant/promotion correct
- check/checkmate/stalemate correct
- board remains readable on tablet
- One Device mode can complete a full match naturally
- Room Mode reconnect/state sync does not corrupt position

## 12. Main risks

- underestimating rule-edge cases because chess looks simple
- cute piece redesign makes piece types hard to recognize
- trying to build a competitive AI too early
- excessive camera animation slows serious players

The first release should prefer correctness, readability and polish over extra features.
