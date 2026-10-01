# CozyUni — Shared UI Layout Lock v1.0

Status: **DESIGN LOCK — visual hierarchy / layout contract**

Companion to `00_SHARED_GAME_EXPERIENCE_LOCK.md`.

This document locks component placement/hierarchy so implementation agents do not redesign screens independently.

## 0. Baseline

Primary target: landscape tablet.

Use a normalized safe-content rectangle after OS safe-area insets:
- width = 100 units
- height = 100 units

Responsive implementations may scale/reflow within the stated ranges but must preserve hierarchy and component zones.

Minimum touch target: 56 dp.

## 1. Global visual language

- Style D CozyUni
- warm cream/parchment UI surfaces
- soft wood frame accents
- sage/teal secondary accents
- gold reserved for selection/winner/high-value feedback
- critical player identity always uses avatar/icon + color
- shadows soft and shallow
- no glassmorphism-heavy UI
- no neon HUD
- no dense MMO panels

## 2. Typography hierarchy

Use project font system, but preserve relative hierarchy:
- H1 game title: 1.00 scale
- H2 modal title: 0.65
- primary button: 0.42
- body: 0.34
- caption/stat: 0.27

Do not use more than three font weights on one screen.

## 3. Game Start Screen wireframe

Normalized layout:

```text
+------------------------------------------------------------------------------------------------+
| BACK      GAME TITLE / ONE-LINE DESCRIPTION                                          SETTINGS   |
|                                                                                                |
|   [                   3D GAME / BOARD PREVIEW                    ]   [      PLAY      ]          |
|   [                                                             ]   [ How to Play    ]          |
|   [                                                             ]   [ Settings       ]          |
|   [                                                             ]                          |
|   [                                                             ]                          |
|                                                                                                |
+------------------------------------------------------------------------------------------------+
```

Zones:
- top header: y 4–18
- preview: x 4–65, y 20–94
- action column: x 69–96, y 32–78

Buttons:
- Play: primary, min 220×64 dp equivalent
- How to Play: secondary
- Settings: secondary
- Back: top-left icon+text or icon depending shell convention

There must be no fifth top-level action.

## 4. Mode Select modal

Centered panel:
- width: 62–72% of safe width
- max height: 70%
- title: `How do you want to play?`

Three equal-height rows/cards:
1. One Device
2. Create Room
3. Join Room

Each row:
- icon left
- title
- one-line explanation
- chevron/right action

Close/Back in top-left of modal header.

## 5. Setup / Lobby layout

Landscape split:
- left/main: player slots, x 5–66
- right: match/rule summary, x 69–95

Bottom-right primary CTA:
- `Continue` for One Device setup
- `Start Match` for host Room lobby

Player slot card height: 68–84 dp.

Player slot content order:
`slot number -> avatar -> name -> side/color -> ready/connection`

Do not put game rules inside each player card.

## 6. Match Summary layout

Centered modal over blurred/static board preview.

Content order:
1. game title
2. players/turn order
3. win condition
4. active rules summary
5. expected duration
6. Start primary button
7. How to Play secondary

Maximum 6 rule bullets.

## 7. Gameplay safe zones

Persistent HUD consumes only:
- top zone: y 0–9
- bottom zone: y 84–100

Preferred board interaction zone:
- x 3–97
- y 9–84

Game-specific board may use more space when a HUD zone is empty, but no persistent panel may cover legal interaction cells.

## 8. Gameplay HUD wireframe

```text
+------------------------------------------------------------------------------------------------+
| [compact menu]                 [ CURRENT TURN / STATUS ]                         [ settings ]    |
|                                                                                                |
|                                                                                                |
|                                      BOARD                                                     |
|                                                                                                |
|                                                                                                |
| [current player / stats]             [ PRIMARY ACTION ]              [ secondary / turn order ]|
+------------------------------------------------------------------------------------------------+
```

### Top-center status chip
- max width 38% safe width
- height 48–56 dp
- one line preferred
- may temporarily expand to two lines only for end-state warning such as CHECK

### Bottom-left current-player card
- max width 28%
- height 64–80 dp
- one avatar
- max three compact stats

### Bottom-center primary action
- width 180–260 dp
- height 64–72 dp
- centered horizontally
- visually strongest interactive element outside board

### Bottom-right
- max width 28%
- no more than two simultaneous secondary actions

## 9. Dice presentation

For dice games:
- die appears above primary Roll button or in lower-center board edge
- visual die size: approximately 64–92 dp
- dice result stays readable until move resolution completes
- die never covers a legal piece/cell

## 10. Context bottom sheet

Used by Tycoon property/trade/develop decisions and similar explicit decisions.

- anchored to bottom
- width 70–92%
- maximum height 42% screen
- board remains visible behind it
- primary/secondary decisions always at lower-right/lower-center of sheet
- no full-screen takeover for ordinary property decisions

A sheet requiring scrolling is a design failure for v1 decision content.

## 11. Settings/Pause panel

Centered panel, width 60–72%.

Left column tabs only if necessary:
- Audio
- Accessibility
- General

For current v1, prefer one vertically grouped panel if all controls fit without scrolling beyond one tablet height.

Bottom actions:
- Resume primary
- Leave/Resign destructive style, visually separated

Restart Match appears only One Device.

## 12. Tutorial presentation

Tutorial never uses a giant paragraph modal.

Use:
- dim non-relevant regions to ~45% visual emphasis
- one instruction bubble max 2 lines
- animated pointer/ring on required control/cell
- progress dots at bottom or top: `1 / N`
- Skip Tutorial in upper corner, not primary

Required game action remains the primary way to advance.

## 13. Final Results screen

Full-screen results layer over frozen/soft-blurred board.

### 3–4 player layout
- title/winner: y 6–18
- rank cards: central x 12–88, y 22–70
- rank 1 visually 15–20% larger than others, not 2× larger
- key game stat on each card
- buttons y 78–94

Buttons order:
1. Rematch — primary center
2. Change Setup — secondary
3. Game Menu — tertiary

### 2 player layout
- left player card vs right player card
- winner emphasis or central Draw label
- end reason under result title where relevant
- series/score centered between cards when applicable

No store/ad/progression popup appears before Rematch controls.

## 14. Modal priority / z-order

Highest to lowest:
1. destructive confirmation / network failure
2. mandatory game decision (promotion, trade response)
3. pause/settings
4. tutorial instruction
5. gameplay context sheet
6. HUD
7. board
8. decorative environment

Never show two decision modals simultaneously.

## 15. Transient toast rules

- position: upper-middle below status chip or just above board center
- duration: 0.6–1.2 s
- max two lines
- never requires dismissal
- examples: `No legal move`, `+8 Coins`, `Safe Space`

## 16. Color/accessibility

Player colors baseline:
- P1 Red/coral
- P2 Blue
- P3 Green
- P4 Yellow/gold

Every player color must also have:
- avatar
- icon/shape
- text label when status is important

Do not encode ownership/legal state using hue alone.

## 17. Animation UI rule

- button press feedback <120 ms
- panel transition 180–250 ms
- no HUD element continuously bounces during decision state except subtle legal-piece pulse defined by game
- Reduced Motion replaces slide/scale with fade where possible

## 18. Forbidden UI patterns for current games

Do not add:
- permanent right quest rail
- oversized bottom inventory bar
- floating currency clutter outside Tycoon
- minimap
- global chat panel
- notification feed
- daily-task badge cluster
- animated ad/store banner
- three or more equally prominent primary buttons

## 19. Acceptance

UI implementation is accepted only if:
- a new user can identify the primary action in <2 seconds on every turn state
- board remains the largest visual element during gameplay
- all 56 dp touch-target rules pass
- no legal board hitbox is permanently obscured
- Result screen exposes Rematch without scrolling
- Tutorial instructions never require reading more than two lines at once
