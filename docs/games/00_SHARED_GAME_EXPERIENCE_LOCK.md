# CozyUni — Shared Game Experience Lock v1.0

Status: **DESIGN LOCK — authoritative for the five board games**

Applies to:
- G1 Cozy Ludo
- G2 Cozy Caro
- G3 Cozy Journey
- G4 Cozy Chess
- G5 Cozy Tycoon

## 0. Authority / no-invention rule

This document plus the individual game spec is the source of truth.

**Implementation agents must not invent behavior.**

Rules:
1. If a behavior is defined here or in the game spec, implement it exactly.
2. If a game spec overrides a shared rule, the game spec wins.
3. If a behavior is not defined, the default is **NOT IMPLEMENTED**.
4. Do not add new buttons, currencies, power-ups, game rules, menus, tutorials, animations, bots, timers, progression, rewards, online ranking, IAP, ads, or world navigation without an explicit design update.
5. Balance constants belong in data/config, but their initial values are the locked values in the specs. Agents may not silently tune them.
6. “Nice to have”, “industry standard”, or “obvious UX” is not permission to add scope.
7. Any ambiguity found during implementation must be raised as a design question instead of guessed.

## 1. Product state for this phase

The CozyUni explorable world is **not part of the current implementation scope**.

The app currently behaves as a polished family game collection. Existing world assets may be used as static/diorama board dressing, but the player does not walk around a Life Hub in this phase.

Current production order:
1. Cozy Ludo
2. Cozy Caro
3. Cozy Journey
4. Cozy Chess
5. Cozy Tycoon

Only one game should be brought to production quality at a time.

## 2. Supported device orientation

- Primary orientation: **landscape**.
- All five games must be fully playable in landscape tablet layout.
- Portrait is not required for v1.
- UI must respect device safe areas.
- Minimum interactive touch target: **56 dp** on tablet.

## 3. End-to-end screen flow

Every game uses this flow unless its spec explicitly says otherwise.

```text
APP GAME LIST
  -> GAME START SCREEN
      -> PLAY
          -> MODE SELECT
              -> ONE DEVICE SETUP
                  -> PLAYER SETUP
                  -> MATCH SUMMARY
                  -> TUTORIAL (first time / requested)
                  -> COUNTDOWN
                  -> MATCH
                  -> FINAL RESULTS
              -> CREATE ROOM
                  -> ROOM LOBBY
                  -> MATCH SUMMARY
                  -> TUTORIAL (first time / requested)
                  -> COUNTDOWN
                  -> MATCH
                  -> FINAL RESULTS
              -> JOIN ROOM
                  -> ENTER CODE / SCAN QR
                  -> ROOM LOBBY
                  -> MATCH SUMMARY
                  -> TUTORIAL (first time / requested)
                  -> COUNTDOWN
                  -> MATCH
                  -> FINAL RESULTS
      -> HOW TO PLAY
      -> SETTINGS
      -> BACK
```

There is no hidden alternative flow.

## 4. Game Start Screen

Purpose: explain the game in one glance and provide the only four top-level actions.

Layout:
- Center/left: large 3D board/game preview.
- Top: game title.
- Under title: one-sentence description, maximum 90 characters in English equivalent.
- Primary CTA: **Play**.
- Secondary buttons: **How to Play**, **Settings**, **Back**.

Do not show:
- currencies
- daily missions
- battle pass
- ads
- store carousel
- world-map button
- matchmaking ranking

The board preview may animate slowly but must not contain gameplay that the user can interact with.

## 5. Mode Select

After `Play`, show exactly three choices:

1. **One Device** — players share one device.
2. **Create Room** — this device hosts a multi-device room.
3. **Join Room** — join an existing room.

Each choice has one short explanatory sentence.

No public matchmaking in v1.

## 6. One Device setup

### 6.1 Player count

Use the min/max player count from the individual game spec.

### 6.2 Player slots

Each player slot contains:
- Player display name: default `Player 1`, `Player 2`, etc.
- Avatar.
- Assigned game color/side where relevant.

Names are editable, maximum 16 visible characters. Empty name falls back to the default player label.

### 6.3 Avatar selection

- Use the approved CozyUni character roster.
- The same avatar cannot be selected by two players in one match.
- Avatar choice affects identity/reactions only unless the individual game explicitly uses characters as pieces.

### 6.4 Starting player

- First match: game chooses a starting player uniformly at random using the authoritative match seed.
- Rematch: starting player rotates to the next player slot.
- Chess is an exception: White moves first; colors are assigned according to the Chess spec.

## 7. Room Mode

### 7.1 Create Room

Host sees:
- six-character room code
- QR code containing the join payload
- player slots
- rules summary
- `Start Match` button
- `Leave Room`

Room code alphabet excludes ambiguous characters `0/O` and `1/I`.

Only the host can start.

The host cannot start until the minimum player count is reached.

### 7.2 Join Room

Join supports:
- manual six-character code entry
- QR scan where supported

After successful join, the player enters the same Room Lobby.

### 7.3 Room Lobby

Each slot shows:
- connection state
- player name
- avatar
- assigned color/side
- ready state

All non-host players have a `Ready` toggle.

`Start Match` is enabled only when:
- minimum player count is present
- every non-host connected player is Ready

The host is implicitly ready.

### 7.4 Rules ownership

Only the host may change pre-match game settings.

Any rules change clears all non-host Ready states.

Rules cannot change after countdown begins.

## 8. Match Summary screen

Shown immediately before tutorial/countdown.

It displays:
- game name
- player list in turn order
- one-sentence win condition
- exact active rules/preset
- expected session length label

Buttons:
- `Start` / continue
- `How to Play`
- `Back` (setup/lobby only)

No match state exists yet; backing out loses nothing.

## 9. Tutorial system

### 9.1 First-time behavior

- Each game has its own tutorial completion flag.
- On first start of that game, the tutorial is shown before the real match.
- The tutorial may be skipped using `Skip Tutorial`.
- Once completed or skipped, it does not auto-show again.
- It remains replayable from `How to Play` and Pause > Help.

### 9.2 Tutorial rules

- Tutorial is a deterministic sandbox, not the real match.
- Tutorial state does not affect stats, results, turn order, or room state.
- Room Mode: tutorial is local per device; the match countdown begins only after all connected players finish/skip it.
- Tutorial steps and exact content are defined in the individual game spec.

## 10. Match countdown

- Three beats: `3`, `2`, `1`, `Play`.
- Total duration: approximately 2.5 seconds.
- Reduced Motion setting removes scale/bounce but keeps timing/text.
- Input is locked until `Play` disappears.

## 11. Shared HUD hierarchy

The board is always the hero. Persistent UI must not cover critical cells/pieces.

### 11.1 Fixed zones

**Top-left**
- compact match/menu button only when needed

**Top-center**
- current turn/status chip
- examples: `Rabbit's Turn`, `White to Move`, `Round 5 / 12`

**Top-right**
- Settings/Pause button

**Bottom-left**
- current player's compact identity/status card

**Bottom-center**
- primary context action when one exists
- examples: `Roll`, `Place`, `Confirm`, `End Turn`
- this is the highest-priority button in the HUD

**Bottom-right**
- compact secondary contextual information/actions only

### 11.2 HUD rules

- No permanent large quest panel.
- No permanent inventory panel unless a future game explicitly requires one.
- Context panels auto-hide when no action is required.
- Primary action must remain reachable without stretching across the tablet.
- Use icons plus text for critical actions; do not rely on icons alone.
- Decorative UI cannot compete with board readability.

## 12. Input states

Every turn-based game must expose explicit input states to prevent accidental double actions.

Shared state vocabulary:
- `WAITING_FOR_TURN`
- `AWAITING_PRIMARY_ACTION`
- `AWAITING_SELECTION`
- `AWAITING_CONFIRMATION`
- `RESOLVING`
- `TURN_END`
- `MATCH_END`

During `RESOLVING`, gameplay input is disabled except Settings/Pause where safe.

A submitted game action must be idempotent at the authoritative match layer.

## 13. Pause / Settings during a match

Opening Settings pauses One Device matches immediately.

Room Mode:
- opening personal Settings does **not** pause the authoritative match
- if it is that player's turn, the turn remains waiting for their action unless a game-specific timer exists

Pause menu contains exactly:
- Resume
- How to Play
- Settings
- Restart Match (One Device only)
- Leave / Resign Match

`Restart Match` requires confirmation and resets the match using the same settings and player slots, with the starting-player rotation rule.

Room Mode does not allow one player to restart the shared match.

## 14. Global Settings

Settings are presentation/accessibility only. They do not alter rules unless the game setup screen explicitly exposes a rule option.

### Audio
- Master Volume: default 80
- Music: default 60
- SFX: default 80

### Feedback
- Haptics: On by default where supported
- Animation Speed: `Normal` default or `Fast`
- Reduce Motion: Off default

`Fast` shortens non-essential movement/celebration animation but does not change rule timing or network state.

### Accessibility
- Color Mode: Normal / Deuteranopia / Protanopia / Tritanopia
- UI Scale: Normal default / Large
- High Contrast Board Markers: Off default

Critical player identity must never depend on color alone. Use shape/icon/avatar redundancy.

### General
- Language: Auto default
- Confirm Resign/Leave: On default
- Replay Tutorials: opens game list/tutorial picker

Game-specific presentation settings are defined in each game spec.

## 15. Confirmations

Confirmation modal is mandatory for:
- leave/resign active match
- restart active One Device match
- destructive setup reset

No confirmation for:
- normal legal game moves, except where the individual game explicitly defines a placement confirmation flow
- Roll
- End Turn

## 16. Disconnect / reconnect rules

Applies only to Room Mode.

### 16.1 Temporary disconnect

- disconnected slot remains reserved for 60 seconds
- UI marks it `Reconnecting…`
- if it is not that player's turn, match may continue
- if their turn arrives, the match waits until they reconnect or the 60-second grace expires

### 16.2 Grace expiry

No bots are silently inserted in v1.

If a player fails to reconnect within 60 seconds:
- 2-player games: disconnected player forfeits; opponent wins
- 3–4 player race games: player forfeits and is placed below all players who remain connected; their pieces/tokens become inactive and non-blocking
- Cozy Tycoon: forfeiting player's properties and transports return to the bank unowned; upgrades are removed; their cash is discarded; remaining players continue

The individual game spec may add exact ranking details.

## 17. Match end presentation

### 17.1 Timing

When the end condition is reached:
1. lock gameplay input
2. resolve the final board animation
3. show winner/highlight celebration, maximum 3 seconds at Normal speed
4. open Final Results

No unskippable celebration longer than 3 seconds.

### 17.2 Final Results layout

For 3–4 player games:
- ranked cards: 1st, 2nd, 3rd, 4th as applicable
- avatar/name
- one game-specific key stat
- winner highlighted

For 2-player games:
- Winner / Loser, or Draw
- series/score if applicable
- end reason where relevant

Buttons:
- `Rematch` — primary
- `Change Setup` — secondary
- `Game Menu`

No global ranked ladder is implemented in v1.

### 17.3 Rematch

One Device:
- `Rematch` starts setup-preserving rematch immediately
- starting player rotates according to the shared/game-specific rule

Room Mode:
- pressing `Rematch` marks that player ready for rematch
- when all connected players have selected Rematch, new match starts with same rules/slots
- if any player selects `Game Menu`, room returns to lobby instead

## 18. Final ranking principles

- Ranking formulas are game-specific and explicitly defined in each game document.
- Agents may not invent secondary tiebreakers.
- If all defined tiebreakers remain equal, display a shared rank/draw rather than using hidden randomness.

## 19. Stats stored after a match

Store only these generic per-game stats in v1:
- matches played
- wins
- losses
- draws where applicable
- total play time

Game-specific local stats may be stored only if listed in the game spec.

Do not implement:
- ELO/MMR
- global leaderboard
- seasons
- quests
- currency rewards
- XP levels

## 20. Audio/VFX language

Shared audio rules:
- UI click: soft wooden/tactile click
- legal move/select: light positive tick
- invalid action: short muted thud, never harsh buzzer
- winner: short celebratory sting

Shared VFX rules:
- soft glow/ring for selectable objects
- no screen-filling particles during active decision moments
- confetti/flowers may appear only at match end
- Reduce Motion removes camera punch, bounce and large particle travel

## 21. Performance / readability acceptance

A game is not ready for art polish until:
- complete match can run from Start Screen to Final Results
- One Device path is complete
- Room path is complete or explicitly gated for that milestone
- no unresolved legal-state ambiguity remains
- no critical HUD element overlaps board interaction area
- all end states and disconnect states are deterministic
- tutorial can be completed without developer explanation

## 22. Change-control rule

Any future design change must update this document or the affected game document first.

Code is not the source of truth for rules. The docs are.
