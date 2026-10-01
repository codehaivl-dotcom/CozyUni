# CozyUni — Game Mode Roadmap v0.2

Status: **current research shortlist**

## 1. Strategy change

CozyUni will not attempt to invent and fully develop many original gameplay systems at once.

The current direction is:
- use familiar, proven board-game families as the mechanical foundation
- redesign presentation, world integration, theme and selected light rules
- keep production small enough to polish each game
- reuse shared multiplayer, board, UI, audio, profile and world systems
- validate one game before expanding to the next

The existing Moonberry/Festival work remains useful as world, UI, rules-engine and content research, but the five games below are the current **Family Game Table** research shortlist.

## 2. Shared multiplayer requirement

Suitable games should support:

### One Device / Table Mode
2–4 players share one device and take turns, like a physical board game.

### Room Mode
Players create/join a room and use separate devices while sharing one authoritative match state.

The two modes must share one rules engine.

## 3. Engine families

### Path Board Engine
Reusable by:
- Cozy Ludo
- Cozy Journey / Goose-family
- future simple race/path games

Shared systems:
- turn order
- dice
- path nodes
- piece movement
- safe/special nodes
- event nodes
- finish condition
- replay/rematch

### Grid Strategy Engine
Reusable by:
- Cozy Checkers
- Cozy Chess
- future Gomoku/Reversi-style games if needed

Shared systems:
- square-grid board
- piece selection
- legal-move highlighting
- move validation
- capture resolution
- turn switching
- history/replay hooks

### Economy Board Engine
Reusable by:
- Cozy Tycoon
- possible future market/trading board variants

This is the highest-scope engine and should not be built first.

---

# G1 — Cozy Ludo

Priority: **first prototype candidate**

Family: Cross-and-Circle / Ludo-style race game.

Target:
- 2–4 players
- one-device and room play
- roughly 5–15 minute quick format after tuning
- simple enough for children to understand after one short explanation

Core loop:
1. Roll.
2. Choose a movable piece.
3. Move toward home.
4. Use safe/special spaces.
5. Interact lightly with rival pieces.
6. Bring the team home first.

CozyUni changes should remain light. Examples:
- one or two shortcut/luck spaces
- gentle catch-up options
- world-themed safe spaces
- playful celebration animation

Do not bury Ludo under quests, inventory, economy or dozens of event rules.

### Asset strategy

Board/path: generated in engine.

Reuse:
- existing animal cast as player identity and potentially as pieces
- gift box / village props where useful
- existing world environment as background

Likely new 3D assets: very small kit, approximately 4–8 hero/game objects.

---

# G2 — Cozy Checkers

Priority: **low-cost strategy game**

Target:
- primarily 2 players
- one-device and room play
- fast setup and immediate readability

Core rules should stay close to familiar checkers/draughts behavior. Variant rules must be explicit because checkers has regional rule differences.

CozyUni contribution:
- cute thematic pieces
- warm board presentation
- clear capture/move feedback
- avatar reactions and win celebration

### Asset strategy

Board: generated in engine.

New art can be extremely small:
- player piece family
- crowned/king state or visual topper
- optional decorative board props

No complex rigs or bespoke environment required.

---

# G3 — Cozy Chess

Priority: **evergreen duel mode after grid engine is stable**

Target:
- 2 players
- one-device and room play
- standard rules first

Initial scope should focus on human-vs-human. A strong chess AI is a separate engineering concern and should not be confused with the cost of implementing the board game itself.

CozyUni contribution:
- one coherent stylized chess set
- friendly readable animation/VFX
- Chess Garden / club presentation in the Life Hub

### Asset strategy

Board: generated in engine.

Only six unique piece archetypes are required:
- King
- Queen
- Bishop
- Knight
- Rook
- Pawn

Player side/material colors are runtime variants rather than separate model generations.

---

# G4 — Cozy Journey

Priority: **second Path Board game / cheap reuse after Ludo**

Family: Game-of-the-Goose-style linear travel race.

Fantasy:
Players travel through the CozyUni world: village → countryside → town → harbor → mountain → resort/festival destination.

Target:
- 2–4 players
- one-device and room play
- approximately 5–12 minutes
- extremely easy rules

Core:
1. Roll.
2. Move along one path.
3. Resolve a clear special space if landed on.
4. Reach the destination under the chosen finish rule.

Possible CozyUni special spaces:
- train jump
- boat jump
- cable-car jump
- picnic/rest space
- lucky gift
- small setback

Do not create a unique 3D prop for every board square. Special spaces should mostly be icons, VFX and reused world props.

### Asset strategy

Reuse heavily from existing transport/infrastructure/world library.

Only a small number of new game-specific landmarks/tokens should be required.

---

# G5 — Cozy Tycoon

Priority: **later / highest design risk of the five**

Family: property/economy/trading board game.

This must be an original CozyUni implementation of generic property/economy mechanics, not a visual or textual clone of Monopoly or another commercial board game.

Potential fantasy:
Players help develop districts around CozyUni by opening shops, transport links, parks and attractions while earning income and making deals.

Potential core decisions:
- acquire/develop locations
- choose upgrade paths
- manage cash
- trade or negotiate
- resolve event cards
- use transport/world bonuses

Research questions before production:
- session length
- snowball control
- elimination vs no-elimination
- catch-up mechanics
- trading UX
- child-friendly economy values
- whether negotiation is required or optional

### Asset strategy

Board, cards, prices and ownership overlays should be generated in engine/UI.

Existing world buildings should represent properties wherever possible.

Do **not** render one new building per board property.

Expected bespoke 3D art should remain limited to tokens, a few economy landmarks and celebratory pieces.

---

## 4. Production order

Current research order:

1. Cozy Ludo
2. Cozy Journey OR Cozy Checkers, depending on what the first prototype teaches us
3. the other of Cozy Checkers / Cozy Journey
4. Cozy Chess
5. Cozy Tycoon

This is not a promise to ship all five.

Each game must pass a research gate before full production.

## 5. Research gate before production

For every game answer:
- Can new players understand the goal in under roughly one minute?
- Is the game still fun with children and adults at the same table?
- Is player downtime acceptable?
- Are there real decisions, or only animation around randomness?
- Does digital presentation improve the experience?
- Does One Device mode feel natural?
- Does Room Mode add value?
- Can the required assets be generated reliably by the AI→3D pipeline?
- Can the first playable be made without a large bespoke content set?
- After one match, do test players voluntarily ask for another?

If not, redesign before adding content.

## 6. Art production rule for board games

Do not AI-render complete boards as monolithic 3D assets when the board can be generated procedurally or assembled in engine.

Prefer engine/UI for:
- grids
- paths
- ownership colors
- labels/text
- card faces
- money values
- highlights
- rule markers

Use AI→3D for:
- pieces/tokens
- dice
- hero landmarks
- trophies/reward objects
- reusable decorative props

This keeps rule changes cheap and avoids wasting render credits.

## 7. IP / design rule

Use generic/public game mechanics as references, but create original CozyUni names, art, boards, wording, UI and presentation.

Do not copy commercial board artwork, logos, branded terminology, distinctive protected presentation or rulebook text.
