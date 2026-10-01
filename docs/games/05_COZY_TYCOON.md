# G5 — Cozy Tycoon — Full Game Design v1.1

Status: **DESIGN LOCK — local single-device / highest-scope game**

Shared authority:
- `00_APP_SHELL_FLOW_LOCK.md`
- `00_SHARED_GAME_EXPERIENCE_LOCK.md`
- `00_SHARED_UI_LAYOUT_LOCK.md`

## 0. No-invention rule

This is an original CozyUni economy board game. Implement exactly this economy and turn structure.

Do not add Monopoly-specific terminology/presentation, bankruptcy, jail, mortgages, auctions, house/hotel rules, chance/community-chest clones, or unlisted mechanics.

Current v1 is local multiplayer on one device. Multi-device/Room Mode is deferred.

## 1. Product role

Cozy Tycoon is the most complex game in the first set. It reuses CozyUni buildings as miniature properties and turns the asset library into a strategic family board game.

Fantasy: grow a friendly commercial/travel network and finish with the highest **Prosperity** score.

## 2. Players / modes

- 2–4 local human players
- One Device: supported/current v1
- Multi-device/Room Mode: not implemented
- Bots: not implemented
- Public matchmaking: not implemented

## 3. Session target

- exactly 12 rounds
- expected 4P: 20–35 min
- no alternate round length

One round ends after every active local player completes one turn.

## 4. Core principles

- no bankruptcy/elimination
- cash never below 0
- visitors do not pay rent directly
- when rival lands on owned property, **bank pays owner**
- all players remain relevant until Round 12
- winner = highest Prosperity, not last survivor

## 5. Starting state

Each player:
- Coins 100
- Properties 0
- Transports 0
- Upgrades 0
- Community Stars 0
- Coupon none

All tokens start Node 0 `Festival Plaza`.
Starting player follows shared local random-start rule.

## 6. Board topology

Exactly 28 nodes in one loop:

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

27 -> 0 wraps.

## 7. Movement

- one D6
- roll once per normal turn
- move exact result
- passing or landing on Node 0 grants +10 Coins once per crossing
- Fast Travel crossing 0 also grants +10 once

## 8. Turn structure

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

Fast Travel destination resolves inside TILE_RESOLVE before Develop.

## 9. Property districts / economy

### Village
| Property | Buy | L0 Income | L1 Cost | L1 Income | L2 Cost | L2 Income |
|---|---:|---:|---:|---:|---:|---:|
| Bakery | 20 | 4 | 10 | 6 | 15 | 9 |
| Flower Shop | 20 | 4 | 10 | 6 | 15 | 9 |
| General Store | 25 | 5 | 12 | 8 | 18 | 12 |

### Town
| Property | Buy | L0 Income | L1 Cost | L1 Income | L2 Cost | L2 Income |
|---|---:|---:|---:|---:|---:|---:|
| Café | 30 | 6 | 15 | 9 | 20 | 14 |
| Bookshop | 30 | 6 | 15 | 9 | 20 | 14 |
| Market Hall | 35 | 7 | 18 | 11 | 22 | 16 |

### Harbor
| Property | Buy | L0 Income | L1 Cost | L1 Income | L2 Cost | L2 Income |
|---|---:|---:|---:|---:|---:|---:|
| Fish Market | 35 | 7 | 18 | 11 | 22 | 16 |
| Ferry Terminal | 40 | 8 | 20 | 12 | 25 | 18 |
| Lighthouse | 40 | 8 | 20 | 12 | 25 | 18 |

### Tourism
| Property | Buy | L0 Income | L1 Cost | L1 Income | L2 Cost | L2 Income |
|---|---:|---:|---:|---:|---:|---:|
| Mountain Lodge | 45 | 9 | 22 | 14 | 28 | 21 |
| Seaside Hotel | 50 | 10 | 25 | 15 | 30 | 23 |
| Yacht Club | 50 | 10 | 25 | 15 | 30 | 23 |

All constants authoritative.

## 10. Unowned property

Show compact sheet:
- name
- district
- price
- base/current income
- upgrade preview

Actions:
- BUY
- PASS

BUY disabled if insufficient coins after coupon.
Purchase assigns Level 0 immediately.
No auction after Pass.

## 11. Owned property landing

### Own property
- no income
- continue to Develop

### Rival property
- visitor pays 0
- bank pays owner current income
- if owner owns all 3 in district: +2 district income bonus

Visitor coins unchanged.

## 12. District completion

Complete = one player owns all three properties.

While complete:
- +2 bank income when any property pays
- L2 upgrades unlocked
- +3 Prosperity at final scoring

If trade breaks district:
- +2 removed immediately
- no new L2 purchases
- existing L2 remains and keeps L2 income

## 13. Development

After tile resolution, active player may buy at most **one upgrade total** that turn.

May upgrade any owned property.

L0->L1:
- owner
- enough coins

L1->L2:
- owner
- complete district currently
- enough coins

L2 max.

Actions:
- DEVELOP
- END TURN

If no affordable legal upgrade, only END TURN.

DEVELOP opens owned-property list with level, cost, resulting income.

## 14. Transport nodes

Train Station, Bus Depot, Cable Car Station.

Buy price: 30 each.
No upgrades.

### Income when rival lands
Bank pays owner based on total Transports owned:
- 1 => 4
- 2 => 7
- 3 => 10

Visitor pays 0.

### Fast Travel
After purchase/ownership resolution on Transport:
- FAST TRAVEL +4
- STAY

Fast Travel:
- move +4
- passing 0 grants +10
- destination resolves normally
- destination Transport cannot Fast Travel again same turn
- max one Fast Travel/turn

## 15. Rest nodes

Node 11 Town Park and 26 Garden Rest:
- +3 Coins from bank
- no choice
- then Develop

## 16. Community Project

Nodes 5,17,24:
- CONTRIBUTE 10
- SKIP

If coins >=10 and Stars <3:
- pay 10
- gain 1 Community Star

At 3 Stars contribution disabled.
Stars cannot be traded/spent.
Each Star = 2 Prosperity.

## 17. Event deck

Exactly 12 cards.

Behavior:
- shuffle once from local authoritative match seed
- draw top on Event node
- discard after resolve
- when empty, reshuffle discard with authoritative RNG

Cards:
1. Market Day — +8 Coins
2. Rain Repairs — pay up to 5
3. Delivery Tip — +5
4. Festival Visitors — choose one owned property and gain current base income + district bonus; no property => +3
5. Free Decoration — one legal upgrade free; if none => +5
6. Community Grant — +1 Star if below 3; else +5 Coins
7. Local Fee — pay up to 4
8. Shop Coupon — next property/Transport purchase before end of next own turn costs 5 less, min price 1
9. Busy Weekend — +2 per property owned
10. Maintenance — pay up to 2 per total upgrade level
11. Travel Pass — owns Transport => +6; otherwise +3
12. Lucky Parcel — +6

`pay up to X` = min(currentCoins, X).

Coupon:
- expires end of next own turn if unused
- only one held
- drawing another refreshes -5, never stacks

## 18. Trade system — local shared screen

Trade exists and is deliberately constrained.

### Timing
At TURN_START before roll, active player may tap TRADE.
Maximum one proposal per turn.

### Contents
Proposal may contain:
- 0 or 1 property/Transport from proposer
- 0 or 1 property/Transport from recipient
- proposer Coins 0..current cash
- recipient Coins 0..current cash

At least one asset or positive coin amount changes hands.
Upgrades stay attached.
Stars/Coupon cannot trade.

### Shared-screen response
After proposer confirms offer:
- screen shows `Offer from <Player>`
- exact GIVE / RECEIVE summary
- recipient is asked to tap `ACCEPT` or `REJECT`
- no response timer in current local v1
- no counter-offer

Accept applies atomically.
Reject closes modal and proposer cannot propose again that turn.
District state recomputes immediately.

## 19. Round progression

- fixed turn order
- round increments after all players complete one turn
- match ends after last player finishes Round 12
- all players receive equal turn count

## 20. Prosperity scoring

Cash: `floor(Coins/10)`

Property: `2 × properties`

Upgrade: `total upgrade levels`

District: `3 × complete districts`

Transport:
- 1 each
- +3 extra if owns all 3

Community: `2 × Stars`

Total:
`Prosperity = Cash + Property + Upgrade + District + Transport + Community`

No hidden categories.

## 21. Ranking

1. Prosperity descending
2. Coins descending
3. complete districts descending
4. total upgrade levels descending

Still tied => shared rank.

Results key stat: Prosperity.

## 22. Start Game / Local Setup

Description:
`Buy CozyUni places, grow districts, make simple trades, and finish with the most Prosperity.`

PLAY -> Local Player Setup.

Setup:
- 2 / 3 / 4 players
- default 4
- unique avatars
- fixed Red / Blue / Green / Yellow
- Standard 12 rounds only

No economy sliders/house rules.

## 23. Match Summary

Show:
- `12 rounds`
- `Start with 100 Coins`
- `Buy places you land on`
- `The bank pays you when rivals visit your places`
- `Upgrade one place per turn`
- `Highest Prosperity after Round 12 wins`
- Expected `20–35 min`

## 24. Tutorial

Rabbit and Bear scripted board.

1. Roll/move to Bakery
   - `Roll the die to travel around CozyUni.`
2. BUY Bakery
   - `Unowned places can be bought with Coins.`
3. Bear lands on Bakery
   - `Visitors do not pay you. The bank pays your property income.`
   - show +4 Rabbit
4. upgrade Bakery L1
   - `After your turn, you may upgrade one place you own.`
5. Community node
   - `Contribute 10 Coins to earn Community Stars for final scoring.`
6. local trade example
   - Rabbit offers 10 Coins for Bear property
   - `Before rolling, you may make one simple trade offer.`
   - Bear taps Accept
7. show Prosperity breakdown
   - `After Round 12, the highest Prosperity wins.`
   - `Start Match`

Target <90 s.

## 25. Board presentation

- 28-node loop around stylized CozyUni region map
- reused miniature buildings adjacent/integrated with property tiles
- ownership = colored base ring/banner, not whole-building recolor
- upgrade level = 0/1/2 small star markers
- district identity = motif + icon, not hue only
- center dressing non-interactive

Do not imitate Monopoly typography, corner layout, deeds, houses/hotels or branded structure.

## 26. HUD

Top-center:
`Round X / 12 — <Player> Turn`

Bottom-left active player:
- avatar/name
- Coins
- Prosperity preview
- property count

Bottom-center primary:
- ROLL
- BUY
- END TURN
- CONTRIBUTE 10
- decision confirmation as context requires

Bottom-right secondary:
- TRADE only before roll
- DEVELOP only after tile resolution if legal affordable upgrade exists
- turn-order strip

Top-right:
- Pause/Settings

No permanent property inventory panel.
Tap own player card -> temporary owned-assets sheet; viewing does not alter state.

## 27. Property sheet

Must contain:
- name
- district
- owner
- level 0/1/2
- current bank income
- district-complete status
- next upgrade cost/income where applicable

Decision sheet flavor text max one line.

## 28. Animation timing

Normal:
- dice 0.9 s
- move 0.10 s/node, cap 0.8 s
- coin count 0.35 s
- ownership banner 0.35 s
- upgrade star 0.35 s
- Fast Travel 0.55 s
- Event card minimum 0.8 s

Fast ×0.6 non-essential.

## 29. Final Results

Rank cards:
- rank
- avatar/name
- Prosperity
- Coins
- Properties
- Complete Districts
- Upgrade Levels
- Community Stars

Expandable `Score Breakdown` shows exact categories.
Winner receives trophy.

Buttons:
- REMATCH
- CHANGE PLAYERS
- GAME LIBRARY

## 30. Stats

Generic plus:
- properties purchased
- trades accepted
- highest Prosperity
- Community Stars earned

No rating.

## 31. AI→3D assets

Reuse existing models for all 12 properties and 3 transports wherever available.

Essential bespoke/shared:
1. Cozy Coin / coin stack
2. ownership base/banner marker
3. upgrade star marker
4. Community Star token
5. shared D6
6. shared winner trophy

Cards/numbers/property info/events are UI/data.
Do not render unique building per board tile.

## 32. Explicitly out of scope

- multi-device/Room Mode
- online matchmaking
- player elimination/bankruptcy
- direct rent payments
- loans/debt
- mortgages
- auctions
- jail
- random movement cards
- hidden hands
- stock market
- more than 2 upgrade levels
- counter-offers
- multi-property bundle trades
- bots
- alternate round counts
- custom economies

## 33. Acceptance tests

Economy:
- all table constants exact
- cash never negative
- district +2 correct
- L2 lock correct
- trade transfer atomic
- coupon exact
- event deck deterministic from seed
- Star cap 3
- Transport 4/7/10 exact
- max one Fast Travel
- equal 12-round turn count
- Prosperity/tiebreak exact

UX:
- every money decision shows cost before confirmation
- no permanent large side panel
- local trade clear for players around one tablet
- Final Results exposes score breakdown
- full Game Library -> Start -> Local Setup -> Tutorial -> 12 rounds -> Results works
- no network/Room UI exists
