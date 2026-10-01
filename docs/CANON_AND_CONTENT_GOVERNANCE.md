# CozyUni — Canon & Content Governance v0.2

Status: **CURRENT**

## 1. Purpose

Prevent implementation drift while CozyUni is developed as a game-first product with a future larger world.

## 2. Authority hierarchy

For current board-game implementation:
1. `docs/games/00_SHARED_GAME_EXPERIENCE_LOCK.md`
2. selected full game GDD in `docs/games/`
3. `docs/GAME_MODE_ROADMAP.md`
4. product/architecture/world documents
5. old code/comments/prototypes

Higher source wins on conflict.

If locked game docs are silent, implementation agents must raise a design question rather than inventing production behavior.

## 3. Canon levels

### LOCKED GAME DESIGN
Cannot change without explicit GDD update:
- game rules/constants
- supported player counts/modes
- Start Game flow
- tutorials
- HUD action hierarchy
- match end/ranking/tiebreakers
- disconnect/forfeit behavior
- explicit out-of-scope features

### LOCKED SHARED IDENTITY
- resident names/species/core visual identity
- stable global asset IDs
- current approved art direction

### SHARED DEFAULT
Reusable presentation conventions that a game may override only when its GDD says so:
- avatar presentation
- common UI/audio language
- generic result/rematch components

### GAME-LOCAL
Defined only by the selected game GDD:
- board state
- score/economy
- movement
- game-specific temporary data

### FUTURE WORLD CANON
The persistent world is deferred. No implementation agent should promote a board-game assumption into future world canon without a separate world GDD decision.

## 4. World status

Existing shops, buildings, transport, nature, food, infrastructure and leisure assets remain valuable, but they do not require a world scene now.

When world development resumes, its target is a real living Animal-Crossing-like life-sim layer. A decorative launcher/hub is not considered completion of that vision.

## 5. Character rule

Approved CozyUni residents should remain recognizable across games.

Avatar choice is identity/presentation unless the game GDD explicitly uses the character as a physical piece.

## 6. Economy rule

Do not turn match-local values into global currencies.

Examples:
- Tycoon Coins exist only inside a Tycoon match.
- Ludo progress is not persistent XP.
- game wins/stats do not create a global spendable currency unless a later economy GDD explicitly defines one.

## 7. Content addition rule

Before adding a permanent feature not in a locked GDD, document:
1. why it is needed;
2. whether it is shared or game-local;
3. exact player-visible behavior;
4. save/network impact;
5. AI→3D or UI asset cost;
6. acceptance tests.

## 8. Documentation rule

Docs are the source of truth for player-visible rules.

Code may implement a rule but does not silently redefine it.

Any approved design change must update the relevant doc before or in the same change as implementation.
