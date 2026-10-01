# G3 — Cozy Journey — Full Game Design v1.0

Status: **DESIGN LOCK — third production game**

Shared rules/UI: `00_SHARED_GAME_EXPERIENCE_LOCK.md`

## 0. No-invention rule

Implement exactly this 36-space ruleset. Do not add random event tables, alternate routes, hidden shortcuts, skip-turn penalties, or new special spaces.

## 1. Product role

Cozy Journey is the second Path Board game and must reuse the Ludo turn/dice infrastructure while feeling visually different.

Mechanical family: linear Goose-style travel race.

Fantasy: players travel through the CozyUni region from Moonberry Village to a final Festival Pavilion, passing countryside, town, harbor and mountain landmarks.

## 2. Players / modes

- 2–4 humans
- One Device supported
- Room Mode supported
- Bots not implemented
- Public matchmaking not implemented

## 3. Session target

- Expected: **6–10 minutes**
- Hard target: most 4-player matches under **12 minutes**

## 4. Board topology

- Exactly **36 numbered spaces**.
- One continuous path.
- No branches.
- Player tokens may share the same space.
- There is no capture, blocking, or collision rule.

Region segmentation:
- Spaces 1–6: Moonberry Village
- Spaces 7–12: Countryside
- Spaces 13–18: Town
- Spaces 19–24: Harbor
- Spaces 25–31: Mountain
- Spaces 32–36: Festival / Resort destination

The path may visually curve/loop through a diorama, but numeric order is authoritative.

## 5. Start state

- Every player begins at virtual position `0`, before Space 1.
- One D6 is used.
- First player is selected by the shared random-start rule.

## 6. Normal turn

1. Player taps `ROLL`.
2. D6 resolves 1–6.
3. Player token moves forward exactly the rolled number of spaces.
4. If movement reaches or exceeds Space 36, clamp to 36 and end the match with that player as winner.
5. Otherwise resolve the landed space if it is special.
6. End turn unless the special space explicitly grants one extra roll.

The player does not choose between pieces; each player owns exactly one token.

## 7. Canonical special spaces

Only the following spaces are special in v1.

| Space | Name | Effect |
|---:|---|---|
| 4 | Lucky Gift | Move forward +2, then stop. Do not resolve a second special effect. |
| 7 | Mud Puddle | Move backward -2, minimum Space 1. Do not resolve a second special effect. |
| 10 | Train | Jump directly to Space 15. Do not resolve Space 15 effect. |
| 14 | Picnic Rest | Gain exactly one extra roll immediately after the current animation. |
| 18 | Ferry | Jump directly to Space 23. Do not resolve Space 23 effect. |
| 22 | Rain Delay | Move backward -3, minimum Space 1. Do not resolve a second special effect. |
| 26 | Cable Car | Jump directly to Space 31. Do not resolve Space 31 effect. |
| 30 | Wrong Turn | Move backward -2, minimum Space 1. Do not resolve a second special effect. |
| 34 | Lucky Gift | Move forward +2 to Space 36 and win immediately. |

Important chain rule:
- Special-space forced movement never triggers the destination's special effect.
- The only special that creates another action is Picnic Rest at Space 14.

## 8. Extra-roll rule

Picnic Rest grants exactly **one** extra D6 roll.

If the extra roll later lands on Space 14 again through impossible normal forward movement, no chain rule is needed; board topology makes this impossible.

Landing on another special after the extra roll resolves that new special normally.

## 9. Finish rule

Simple finish only:
- reaching or passing Space 36 wins
- movement clamps to Space 36
- exact roll is not required

There is no bounce-back finish.

## 10. Final ranking

Rank 1 is the winner at Space 36.

All other connected players are ranked by:
1. current space descending
2. number of positive special spaces landed on descending
3. number of negative special spaces landed on ascending

If still tied, show shared rank.

A forfeited Room player ranks below every connected finisher/remaining player. Among multiple forfeits, later forfeit ranks above earlier forfeit.

Final Results key stat: `Final Space`.

## 11. Turn state machine

```text
TURN_START
 -> AWAITING_ROLL
 -> DICE_RESOLVE
 -> MOVE_RESOLVE
 -> if reached 36: MATCH_END
 -> CHECK_SPECIAL
 -> SPECIAL_RESOLVE
 -> if Picnic extra roll: AWAITING_EXTRA_ROLL
 -> else TURN_END
```

Input remains locked during all movement/special animations.

## 12. Start Game / setup

Game Start Screen description:
`Roll, travel through CozyUni, and be the first to reach the Festival Pavilion.`

### One Device
- 2 / 3 / 4 players
- Default: 4
- each selects unique avatar
- slot colors remain Red / Blue / Green / Yellow

### Room
Same player count/settings.

There are no alternate board layouts or rule toggles in v1.

## 13. Match Summary

Show exactly:
- `36 spaces`
- `Roll and move one traveler`
- `Transport spaces can jump you ahead`
- `Some spaces move you backward`
- `Reach the Festival Pavilion first`
- Expected: `6–10 min`

## 14. Tutorial — exact sequence

Uses Rabbit Red on a small scripted path.

### Step 1 — Roll
Text: `Tap Roll to start your journey.`
Forced roll: 3.
Required: tap Roll.

### Step 2 — Move
Show token moving three spaces.
Text: `Your traveler moves automatically.`
Button: Continue.

### Step 3 — Special travel
Script places Rabbit before Train Space 10 and forces landing.
Text: `Travel spaces can jump you forward.`
Show jump 10 -> 15.

### Step 4 — Setback
Script demonstrates Mud.
Text: `Some spaces move you back, but you never lose a turn.`
Button: Continue.

### Step 5 — Finish
Show Festival Pavilion at Space 36.
Text: `Reach or pass Space 36 first to win.`
Button: `Start Match`.

Target tutorial length: under 45 seconds.

## 15. Board presentation

The board is a scenic path, not a square Ludo grid.

Requirements:
- Space numbers 1–36 remain readable.
- Region changes are visible through ground/material/nearby decor.
- Special spaces use a strong icon plus unique color accent.
- Decorative buildings sit outside tile hitboxes.
- Existing CozyUni world assets may be used as distant/adjacent dressing.

Required special icons:
- Gift
- Mud
- Train
- Picnic
- Ferry
- Rain
- Cable Car
- Wrong Turn

Icons are 2D/UI materials, not separate 3D props unless already available.

## 16. Camera

- Mild-isometric overview.
- Entire route does not need to fit at once if readability suffers.
- Default framing should show at least ~60% of the path.
- During active movement, camera may track the current token with a gentle pan.
- After movement resolves, camera eases back to strategic overview.
- Player may tap `Overview` in bottom-right to return to full-board framing.
- No manual free camera/rotation in v1.

## 17. HUD

### Top-center
`<Avatar> <Player> — Your Turn`

### Bottom-left
Current player card:
- avatar/name
- `Space N / 36`

### Bottom-center
`ROLL` primary button.

During forced special resolution, button is hidden.

### Bottom-right
- compact `Overview` button
- turn-order avatar strip above it

### Top-right
Settings/Pause.

No quest panel, inventory, travel log, or cards in v1.

## 18. Special-space feedback

- Lucky Gift: gold sparkle + `+2`
- Mud: soft splash + `-2`
- Train: whistle + quick path streak
- Picnic: picnic chime + `Extra Roll`
- Ferry: horn/chime + water streak
- Rain: cloud/splash + `-3`
- Cable Car: bell + upward swoosh
- Wrong Turn: sign wobble + `-2`

All text popups disappear within 1.0 s.

## 19. Animation timing

Normal:
- dice: 0.9 s
- normal movement: 0.10 s per tile, capped at 0.8 s
- transport jump: 0.65 s
- setback: 0.45 s
- extra-roll notification: 0.5 s

Fast multiplies non-essential timings by 0.6.

## 20. Pause / help

How to Play contains:
- Roll and move
- Reach/pass 36 wins
- Special-space table with all nine special spaces
- Explicit chain rule: forced movement does not trigger destination specials

No hidden random event text exists.

## 21. Disconnect behavior

Use shared 3–4-player forfeit rules.

When a player forfeits:
- remove their token from the path
- their occupied space becomes empty
- game continues

2-player disconnect forfeit ends match immediately.

## 22. Final Results

Rank cards show:
- rank
- avatar/name
- `Final Space: N/36`
- `Boosts: X`
- `Setbacks: Y`

`Boosts` counts Lucky Gift, Train, Picnic, Ferry, Cable Car landings.

`Setbacks` counts Mud, Rain, Wrong Turn landings.

Winner gets shared trophy presentation.

## 23. Stats stored

Generic stats plus:
- total positive specials landed
- total negative specials landed
- total Journey spaces traveled

## 24. AI→3D assets

Essential new assets:
1. `journey_finish_pavilion` if Ludo pavilion cannot be reused visually
2. `journey_start_arch`
3. `shared_cozy_dice` reused from Ludo
4. `shared_winner_trophy`

Player traveler:
- use simplified avatar token/character already available

Existing decorative reuse is strongly preferred:
- station/train
- ferry/dock
- cable car
- bridge
- market/town buildings
- lighthouse
- lodge
- trees/flowers/rocks

Do not render a unique 3D object for each special space.

## 25. Explicitly out of scope v1

- branching paths
- choice of route
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
- online matchmaking

## 26. Acceptance tests

Rules:
- spaces always remain within 1–36
- normal roll movement correct
- clamp finish correct
- each special resolves exact locked amount/destination
- forced-move chain suppression correct
- Picnic exactly one extra roll
- ranking deterministic

UX:
- special icons readable without opening help after one example
- board scenery never hides numbered spaces
- Start -> setup -> tutorial -> match -> results complete
- 2/3/4 player One Device and Room complete
- Ludo dice/turn infrastructure is reused rather than duplicated
