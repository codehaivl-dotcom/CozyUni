# G3 — Cozy Journey

Status: **third prototype / Path Board reuse game**

## 1. Product role

Cozy Journey is the lowest-risk way to reuse the Path Board Engine after Cozy Ludo while presenting a completely different board shape and fantasy.

Mechanical family: Game-of-the-Goose-style linear race.

Fantasy: players travel through the CozyUni region from village to countryside, town, harbor, mountain and a final festival/resort destination.

## 2. Players / modes

- 2–4 players
- One Device / Table Mode
- Room Mode
- human-vs-human first
- bots optional later

## 3. Target session

- ideal: 6–10 minutes
- hard target: normally under 12 minutes
- onboarding: under one minute

## 4. Core loop

1. Roll dice.
2. Move one player token along one numbered path.
3. Resolve the landed special space.
4. Continue until a player reaches the final destination under the selected finish rule.

Unlike Ludo, players do not manage several pieces. The strategy is intentionally lighter and the visual journey is the main reward.

## 5. Board structure

Recommended prototype:
- ~30–40 spaces
- one continuous path
- 5–7 recognizable region segments
- a small number of special spaces
- no branching path in the first version unless testing proves one branch adds meaningful choice

The path and tiles are generated in engine.

## 6. Special-space vocabulary

Keep the vocabulary small and reusable:
- **Train** — jump forward to the paired station
- **Boat/Ferry** — travel forward to another coastal node
- **Cable Car** — mountain jump
- **Picnic Rest** — pause/skip or safe rest depending on tested rules
- **Lucky Gift** — small bonus movement
- **Rain/Mud/Delay** — small setback
- **Shortcut** — advance to a visible linked node

Most special spaces should be icons plus VFX and should reuse existing world assets in the surrounding diorama.

Do not create 30 different events for a 30-space board.

## 7. Finish rule to test

Two candidate rules:

### Simple Finish
Any roll that reaches or passes the final space wins.

### Exact Finish
Exact roll required; excess movement follows a defined bounce/no-move rule.

Start with Simple Finish for family accessibility. Only keep Exact Finish if it improves tension rather than causing frustrating dead turns.

## 8. Digital value

- animated travel through visually distinct regions
- automatic resolution of transport jumps
- quick event cards/popups
- player reactions
- compact travel log
- strong final-destination celebration
- optional seed/board-of-the-day later

## 9. Existing asset reuse

This game should reuse more existing 3D work than any other game:
- train / station
- harbor / dock / ferry
- cable-car infrastructure
- bridges
- lighthouse
- shops and civic buildings
- mountain lodge
- parks
- trees / flowers / rocks
- road and rail modules

These are decorative/world-reading assets, not required pieces of game logic.

## 10. AI→3D bespoke kit

Likely new assets:
1. player travel token if characters are too large
2. start arch / departure marker
3. final destination pavilion
4. suitcase/travel token
5. special-space marker family if UI icons alone are insufficient
6. winner trophy reused from shared kit

Target: **~3–6 new assets**.

## 11. UI / camera

- whole path should be readable at a glance where possible
- camera may gently track current player during movement
- special events should be short, not modal for long periods
- current turn and next player visible
- dice action large and obvious
- decorative scenery must not obscure numbered spaces

## 12. First playable acceptance

- a four-player match completes in under target time most runs
- special spaces are understood after one occurrence
- no event causes long rule explanations
- movement/jump animations remain fast
- Ludo Path Board code is meaningfully reused rather than rewritten
- testers remember the journey/region theme after the match

## 13. Main risks

- too random and passive
- excessive event count slows the match
- exact-finish rule creates boring endings
- environment art overwhelms board readability
- too much bespoke art defeats the purpose of this being a cheap reuse game

Keep Journey simple and visually rich rather than mechanically dense.
