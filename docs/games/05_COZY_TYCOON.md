# G5 — Cozy Tycoon — Full Game Design v1.0

Status: **DESIGN LOCK — fifth production game / highest-scope game**

Shared rules/UI: `00_SHARED_GAME_EXPERIENCE_LOCK.md`

## 0. No-invention rule

This is an original CozyUni economy board game. Implement exactly this economy and turn structure for v1.

Do not add Monopoly-specific terminology/presentation, bankruptcy, jail, mortgages, auctions, house/hotel rules, chance/community-chest clones, or any unlisted economy mechanic.

## 1. Product role

Cozy Tycoon is the most complex game in the first set. It reuses CozyUni buildings as miniature properties and turns the existing asset library into a strategic board without requiring the explorable world.

Fantasy: players grow a friendly commercial/travel network across CozyUni. Competition is about building the highest **Prosperity** score, not eliminating other players.

## 2. Players / modes

- 2–4 humans
- One Device supported
- Room Mode supported
- Bots not implemented
- Public matchmaking not implemented

## 3. Session target

- Standard match: **12 rounds**
- Expected 4-player duration: **20–35 minutes**
- No alternate round length in v1

A round ends after every currently active player has completed one turn.

## 4. Core principles

- No player bankruptcy/elimination from running out of coins.
- Cash never goes below 0.
- Opponents do **not** pay rent directly to property owners.
- When a visitor lands on another player's property, the **bank pays income to the owner**.
- All players stay relevant until the fixed final round unless they disconnect/forfeit.
- Final winner is determined by Prosperity Points, not last-player-standing.

## 5. Starting state

Each player begins with:
- Coins: **100**
- Properties: 0
- Transports: 0
- Upgrades: 0
- Community Stars: 0
- Coupon discount: none

All player tokens begin on Node 0 `Festival Plaza`.

Starting player follows shared random-start rule.

## 6. Board topology

Exactly **28 nodes** in one loop.

Canonical node order:

| Node | Type | Name |
|---:|---|---|
| 0 | START | Festival Plaza |
| 1 | PROPERTY | Bakery |
| 2 | EVENT | Event |
| 3 | PROPERTY | Flower Shop |
| 4 | PROPERTY | General Store |
| 5 | COMMUNITY | Community Project |
| 6 | TRANSPORT | Train Station |
| 7 | PROPERTY | Café |
| 8 | EVENT | Event |
| 9 | PROPERTY | Bookshop |
| 10 | PROPERTY | Market Hall |
| 11 | REST | Town Park |
| 12 | TRANSPORT | Bus Depot |
| 13 | PROPERTY | Fish Market |
| 14 | EVENT | Event |
| 15 | PROPERTY | Ferry Terminal |
| 16 | PROPERTY | Lighthouse |
| 17 | COMMUNITY | Community Project |
| 18 | TRANSPORT | Cable Car Station |
| 19 | PROPERTY | Mountain Lodge |
| 20 | EVENT | Event |
| 21 | PROPERTY | Seaside Hotel |
| 22 | PROPERTY | Yacht Club |
| 23 | EVENT | Event |
| 24 | COMMUNITY | Community Project |
| 25 | EVENT | Event |
| 26 | REST | Garden Rest |
| 27 | EVENT | Event |

After Node 27, movement continues to Node 0.

## 7. Movement

- One D6.
- Player rolls once per normal turn.
- Move forward exactly the rolled number of nodes.
- Passing or landing on Node 0 grants **+10 Coins** exactly once per crossing.

A Transport Fast Travel move may also cross Node 0 and grants the same +10 once.

## 8. Turn structure

Each turn uses exactly this phase order:

```text
TURN_START
 -> OPTIONAL_TRADE
 -> AWAITING_ROLL
 -> DICE_RESOLVE
 -> MOVE_RESOLVE
 -> TILE_RESOLVE
 -> OPTIONAL_DEVELOP
 -> END_TURN
```

If Transport Fast Travel occurs, destination tile resolves inside `TILE_RESOLVE` before Optional Develop.

## 9. Property districts / locked economy table

There are exactly four districts, three properties each.

### Village District

| Property | Buy | Income L0 | Upgrade 1 Cost | Income L1 | Upgrade 2 Cost | Income L2 |
|---|---:|---:|---:|---:|---:|---:|
| Bakery | 20 | 4 | 10 | 6 | 15 | 9 |
| Flower Shop | 20 | 4 | 10 | 6 | 15 | 9 |
| General Store | 25 | 5 | 12 | 8 | 18 | 12 |

### Town District

| Property | Buy | Income L0 | Upgrade 1 Cost | Income L1 | Upgrade 2 Cost | Income L2 |
|---|---:|---:|---:|---:|---:|---:|
| Café | 30 | 6 | 15 | 9 | 20 | 14 |
| Bookshop | 30 | 6 | 15 | 9 | 20 | 14 |
| Market Hall | 35 | 7 | 18 | 11 | 22 | 16 |

### Harbor District

| Property | Buy | Income L0 | Upgrade 1 Cost | Income L1 | Upgrade 2 Cost | Income L2 |
|---|---:|---:|---:|---:|---:|---:|
| Fish Market | 35 | 7 | 18 | 11 | 22 | 16 |
| Ferry Terminal | 40 | 8 | 20 | 12 | 25 | 18 |
| Lighthouse | 40 | 8 | 20 | 12 | 25 | 18 |

### Tourism District

| Property | Buy | Income L0 | Upgrade 1 Cost | Income L1 | Upgrade 2 Cost | Income L2 |
|---|---:|---:|---:|---:|---:|---:|
| Mountain Lodge | 45 | 9 | 22 | 14 | 28 | 21 |
| Seaside Hotel | 50 | 10 | 25 | 15 | 30 | 23 |
| Yacht Club | 50 | 10 | 25 | 15 | 30 | 23 |

All values above are authoritative v1 constants.

## 10. Landing on an unowned property

Show compact property sheet:
- property name
- district
- purchase price
- current/base income
- upgrade preview

Actions:
- `BUY`
- `PASS`

BUY is disabled if current Coins < purchase price after applying any valid coupon.

If purchased:
- subtract price
- assign ownership immediately
- property is Level 0

No auction occurs after PASS.

## 11. Landing on an owned property

### Owned by active player
- no income is paid
- proceed to Optional Develop

### Owned by another player
- visitor pays 0
- bank pays owner the property's current income
- if owner currently owns all three properties in that district, add **+2 district income bonus**

Example: Bakery Level 1 income 6 + complete-district bonus 2 = bank pays owner 8.

The visitor's cash does not change.

## 12. District completion

A district is complete when one player owns all three district properties.

Effects while complete:
- +2 bank income whenever any of those properties pays income
- Level 2 upgrades are unlocked for those three properties
- +3 Prosperity Points at final scoring

If a trade breaks the district:
- district income bonus is removed immediately
- new Level 2 upgrades cannot be purchased
- existing Level 2 upgrades remain and continue using Level 2 base income

## 13. Development / upgrades

After tile resolution, active player may purchase at most **one upgrade total** that turn.

The upgraded property may be any property the player owns; the player does not need to be standing on it.

### Level 0 -> Level 1
Allowed if:
- player owns property
- has required coins

### Level 1 -> Level 2
Allowed if:
- player owns property
- owns all three properties in that district at that moment
- has required coins

### Level 2
Maximum. No further upgrades.

Actions in Develop phase:
- `DEVELOP`
- `END TURN`

If no legal affordable upgrade exists, only `END TURN` is shown.

`DEVELOP` opens a list of owned properties with level, cost and resulting income.

## 14. Transport nodes

Transport assets:
- Train Station
- Bus Depot
- Cable Car Station

Purchase price: **30 Coins each**.

Transports have no upgrades.

### 14.1 Transport income

When an active player lands on a Transport owned by another player, bank pays owner based on how many Transports that owner currently has:
- owns 1 Transport: 4 Coins
- owns 2 Transports: 7 Coins
- owns all 3: 10 Coins

Visitor pays nothing.

### 14.2 Fast Travel

After purchase/ownership resolution on any Transport tile, the active player may choose:
- `FAST TRAVEL +4`
- `STAY`

If Fast Travel chosen:
- move forward exactly 4 nodes
- passing Node 0 grants +10
- resolve destination tile normally
- a destination Transport does **not** offer another Fast Travel in the same turn

Maximum one Fast Travel per turn.

## 15. Rest nodes

Node 11 Town Park and Node 26 Garden Rest:
- active player receives **+3 Coins from bank**
- no choice
- then Optional Develop

## 16. Community Project nodes

On Nodes 5, 17, 24 the active player sees:
- `CONTRIBUTE 10`
- `SKIP`

If player has at least 10 Coins and fewer than 3 Community Stars:
- contribute exactly 10 Coins
- gain exactly 1 Community Star

If player already has 3 Community Stars, contribution is disabled.

Community Stars cannot be traded or spent.

Each Community Star = **2 Prosperity Points** at final scoring.

## 17. Event deck

The Event deck contains exactly 12 cards.

Deck behavior:
- shuffle once from authoritative match seed
- draw top card on Event node
- discard after resolution
- when deck empties, reshuffle the 12-card discard pile with authoritative RNG

No two-card choice UI.

### Event cards

1. **Market Day** — gain 8 Coins.
2. **Rain Repairs** — pay up to 5 Coins.
3. **Delivery Tip** — gain 5 Coins.
4. **Festival Visitors** — choose one owned property and gain its current base income plus any current district bonus immediately; if no property, gain 3 Coins.
5. **Free Decoration** — upgrade one legally upgradeable owned property by one level for free; if no legal upgrade exists, gain 5 Coins.
6. **Community Grant** — gain 1 Community Star if below 3; otherwise gain 5 Coins.
7. **Local Fee** — pay up to 4 Coins.
8. **Shop Coupon** — next property or Transport purchase made before the end of the player's next own turn costs 5 fewer Coins, minimum purchase price 1.
9. **Busy Weekend** — gain 2 Coins for each property currently owned.
10. **Maintenance** — pay up to 2 Coins per total upgrade level currently owned.
11. **Travel Pass** — if player owns at least one Transport, gain 6 Coins; otherwise gain 3 Coins.
12. **Lucky Parcel** — gain 6 Coins.

`pay up to X` means Coins reduce by `min(currentCoins, X)`; cash never becomes negative.

### Coupon expiry

Shop Coupon expires at the end of the player's next own turn if unused.

Only one coupon may be held. Drawing another while one is active resets/refreshes the same -5 discount; discounts do not stack.

## 18. Trade system

Trade exists in v1 but is deliberately constrained.

### 18.1 Timing

At `TURN_START`, before rolling, active player sees secondary action `TRADE`.

Only the active player may initiate.

Maximum **one trade proposal per turn**.

### 18.2 Trade contents

A proposal may contain:
- 0 or 1 property/Transport from proposer
- 0 or 1 property/Transport from recipient
- proposer Coins amount >=0 and <= proposer cash
- recipient Coins amount >=0 and <= recipient cash

At least one asset or positive coin amount must change hands.

Upgrades stay attached to a traded property.

Community Stars cannot be traded.

Coupon cannot be traded.

### 18.3 Response

Recipient sees:
- exact Give / Receive summary
- `ACCEPT`
- `REJECT`
- 20-second response timer

No counter-offer in v1.

Timeout = Reject.

Accepted trade applies atomically.

District completion/bonuses recompute immediately after trade.

## 19. Round progression

- Turn order remains fixed for the match.
- A round number increments after every active player has completed one turn.
- Match ends after the final active player completes their turn in **Round 12**.

All non-forfeited players therefore receive equal turn count.

## 20. Final Prosperity scoring

At match end compute exactly:

### Cash Points
`floor(Coins / 10)`

### Property Points
`2 × number of owned properties`

### Upgrade Points
`1 × total upgrade levels`

Example: one L2 property contributes 2 Upgrade Points.

### District Points
`3 × number of complete districts`

### Transport Points
- 1 point per Transport owned
- additional +3 bonus if player owns all 3 Transports

### Community Points
`2 × Community Stars`

### Total
`Prosperity = Cash + Property + Upgrade + District + Transport + Community points`

No hidden score categories.

## 21. Final ranking / tiebreakers

Sort by:
1. Prosperity descending
2. Coins descending
3. complete districts descending
4. total upgrade levels descending

If still equal, display shared rank.

Final Results key stat: `Prosperity`.

## 22. Start Game / setup

Description:
`Buy CozyUni places, grow districts, make simple trades, and finish with the most Prosperity.`

Setup:
- 2 / 3 / 4 players
- Default 4
- unique avatars
- fixed player colors Red / Blue / Green / Yellow
- Standard 12 rounds only

No economy sliders or house rules in v1.

## 23. Match Summary

Must show:
- `12 rounds`
- `Start with 100 Coins`
- `Buy places you land on`
- `The bank pays you when rivals visit your places`
- `Upgrade one place per turn`
- `Highest Prosperity after Round 12 wins`
- Expected: `20–35 min`

## 24. Tutorial — exact sequence

Tutorial uses Rabbit and Bear and a small scripted board.

### Step 1 — Roll / move
Text: `Roll the die to travel around CozyUni.`
Forced roll moves Rabbit to Bakery.

### Step 2 — Buy
Text: `Unowned places can be bought with Coins.`
Required: tap BUY on Bakery.

### Step 3 — Income
Script Bear lands on Rabbit's Bakery.
Text: `Visitors do not pay you. The bank pays your property income.`
Show `+4` to Rabbit.

### Step 4 — Develop
Text: `After your turn, you may upgrade one place you own.`
Required: upgrade Bakery to Level 1.

### Step 5 — Community
Script Community Project.
Text: `Contribute 10 Coins to earn Community Stars for final scoring.`
Required: Contribute.

### Step 6 — Trading
Show simple proposal: Rabbit offers 10 Coins for Bear property.
Text: `Before rolling, you may make one simple trade offer.`
Required: Accept scripted trade.

### Step 7 — Final score
Show Prosperity breakdown.
Text: `After Round 12, the highest Prosperity wins.`
Button: `Start Match`.

Target tutorial: under 90 seconds.

## 25. Board presentation

- 28-node loop arranged around a stylized CozyUni region map.
- Properties use miniature/reused building assets adjacent to or integrated with their tile.
- Ownership is shown by a clear colored base ring/banner, never recoloring the whole building.
- Upgrade level shown by 0/1/2 small star markers near ownership base.
- District identity uses ground/border motif plus icon; not color alone.
- Central map space may contain fountain/park dressing but is non-interactive.

Do not imitate Monopoly board typography, corner layout, deed cards, houses/hotels, or branded visual structure.

## 26. HUD

### Top-center
`Round X / 12 — <Player> Turn`

### Bottom-left — active player card
- avatar/name
- Coins
- Prosperity preview
- property count

### Bottom-center — primary action
Context-dependent:
- `ROLL`
- `BUY`
- `END TURN`
- `CONTRIBUTE 10`
- confirmation action inside trade/property dialogs

### Bottom-right
Secondary actions:
- `TRADE` only at turn start before roll
- `DEVELOP` only after tile resolution if a legal affordable upgrade exists
- turn-order compact strip

### Top-right
Settings/Pause.

No permanent property inventory panel.

Tapping own player card opens a temporary owned-assets sheet; it closes without changing state.

## 27. Property sheet

When shown, must contain:
- name
- district
- owner
- level 0/1/2
- current bank income
- district complete status
- next upgrade cost/income if applicable

No flavor text longer than one line in the decision sheet.

## 28. Animation timing

Normal:
- dice 0.9 s
- token movement 0.10 s/node, cap 0.8 s
- coin gain/loss count 0.35 s
- building ownership banner appear 0.35 s
- upgrade star appear 0.35 s
- Fast Travel 0.55 s
- Event popup auto card min display 0.8 s

Fast multiplier 0.6 for non-essential animation.

## 29. Room disconnect behavior

Shared Tycoon rule applies.

After 60-second forfeit:
- all forfeiting player's properties become unowned
- all upgrades on those properties are removed
- transports become unowned
- coins discarded
- Community Stars discarded
- coupon discarded
- player removed from future turn order
- no refund/payment to other players

Remaining players continue through Round 12 using only active slots.

Forfeited player ranks below all non-forfeited players in Final Results.

Among forfeits, later forfeit ranks above earlier forfeit.

## 30. Final Results

Show ranked cards with:
- rank
- avatar/name
- Prosperity total
- Coins
- Properties
- Complete Districts
- Upgrade Levels
- Community Stars

Expandable `Score Breakdown` shows exact formula categories.

Winner receives trophy presentation.

## 31. Stats stored

Generic stats plus:
- total properties purchased
- total trades accepted
- highest Prosperity score
- total Community Stars earned

No ranked rating.

## 32. AI→3D asset plan

Reuse existing assets for all 12 properties and 3 transports wherever available.

Essential bespoke/shared assets:
1. Cozy Coin / coin stack
2. simple ownership base/banner marker
3. upgrade star marker
4. Community Star token
5. shared D6
6. shared winner trophy

Cards, money numbers, score icons, property info and event content are UI/data, not AI-rendered 3D assets.

Do not render a unique building per board tile.

## 33. Explicitly out of scope v1

- player elimination/bankruptcy
- direct rent payments
- loans/debt
- mortgages
- auctions
- jail/detention
- random movement cards
- hidden hands
- stock market
- variable interest
- more than 2 upgrade levels
- counter-offers
- multi-property bundle trades
- bots
- public matchmaking
- alternate round counts
- custom economies

## 34. Acceptance tests

Economy:
- all property purchase/income/upgrade constants match tables
- cash never negative
- district +2 income bonus correct
- L2 upgrade lock correct
- trade transfers property/upgrades atomically
- coupon discount/expiry correct
- event deck deterministic from seed
- Community Star cap 3
- Transport income 4/7/10 correct
- max one Fast Travel/turn
- all players receive equal round count unless forfeited
- Prosperity formula/tiebreakers exact

UX:
- every money decision shows resulting cost before confirmation
- no permanent large side panel
- One Device trading is usable around one tablet
- Room trade timeout resolves deterministically
- Final Results explains score without hidden values
- complete Start -> setup -> tutorial -> 12 rounds -> ranking flow works
