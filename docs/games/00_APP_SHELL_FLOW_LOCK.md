# CozyUni — App Shell & Game Selection Flow Lock v1.0

Status: **DESIGN LOCK — current production scope**

This document is authoritative for what the player sees from app launch until a selected game begins.

## 0. Current release scope

Current v1 is **single-device local multiplayer only**.

Supported now:
- one tablet / one screen
- 2–4 local players depending on selected game
- players sit around the same device and take turns

Not implemented in current v1:
- Create Room
- Join Room
- QR join
- multi-device synchronization
- online matchmaking
- accounts/friends
- cloud room persistence

Those are future milestones. They must not appear as disabled buttons or placeholder menu items in the current UI.

## 1. First launch

There is no account creation and no mandatory profile wizard.

Flow:

```text
APP LAUNCH
 -> COZYUNI SPLASH
 -> GAME LIBRARY
```

Splash:
- CozyUni logo
- static or very light animation only
- no buttons
- no ad
- no login
- continue automatically when app initialization is complete

If initialization fails, show one retry panel. Do not invent an alternate offline/login flow.

## 2. Game Library — main home screen

Purpose: the player chooses which small board game to play.

This is the main app home screen for the current game-first phase.

### Header

Left:
- CozyUni logo/title

Right:
- `Settings` icon/button

No currency, world map, quests, inbox, shop, battle pass, event banner or social panel.

### Main game rail

Use a horizontal card rail/carousel.

At landscape tablet size:
- show approximately 2.5–3 cards at once
- first available game is initially focused
- swipe/drag horizontally to browse
- tapping a card selects it and opens that game's Game Start Screen

Each card shows exactly:
- game key art / board preview
- game title
- supported local player count, e.g. `2–4 Players`
- expected session label, e.g. `8–12 min`
- one short tag, e.g. `Race`, `Strategy`, `Journey`, `Chess`, `Tycoon`

Do not show long rules on the card.

### Current game order

1. Cozy Ludo
2. Cozy Caro
3. Cozy Journey
4. Cozy Chess
5. Cozy Tycoon

Only games actually included in the current build may be selectable.

A game not included in the build is hidden, not shown as a fake disabled card. `Coming Soon` cards require a separate product decision.

## 3. Selecting a game

Tap game card -> open that game's **Game Start Screen**.

Transition:
- 180–250 ms
- no cinematic loading sequence
- selected game art may expand into the preview area

## 4. Game Start Screen

Every game uses the same shell structure.

Left/main:
- large 3D board/game preview
- preview is decorative and non-interactive

Right/action column:
1. `PLAY` — primary
2. `HOW TO PLAY`
3. `SETTINGS`

Top-left:
- `Back` -> Game Library

Game title and one-sentence description appear above/near preview.

No fourth gameplay mode button.
No online/local mode selector.

## 5. Pressing PLAY

Current v1 flow is direct:

```text
PLAY
 -> LOCAL PLAYER SETUP
 -> MATCH SUMMARY
 -> TUTORIAL if required
 -> 3 / 2 / 1 / PLAY
 -> MATCH
 -> FINAL RESULTS
```

There is no Mode Select screen in current v1.

## 6. Local Player Setup

Use selected game's min/max player count from its GDD.

### Player count

Examples:
- Cozy Ludo: 2 / 3 / 4
- Cozy Caro: 2 only
- Cozy Chess: 2 only
- Cozy Journey: 2 / 3 / 4
- Cozy Tycoon: 2 / 3 / 4

Default:
- if game supports 4: default 4
- if game supports only 2: fixed 2 and do not show a meaningless count selector

### Player slots

Each active slot shows:
- slot number
- avatar
- local display name
- assigned player color/side where relevant

Default names:
- Player 1
- Player 2
- Player 3
- Player 4

Name max: 16 visible characters.

Avatar rules:
- use approved CozyUni cast
- duplicate avatar selection is not allowed in one match
- avatar is identity/presentation unless game GDD explicitly uses it as a piece

Bottom-right primary CTA:
- `CONTINUE`

Top-left:
- `Back`

## 7. Local turn ownership

Because all players share one screen:
- the current player is always shown clearly by avatar + name + color/side
- public-information games never hide the board between turns
- no `Pass Device` privacy screen is used in current five games
- only current player can execute a legal gameplay action, but the device cannot technically identify hands/users; turn ownership is social, as with a physical board game

## 8. Match Summary

Before tutorial/match, show one compact summary.

Display:
- game title
- players in starting order or side assignment
- exact active preset/ruleset
- one-sentence win condition
- expected duration
- maximum 6 rule bullets

Buttons:
- `START`
- `HOW TO PLAY`
- `BACK`

No match state exists until START is confirmed.

## 9. Tutorial routing

First local match of each game:
- show its scripted tutorial automatically

After tutorial completed or skipped:
- do not auto-show again
- `How to Play` can replay it

Tutorial is local and deterministic.

## 10. Match

The selected game's GDD owns:
- rules
- turn state
- board layout
- HUD content
- legal actions
- end conditions

Shared shell owns only:
- pause/settings entry
- tutorial/help access
- results transition
- rematch/change setup/navigation

## 11. Final Results

After match completion:
- freeze final board state
- play result celebration within shared timing limits
- open full-screen Final Results

Buttons are exactly:
1. `REMATCH` — primary
2. `CHANGE PLAYERS` — secondary
3. `GAME LIBRARY` — tertiary

### Rematch

- keeps same player count, names, avatars and rules
- applies game-specific starting-player/side rotation
- skips Player Setup
- skips tutorial
- proceeds through Match Summary only if the game GDD requires it; default current behavior: go directly to countdown and new match

### Change Players

Returns to Local Player Setup for the same game.

### Game Library

Returns to main Game Library.

## 12. Settings entry points

Settings may be opened from:
- Game Library
- Game Start Screen
- in-match Pause/Settings

Global settings are defined by `00_SHARED_GAME_EXPERIENCE_LOCK.md`.

No settings screen may expose multi-device/network options in current v1.

## 13. Back behavior

Game Library:
- OS/app-level exit behavior; no custom quit modal required on tablet unless platform requires it

Game Start Screen:
- Back -> Game Library

Local Player Setup:
- Back -> Game Start Screen

Match Summary:
- Back -> Local Player Setup

Tutorial before match:
- `Skip Tutorial` continues toward the match
- Back navigation is not used inside tutorial steps

Active Match:
- Back gesture/button must not silently leave; Pause/Leave confirmation owns this behavior

Final Results:
- navigation only through the three explicit result buttons

## 14. Navigation state machine

```text
BOOT
 -> GAME_LIBRARY
 -> GAME_START
 -> LOCAL_SETUP
 -> MATCH_SUMMARY
 -> TUTORIAL? 
 -> COUNTDOWN
 -> MATCH
 -> FINAL_RESULTS
      -> REMATCH -> COUNTDOWN -> MATCH
      -> CHANGE_PLAYERS -> LOCAL_SETUP
      -> GAME_LIBRARY -> GAME_LIBRARY
```

No other current-v1 navigation branch is valid.

## 15. Acceptance criteria

The shell design is implemented correctly only if:
- app launch reaches Game Library without login/account flow
- a child/adult can identify available games without opening a nested menu
- selecting a card always opens that game's Start Screen
- PLAY never opens an online/mode-selection screen
- local setup supports exactly the player counts defined by the game
- Start -> Setup -> Summary -> Tutorial -> Match -> Results works end to end
- Rematch requires at most one tap from Results
- Change Players returns to same game's setup
- Game Library returns to game selection
- no current screen exposes Create Room, Join Room, matchmaking or network state

## 16. Future multi-device rule

Multi-device play is a future product milestone.

When that milestone begins, it requires a new design/technical lock covering:
- Room creation/join UX
- authority model
- protocol/actions/revisions
- reconnect/host loss
- privacy/security
- failure states

Do not pre-build or expose those flows during the current single-device milestone.
