# CozyUni — Shared Game Experience Lock v1.1

Status: **DESIGN LOCK — authoritative for current single-device production**

Applies to:
- G1 Cozy Ludo
- G2 Cozy Caro
- G3 Cozy Journey
- G4 Cozy Chess
- G5 Cozy Tycoon

Companion source:
- `00_APP_SHELL_FLOW_LOCK.md` — app launch, game selection, setup navigation
- `00_SHARED_UI_LAYOUT_LOCK.md` — layout/hierarchy contract

## 0. Authority / no-invention rule

Implementation agents must not invent player-visible behavior.

Rules:
1. `00_APP_SHELL_FLOW_LOCK.md`, this document, UI lock, and selected game GDD are source of truth.
2. Game GDD overrides shared behavior only where it explicitly states an override.
3. If required behavior is not defined, default is **NOT IMPLEMENTED** and agent raises a design question.
4. Do not add buttons, modes, currencies, power-ups, rules, menus, bots, online systems, progression, rewards, ads or world navigation without a design update.
5. Balance constants stay in data/config but locked initial values come from GDD.
6. Code/comments do not override locked docs.

## 1. Current product scope

Current v1 is a polished **local family board-game collection**.

Supported:
- landscape tablet
- 2–4 local human players depending on game
- all players share one device/screen
- turn-based public-information gameplay

Deferred and not visible in current UI:
- Create Room / Join Room
- QR join
- multi-device play
- online matchmaking
- remote reconnect
- accounts/friends
- bots
- explorable CozyUni world

Existing world assets may be used as static decorative board dressing only.

## 2. End-to-end flow

Exact navigation is owned by `00_APP_SHELL_FLOW_LOCK.md`.

Current gameplay path:

```text
GAME LIBRARY
 -> GAME START SCREEN
 -> PLAY
 -> LOCAL PLAYER SETUP
 -> MATCH SUMMARY
 -> TUTORIAL if first time/requested
 -> 3 / 2 / 1 / PLAY
 -> MATCH
 -> FINAL RESULTS
 -> REMATCH / CHANGE PLAYERS / GAME LIBRARY
```

There is no Mode Select screen in current v1.

## 3. Device / orientation

- Primary orientation: landscape.
- Portrait is not required.
- Respect platform safe areas.
- Minimum touch target: 56 dp.
- Board remains the largest visual element during gameplay.

## 4. Local player setup conventions

Each player slot contains:
- slot number
- display name
- avatar
- side/color if relevant

Default names: `Player 1`, `Player 2`, etc.

Name limit: 16 visible characters.

Avatar selection:
- approved CozyUni roster only
- no duplicate avatar in one match
- avatar is cosmetic identity unless game GDD says it is a physical game piece

Starting player:
- first match uses authoritative local match seed where game requires random start
- rematch rotates start to next player slot
- Chess follows White-first color rules from Chess GDD

## 5. Match Summary

Shown after Local Player Setup and before tutorial/countdown.

Contains:
- game title
- player order/sides
- exact preset/ruleset
- win condition
- expected session time
- maximum 6 concise rule bullets

Buttons:
- `START`
- `HOW TO PLAY`
- `BACK`

No gameplay state exists yet.

## 6. Tutorial system

- one completion flag per game
- first match auto-shows tutorial
- tutorial may be skipped
- completed/skipped tutorial does not auto-show again
- tutorial replay available through How to Play / Pause > Help
- tutorial is deterministic sandbox, never counted in stats
- exact steps are defined in each game GDD

Tutorial presentation:
- one instruction bubble, max two lines
- dim irrelevant elements
- highlight only required control/cell/piece
- action advances tutorial where possible
- no giant rulebook modal

## 7. Countdown

Before every real match:
- `3`
- `2`
- `1`
- `PLAY`

Total approximately 2.5 s.

Input locked until PLAY disappears.
Reduced Motion removes bounce/scale but not timing.

## 8. Shared gameplay HUD hierarchy

Board is hero.

### Top-left
- compact menu/pause button only if required by layout

### Top-center
- current turn/status chip
- examples: `Rabbit — Your Turn`, `White to Move`, `Round 5 / 12`

### Top-right
- Settings/Pause

### Bottom-left
- current-player compact identity/status card

### Bottom-center
- primary context action if one exists
- examples: `ROLL`, `PLACE`, `CONFIRM`, `END TURN`

### Bottom-right
- maximum two compact secondary actions/info elements

Forbidden persistent HUD:
- quest rail
- inventory bar
- minimap
- social feed
- currency clutter outside Tycoon
- ads/store banners

## 9. Shared gameplay state vocabulary

Every game must map its turn flow into explicit states where applicable:
- `WAITING_FOR_TURN`
- `AWAITING_PRIMARY_ACTION`
- `AWAITING_SELECTION`
- `AWAITING_CONFIRMATION`
- `RESOLVING`
- `TURN_END`
- `MATCH_END`

During `RESOLVING`, game input is disabled.

Local submitted action must still be idempotent at match-state layer so double taps cannot duplicate moves.

## 10. Pause / Settings during match

On current single-device v1, opening Pause pauses the match immediately.

Pause menu contains exactly:
- Resume
- How to Play
- Settings
- Restart Match
- Leave Match

Restart:
- requires confirmation
- preserves current player/setup/rules
- applies normal rematch starting-player/side rotation unless game GDD overrides

Leave:
- requires confirmation
- returns to Game Start Screen for selected game
- abandoned match does not count as completed win/loss in current v1

## 11. Global settings

Settings are presentation/accessibility only unless a game GDD explicitly exposes a rule option before match.

### Audio
- Master Volume: 80 default
- Music: 60 default
- SFX: 80 default

### Feedback
- Haptics: On where supported
- Animation Speed: Normal default / Fast
- Reduce Motion: Off default

### Accessibility
- Color Mode: Normal / Deuteranopia / Protanopia / Tritanopia
- UI Scale: Normal / Large
- High Contrast Board Markers: Off default

### General
- Language: Auto default
- Confirm Leave/Restart: On default
- Replay Tutorials

Do not show network, room, account or matchmaking settings in current v1.

## 12. Confirmations

Confirmation required for:
- Restart active match
- Leave active match
- destructive setup reset if one exists

No confirmation for normal legal moves unless game GDD explicitly requires placement confirmation.

## 13. Match end presentation

When end condition occurs:
1. lock input
2. resolve final board animation
3. winner/end-state celebration, maximum 3 s at Normal speed
4. show Final Results

No unskippable celebration longer than 3 s.

## 14. Final Results

### 3–4 player games
Show ranked cards with:
- rank
- avatar/name
- one game-specific key stat
- winner highlight

### 2-player games
Show:
- Winner / Loser or Draw
- game-specific score/series where relevant
- end reason where relevant

Buttons exactly:
1. `REMATCH`
2. `CHANGE PLAYERS`
3. `GAME LIBRARY`

No XP, currency reward, ad, store popup or progression screen appears before these controls.

## 15. Rematch

Rematch:
- keeps same player count
- keeps same names/avatars/rules
- rotates starting player/side per shared/game rule
- does not replay tutorial
- goes directly to countdown unless selected game GDD explicitly requires a pre-rematch summary

## 16. Ranking/ties

- ranking formula is game-specific
- implementation agent may not invent secondary tiebreakers
- if all documented tiebreakers remain equal, show shared rank/draw

## 17. Stored stats

Generic per-game stats allowed in current v1:
- matches played
- wins
- losses
- draws where applicable
- total play time

Game-specific stats only if explicitly listed in that game's GDD.

Not implemented:
- MMR/ELO
- online leaderboard
- seasons
- XP
- quests
- spendable rewards

## 18. Shared audio/VFX language

Audio:
- UI click: soft tactile/wood click
- legal selection: light positive tick
- invalid action: short muted thud
- win: short celebratory sting

VFX:
- soft glow/ring for selectable objects
- no screen-filling particles during active decisions
- confetti/flowers only at match end
- Reduce Motion removes camera punch/bounce/large travel

## 19. Performance/readability gate before polish

A game is not ready for art polish until:
- complete Game Library -> Start -> Setup -> Tutorial -> Match -> Results flow works
- all supported local player counts work
- no unresolved legal-state ambiguity remains
- no critical HUD element blocks interaction
- tutorial completes without developer explanation
- all documented end states are deterministic
- rematch works without stale state

## 20. Multi-device future scope

Multi-device play is explicitly deferred.

When opened later, it must receive separate design + engineering docs covering room UX, protocol, authority, reconnect and failure states.

Current implementation must not pre-build speculative network behavior.

## 21. Change control

Any player-visible design change updates locked docs before code.

Docs are source of truth for game behavior.
