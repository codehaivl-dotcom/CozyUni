# G1 — Cozy Ludo

Status: **first prototype candidate**

## 1. Product role

Cozy Ludo is the first game because it is easy to explain, naturally social, works well on one shared device, and gives CozyUni a clear family-table identity without requiring a large art set.

The design goal is not to reinvent Ludo. It is to keep the race/capture/home tension familiar while making the match shorter, softer and more visually rewarding.

## 2. Players / modes

- 2–4 players
- One Device / Table Mode
- Room Mode with one device per player
- Human-vs-human first
- Bots are optional after the real rules/pacing are validated

## 3. Target session

- ideal: 8–12 minutes
- hard target: normally under 15 minutes
- onboarding: under ~60 seconds for someone who already recognizes Ludo-style games

## 4. Core loop

1. Roll dice.
2. Select one legal animal/pawn.
3. Move along the shared path.
4. Resolve landing interaction.
5. Try to bring the full team to the Cozy Pavilion / home area.
6. First player to satisfy the chosen win condition wins.

## 5. Base rule direction

Research/lock before coding polish:
- number of pieces per player: test 3 vs 4
- entry rule: avoid overly long waiting to leave start
- capture rule: captured rival returns to start/base
- safe spaces: clearly marked
- exact-roll-to-finish: test because it can create dead turns
- extra turn on special roll/capture: tune carefully to avoid runaway turns

The first playable should use one simple ruleset. Variant rules can be added only after the base match is fun.

## 6. CozyUni light twists

Allowed twists should be small and readable:
- **Shortcut Gate** — rare board node that advances to a paired gate
- **Lucky Gift** — small positive event such as +1/+2 or a protected move
- **Safe Village Space** — thematic safe node
- **Gentle Catch-up** — optional rule tested only if losing players become inactive too early

Do not add quests, inventories, shop economies or card decks to Ludo.

## 7. Digital value

Digital should improve the physical formula through:
- automatic legal-move highlights
- instant path counting
- satisfying hop animation
- clear capture feedback
- avatar reactions/emotes
- quick rematch
- optional fast-rule presets
- Room Mode without requiring a physical board

## 8. Board / camera

Board should be generated in engine, not AI-rendered as one mesh.

Recommended presentation:
- square table board
- 3D animal pieces on top
- simple cozy village dressing around the outside
- readable top/isometric camera
- large cells and strong player colors
- decorations must never hide paths

## 9. AI→3D asset kit

Reuse:
- approved animal cast
- existing lanterns, flowers, small houses/props where useful as non-interactive dressing

Bespoke assets should stay small:
1. Cozy Dice
2. Finish Pavilion / Home Trophy Pavilion
3. Shortcut Gate
4. Safe-Space marker
5. Lucky Gift Box if existing gift prop is unsuitable
6. Winner Trophy
7. optional neutral fallback pawn

Target: **~5–7 new 3D assets**, not dozens.

## 10. UI

One Device:
- current-player portrait
- large Roll button
- legal pieces pulse/highlight
- compact turn order
- optional rules/help button

Room Mode:
- personal avatar/name panel
- same shared board state
- current player emphasized on every device
- spectator feedback when waiting

HUD should stay thin. The board is the hero.

## 11. First playable acceptance

A first playable is successful when:
- 4 humans can complete a match without developer intervention
- no ambiguous legal move states
- average turn resolves quickly
- players understand safe/capture/home states visually
- one-device play feels natural around a table
- testers request a rematch without needing new content

## 12. Main risks

- turns too long because of animation
- too much randomness / too little choice
- match drags near the end
- one lucky player snowballs through repeated extra turns
- tiny character models reduce board readability

Solve these with rules/pacing before adding art.
