# G5 — Cozy Tycoon

Status: **later phase / highest design risk**

## 1. Product role

Cozy Tycoon is the most ambitious of the five board games. It should be an original CozyUni property/economy game built from generic property-trading ideas, not a visual or textual clone of Monopoly.

The fantasy is community development rather than ruthless bankruptcy: players invest in districts, transport, shops and attractions while competing to build the most successful cozy network.

## 2. Players / modes

- 2–4 players
- One Device / Table Mode
- Room Mode
- human-vs-human first
- bots only after economy/pacing are stable

## 3. Design goals

- recognizable property-board structure
- 20–35 minute target session, not 60–120 minute drag
- no long player elimination
- enough negotiation to create social moments without making trading mandatory every turn
- child-readable economy values
- visible comeback opportunities
- strong reuse of existing CozyUni buildings/assets

## 4. Core loop candidate

1. Roll / move.
2. Resolve current location.
3. Buy, upgrade, collect income or trigger an event.
4. Optionally trade/negotiate in allowed windows.
5. End turn.
6. Match ends on a clear time/round/goal condition.

The final economy must be designed and simulated before art expansion.

## 5. Property structure candidate

Instead of streets copied from a classic commercial board, use CozyUni categories such as:
- Village Shops
- Town Services
- Harbor
- Parks / Leisure
- Mountain / Resort
- Transport Links

Properties should use existing building models whenever possible.

Examples:
- Bakery
- Flower Shop
- Market Hall
- Train Station
- Ferry Terminal
- Lighthouse
- Mountain Lodge
- Café
- Marina / Yacht Club

Do not commission a unique new building for every property.

## 6. Economy directions to research

Before production lock:
- starting cash
- property prices
- base income
- upgrade cost/income curves
- transport bonuses
- set bonuses
- event frequency
- trade limits
- comeback systems
- end condition

Potential softer loss model:
- players are not eliminated immediately at zero cash
- assets can be sold/liquidated automatically
- debt may convert to lost upgrades rather than removing a player from the table

This must be tested; do not assume the softer model is automatically better.

## 7. Match end candidates

Prefer a finite ending instead of waiting for one survivor.

Candidate systems:
- fixed number of rounds
- festival deadline / final scoring round
- first to reach a development milestone + final scoring
- shared market closes after N event cycles

Final score could combine:
- cash
- property value
- completed district sets
- upgrades
- public projects / reputation

Keep scoring readable.

## 8. CozyUni-specific light systems

Possible original differentiators:
- **Community Projects** — optional shared landmarks everyone can contribute to, with unequal rewards
- **Transport Network** — station/ferry/cable-car ownership affects movement or income
- **Festival Demand** — temporary bonuses for categories such as food, tourism or flowers
- **District Goals** — complete a small set for a visual/score bonus

Only one or two should enter the first prototype.

## 9. Cards / events

Cards should be 2D UI/data, not 3D assets.

Event themes:
- market day
- rain / travel delay
- festival visitors
- harvest bonus
- transport maintenance
- tourist season

Rules text must be original and concise.

## 10. AI→3D bespoke asset kit

Reuse existing buildings and transport heavily.

Possible new assets:
1. Cozy Coin / coin stack
2. ownership marker
3. development/upgrade marker
4. major-upgrade landmark topper
5. auction gavel if auctions remain
6. treasury chest
7. transport token
8. shared community-project marker
9. winner trophy reused from common kit

Target: **~5–8 new 3D assets** before any later cosmetic expansion.

Do not render:
- money denominations as 3D
- event cards as 3D
- property deeds as 3D
- one custom building per tile
- whole board as a monolithic AI asset

## 11. Board / UI

Board generated in engine.

Must clearly communicate:
- property ownership color
- upgrade level
- price/income preview
- current player cash
- current location
- optional trade window

One Device mode:
- private information should be minimal
- trade dialog should be fast and readable around a shared tablet

Room Mode:
- each device may show richer personal finance/trade controls while the shared board remains synchronized

## 12. Prototype stages

### Prototype A — Economy skeleton
- move
- buy
- pay income
- simple upgrades
- fixed-round ending

No trading, no cards, no special transport powers yet.

### Prototype B — Pacing
- simulate many matches
- tune prices/income/round count
- test runaway leader and comeback behavior

### Prototype C — Social layer
Add only after A/B work:
- limited trading OR auction
- one event system
- one CozyUni-specific system

## 13. First playable acceptance

- 4 players can finish under the target duration range
- no player becomes irrelevant too early
- money/property state always understandable
- decisions matter beyond dice luck
- runaway leader frequency is acceptable
- fixed ending produces a satisfying final phase
- no rule requires a long explanation every turn

## 14. Main risks

- scope explosion
- copying too much recognizable commercial presentation
- match duration drifts too long
- economy snowballs
- trading stalls the table
- young players cannot read the numbers quickly
- adding too many special systems before base economy is fun

This game stays last until the simpler CozyUni games establish production discipline and shared systems.
