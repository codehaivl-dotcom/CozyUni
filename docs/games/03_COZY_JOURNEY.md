# G3 — Cozy Journey — Full Game Design v1.1

Status: **DESIGN LOCK — local single-device**

Shared authority:
- `00_APP_SHELL_FLOW_LOCK.md`
- `00_SHARED_GAME_EXPERIENCE_LOCK.md`
- `00_SHARED_UI_LAYOUT_LOCK.md`

## 0. No-invention rule

Implement exactly this 36-space ruleset. Do not add random event tables, alternate routes, hidden shortcuts, skip-turn penalties, or new special spaces.

Current v1 is local multiplayer on one device. Multi-device/Room Mode is deferred.

## 1. Product role

Cozy Journey is the second Path Board game and must reuse Ludo turn/dice infrastructure while feeling visually different.

Fantasy: players travel through CozyUni from Moonberry Village to a final Festival Pavilion.

## 2. Players / modes

- 2–4 local human players
- One Device: supported and required for current v1
- Multi-device/Room Mode: not implemented
- Bots: not implemented
- Public matchmaking: not implemented

## 3. Session target

- Expected: **6–10 minutes**
- Hard target: most 4-player matches under **12 minutes**

## 4. Board topology

- exactly **36 numbered spaces**
- one continuous path
- no branches
- player tokens may share same space
- no capture, blocking or collision

Regions:
- 1–6 Moonberry Village
- 7–12 Countryside
- 13–18 Town
- 19–24 Harbor
- 25–31 Mountain
- 32–36 Festival / Resort

Numeric order is authoritative even if path curves visually.

## 5. Start state

- every player starts at virtual position 0 before Space 1
- one D6
- first player selected by shared local random-start rule

## 6. Normal turn

1. tap `ROLL`
2. resolve D6 1–6
3. token moves forward exactly result
4. if reaches/passes 36, clamp to 36 and win immediately
5. otherwise resolve landed special space if any
6. end turn unless Picnic grants one extra roll

One token per player.

## 7. Canonical special spaces

Only these exist:

| Space | Name | Effect |
|---:|---|---|
| 4 | Lucky Gift | +2, stop; no destination special |
| 7 | Mud Puddle | -2, minimum 1; no destination special |
| 10 | Train | jump to 15; do not resolve 15 |
| 14 | Picnic Rest | exactly one extra roll |
| 18 | Ferry | jump to 23; do not resolve 23 |
| 22 | Rain Delay | -3, minimum 1; no destination special |
| 26 | Cable Car | jump to 31; do not resolve 31 |
| 30 | Wrong Turn | -2, minimum 1; no destination special |
| 34 | Lucky Gift | +2 to 36 and win |

Forced movement never chains into destination special effects.
Only Picnic creates another action.

## 8. Extra roll

Picnic grants exactly one additional D6 roll.

A special landed after that extra roll resolves normally.

## 9. Finish

- reaching or passing 36 wins
- clamp to 36
- exact roll not required
- no bounce-back

## 10. Final ranking

Rank 1 = winner.

Others sorted by:
1. current space descending
2. positive specials landed descending
3. negative specials landed ascending

If still tied: shared rank.

Results key stat: `Final Space`.

## 11. Turn state machine

```text
TURN_START
 -> AWAITING_ROLL
 -> DICE_RESOLVE
 -> MOVE_RESOLVE
 -> if reached 36: MATCH_END
 -> CHECK_SPECIAL
 -> SPECIAL_RESOLVE
 -> if Picnic: AWAITING_EXTRA_ROLL
 -> else TURN_END
```

Input locked during movement/special animation.

## 12. Start Game / setup

Start Screen description:
`Roll, travel through CozyUni, and be the first to reach the Festival Pavilion.`

Press PLAY -> Local Player Setup.

Setup:
- 2 / 3 / 4 players
- default 4
- unique avatars
- fixed slot colors Red / Blue / Green / Yellow

No rule toggles.

## 13. Match Summary

Show exactly:
- `36 spaces`
- `Roll and move one traveler`
- `Transport spaces can jump you ahead`
- `Some spaces move you backward`
- `Reach the Festival Pavilion first`
- Expected: `6–10 min`

## 14. Tutorial

Rabbit Red scripted example.

1. `Tap Roll to start your journey.`
   - forced roll 3
2. show 3-space move
   - `Your traveler moves automatically.`
3. demonstrate Train 10 -> 15
   - `Travel spaces can jump you forward.`
4. demonstrate Mud
   - `Some spaces move you back, but you never lose a turn.`
5. show Space 36
   - `Reach or pass Space 36 first to win.`
   - `Start Match`

Target <45 s.

## 15. Board presentation

- scenic path, not square Ludo grid
- numbers 1–36 always readable
- region change shown through ground/material/decor
- special spaces use strong icon + accent
- decorative buildings outside hitboxes
- existing CozyUni world assets may dress scenery

2D/UI special icons:
- Gift
- Mud
- Train
- Picnic
- Ferry
- Rain
- Cable Car
- Wrong Turn

Do not create unique 3D prop for each special.

## 16. Camera

- mild isometric overview
- default shows at least ~60% route
- gentle track current token during movement
- ease back to overview after resolution
- bottom-right `Overview` returns to strategic framing
- no free rotation

## 17. HUD

Top-center:
`<Avatar> <Player> — Your Turn`

Bottom-left:
- avatar/name
- `Space N / 36`

Bottom-center:
- `ROLL`
- hidden during forced resolution

Bottom-right:
- `Overview`
- turn-order avatar strip

Top-right:
- Pause/Settings

No quest panel, inventory, travel log or cards.

## 18. Special feedback

- Gift: gold sparkle `+2`
- Mud: soft splash `-2`
- Train: whistle + path streak
- Picnic: chime + `Extra Roll`
- Ferry: horn/chime + water streak
- Rain: cloud/splash `-3`
- Cable Car: bell + upward swoosh
- Wrong Turn: sign wobble `-2`

Popup <=1.0 s.

## 19. Animation timing

Normal:
- dice 0.9 s
- move 0.10 s/tile, cap 0.8 s
- transport jump 0.65 s
- setback 0.45 s
- extra-roll notice 0.5 s

Fast multiplies non-essential timings by 0.6.

## 20. Pause / Help

Help contains:
- roll/move
- reach/pass 36 wins
- all nine special spaces
- forced-movement chain suppression

No hidden events.

## 21. Final Results

Rank cards show:
- rank
- avatar/name
- `Final Space: N/36`
- `Boosts: X`
- `Setbacks: Y`

Boosts = Gift, Train, Picnic, Ferry, Cable Car.
Setbacks = Mud, Rain, Wrong Turn.

Winner gets shared trophy.

Buttons:
- REMATCH
- CHANGE PLAYERS
- GAME LIBRARY

## 22. Stats

Generic stats plus:
- total positive specials
- total negative specials
- total spaces traveled

## 23. AI→3D assets

Essential:
1. `journey_finish_pavilion` if Ludo pavilion cannot visually reuse
2. `journey_start_arch`
3. shared cozy D6
4. shared winner trophy

Traveler uses existing simplified avatar token/character.

Reuse existing station/train, ferry/dock, cable car, bridge, buildings, lighthouse, lodge, nature.

## 24. Explicitly out of scope

- multi-device/Room Mode
- online matchmaking
- branching paths
- route choice
- cards
- hidden events
- skip-turn penalties
- capture/bumping
- inventory
- coins
- exact finish
- board randomization
- daily board
- bots

## 25. Acceptance tests

Rules:
- positions always 1–36 after entering board
- normal roll correct
- clamp finish correct
- every special exact
- chain suppression correct
- Picnic exactly one extra roll
- ranking deterministic

UX:
- Game Library -> Start -> Local Setup -> Tutorial -> Match -> Results complete
- 2/3/4 local player matches complete
- scenery never hides numbered spaces
- Ludo dice/turn infrastructure reused
- no network/Room UI exists
