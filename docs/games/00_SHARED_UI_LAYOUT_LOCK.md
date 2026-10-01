# CozyUni — Shared UI Layout Lock v1.1

Status: **DESIGN LOCK — current single-device visual hierarchy**

Companion to:
- `00_APP_SHELL_FLOW_LOCK.md`
- `00_SHARED_GAME_EXPERIENCE_LOCK.md`

Primary target: landscape tablet.

Use normalized safe-content rectangle after OS safe-area insets:
- width = 100 units
- height = 100 units

Minimum touch target: 56 dp.

## 1. Visual language

- Style D CozyUni
- warm cream/parchment UI surfaces
- soft wood accents
- sage/teal secondary accents
- gold only for selection/winner/high-value feedback
- player identity always avatar/icon + color/side
- soft shallow shadows
- no neon HUD
- no dense MMO panels
- board/game preview remains visually dominant

## 2. Typography hierarchy

Relative scale:
- H1 game/app title: 1.00
- H2 modal title: 0.65
- primary button: 0.42
- body: 0.34
- caption/stat: 0.27

Maximum three font weights on one screen.

## 3. Game Library — app home

Exact current-v1 home screen.

```text
+------------------------------------------------------------------------------------------------+
| COZYUNI                                                                    [ SETTINGS ]         |
|                                                                                                |
|  Choose a Game                                                                                 |
|                                                                                                |
|   [      GAME CARD      ] [      GAME CARD      ] [      GAME CARD      ] --->                 |
|   [ large key art       ] [ large key art       ] [ large key art       ]                      |
|   [ title               ] [ title               ] [ title               ]                      |
|   [ players | time |tag ] [ players | time |tag ] [ players | time |tag ]                      |
|                                                                                                |
|                    swipe horizontally for additional available games                           |
+------------------------------------------------------------------------------------------------+
```

Header:
- y 3–14
- logo/title x 4–34
- Settings x 90–97

Section title:
- `Choose a Game`
- x 5–35, y 17–24

Game rail:
- y 26–92
- approximately 2.5–3 cards visible
- horizontal scroll only

Game card:
- aspect approximately 0.72–0.82 width:height
- art occupies upper 65–72%
- title below art
- metadata row below title
- entire card is one touch target

Metadata exactly:
- local player count
- expected time
- one category tag

Example:
`2–4 Players   •   8–12 min   •   Race`

No per-card Play button. Tap whole card -> Game Start Screen.

No current-v1 UI for:
- Create Room
- Join Room
- Online
- World
- Store
- Daily reward
- currencies
- events

## 4. Game Start Screen

```text
+------------------------------------------------------------------------------------------------+
| BACK       GAME TITLE / ONE-LINE DESCRIPTION                                      SETTINGS     |
|                                                                                                |
|   [                   3D GAME / BOARD PREVIEW                    ]   [      PLAY      ]          |
|   [                                                             ]   [ HOW TO PLAY    ]          |
|   [                                                             ]   [ SETTINGS       ]          |
|   [                                                             ]                             |
|   [                                                             ]                             |
|                                                                                                |
+------------------------------------------------------------------------------------------------+
```

Zones:
- top header y 4–18
- preview x 4–65, y 20–94
- action column x 69–96, y 32–78

Buttons:
- Play primary, min 220×64 dp equivalent
- How to Play secondary
- Settings secondary
- Back top-left

There is no Mode Select button/screen in current v1.

## 5. Local Player Setup

Landscape split:
- left/main player slots x 5–66
- right setup summary x 69–95

Bottom-right primary CTA:
- `CONTINUE`

Player slot height: 68–84 dp.

Player slot content order:
`slot number -> avatar -> name -> color/side`

If player count is selectable:
- selector appears at top of left panel
- large segmented buttons such as `2  3  4`

If game is fixed 2-player:
- no player-count control
- show two slots only

Right summary contains only:
- game title
- short objective
- current ruleset/preset name
- expected duration

Do not put full rules into each player card.

## 6. Match Summary

Centered modal over static/soft-blurred board preview.

Content order:
1. game title
2. player order/sides
3. win condition
4. active rules summary
5. expected duration
6. `START`
7. `HOW TO PLAY`
8. `BACK`

Maximum 6 rule bullets.

## 7. Gameplay safe zones

Persistent HUD uses only:
- top y 0–9
- bottom y 84–100

Preferred board interaction zone:
- x 3–97
- y 9–84

No persistent panel may cover legal cells/pieces.

## 8. Gameplay HUD

```text
+------------------------------------------------------------------------------------------------+
| [menu]                       [ CURRENT TURN / STATUS ]                         [ settings ]       |
|                                                                                                |
|                                      BOARD                                                     |
|                                                                                                |
|                                                                                                |
| [current player / stats]             [ PRIMARY ACTION ]              [ secondary / turn order ]|
+------------------------------------------------------------------------------------------------+
```

### Top-center status chip
- max width 38%
- height 48–56 dp
- one line preferred
- two lines only for critical state such as CHECK

### Bottom-left current-player card
- max width 28%
- height 64–80 dp
- one avatar
- max three compact stats

### Bottom-center primary action
- width 180–260 dp
- height 64–72 dp
- strongest interactive element outside board

### Bottom-right
- max width 28%
- maximum two secondary actions/info groups

## 9. Dice presentation

For dice games:
- die appears above primary Roll button or lower-center board edge
- visual size approximately 64–92 dp
- result remains readable until movement resolves
- die never covers legal cell/piece

## 10. Context decision sheet

Used only when game GDD requires a decision such as Tycoon buy/develop/trade.

- anchored bottom
- width 70–92%
- max height 42%
- board remains visible
- primary decision lower-center/right
- no scrolling for ordinary v1 decisions

## 11. Pause / Settings panel

Centered panel width 60–72%.

Current-v1 actions:
- Resume
- How to Play
- Settings
- Restart Match
- Leave Match

No network/room controls.

If settings fit one tablet height, use one vertically grouped panel rather than tabs.

## 12. Tutorial presentation

- dim irrelevant regions to ~45% visual emphasis
- one instruction bubble, max 2 lines
- pointer/ring on required control/cell
- progress indicator `1 / N`
- Skip Tutorial in upper corner
- required player action advances step where possible

No paragraph tutorial modal.

## 13. Final Results

Full-screen layer over frozen/soft-blurred board.

### 3–4 players
- result title y 6–18
- rank cards x 12–88, y 22–70
- rank 1 card 15–20% larger than others
- one key stat per player
- buttons y 78–94

### 2 players
- left player vs right player
- winner emphasis or central Draw label
- end reason where relevant

Buttons exactly:
1. `REMATCH` — primary center
2. `CHANGE PLAYERS` — secondary
3. `GAME LIBRARY` — tertiary

No progression/store/ad popup before these controls.

## 14. Modal priority / z-order

Highest to lowest:
1. destructive confirmation
2. mandatory game decision
3. pause/settings
4. tutorial instruction
5. gameplay context sheet
6. HUD
7. board
8. decorative environment

Never show two decision modals at once.

## 15. Toasts

- upper-middle below status chip or just above board center
- duration 0.6–1.2 s
- max two lines
- no dismissal

Examples:
- `No legal move`
- `+8 Coins`
- `Safe Space`

## 16. Player colors / accessibility

Baseline:
- P1 Red/coral
- P2 Blue
- P3 Green
- P4 Yellow/gold

Critical player identity must also use avatar/icon/shape/text.
Never use hue alone.

## 17. UI animation

- button press feedback <120 ms
- panel transition 180–250 ms
- no continuous bouncing except game-defined subtle legal-piece pulse
- Reduced Motion substitutes fade for slide/scale where possible

## 18. Forbidden UI patterns

Do not add:
- Mode Select / online mode screen
- Create Room / Join Room controls
- permanent quest rail
- oversized inventory bar
- minimap
- global chat
- notification feed
- daily-task badges
- animated store/ad banners
- more than three equally prominent action buttons

## 19. Acceptance

UI is accepted only if:
- user can see available games immediately after splash
- selecting a game requires one tap on its card
- PLAY leads directly to Local Player Setup
- primary action is identifiable in <2 seconds on every turn
- board remains largest visual element during match
- all touch targets meet 56 dp minimum
- no legal board hitbox is permanently obscured
- Results exposes Rematch without scrolling
- tutorial text never exceeds two lines per step
- no current-v1 screen exposes multi-device/network options
