# W01 Moonberry Village — Playable Slice Blueprint

## A. Goal and boundaries

One genuinely playable 3D village, not an illustrated hub. **Release slice goal:** 45–75 minutes of guided discovery and repeatable activities, with a satisfying first evening and clear continuation. Production can be broken into small playable gates; this target is the full W01 slice, not a promise it is built already.

Use the **existing W01 world structure** from `docs/world/00_WORLD_VISUAL_MVP_LOCK.md` and the 7 zone names from the production lock. No board loop. Do not invent coordinates and pretend they were measured.

### Physical world structure

```
                         [TOWN HALL / MAYOR PORCH]
                                      |
[RESIDENTIAL LANE + PLAYER OWNED PLOTS] --- [SQUARE + FOUNTAIN] --- [SHOP STREET: BAKERY/FLORIST/STORE/BOOKSHOP]
          |                           |
 [PARK + GAZEBO] -------------- [MAIN STREET]
                                      |
                          [VILLAGE ENTRY / BUS STOP]
```

This is **semantic adjacency**, not surveyed geometry or a request for a fixed T-junction. The level builder must retain the tested W01 main route from the repository if it exists locally, and anchor assets to real scene transforms measured in Godot. Side pockets: park/gazebo and residential doorsteps; no maze or unnecessarily long loop. The old `PARK_LUDO` machine zone may be kept temporarily as a backwards-compatible identifier, but its **visible gameplay role is now SOCIAL_PARK**, with no Ludo venue.

- **ENTRANCE** — player arrival, greeting sign, bus stop, first view toward the village.
- **MAIN_STREET** — simple walkable spine, views of Square, photo spot, lamp posts.
- **SQUARE** — fountain, social meeting spot, first public decor socket, photo album location.
- **SQUARE_TOWN_HALL** — Mayor Pip greeting and public-project board (NOT a board game).
- **SHOP_STREET** — Bakery, Flower Shop, General Store, Bookshop frontages; social activity cues. Initial release uses exteriors and interaction markers, no interiors.
- **PARK_SOCIAL** — garden bed, gazebo, photo spot, public arrangement socket; existing technical alias `PARK_LUDO` to be migrated intentionally.
- **RESIDENTIAL** — 4 visually distinct home exteriors, **private expansion pocket next to player house** with one starter parcel and three neighboring purchasable parcels. Never sell or edit the NPC houses, main road or plaza.

Target normal walk from arrival to social park through square/shop street: 60–120 seconds subject to tested route; do not assert historical 127m or 84.08s until actual scene evidence exists.

## B. Character casting (newly proposed roles)

| Character ID | Name | Role in W01 | Minimum interaction |
|---|---|---|---|
| CHR-001 | Miko Rabbit | Default player avatar | idle, walk/run, face resident, greet, plant, place |
| CHR-006 | Pip Hedgehog | Mayor | welcome, introduce album, host evening |
| CHR-002 | Poppy Bear | Bakery resident | 2-stage friendly scene at bakery / café |
| CHR-004 | Lumi Cat | Flower Shop resident | gardening tutorial and return greeting |
| CHR-003 | Milo Dog | Curious town photographer | first photo challenge and feedback |
| CHR-005 | Finn Fox | Park caretaker | public furnishing socket and garden life |

No additional named NPCs required for the initial chapter. **The total canonical cast is still CHR-001…CHR-020**, with the remaining residents distributed as ambient encounters and later regional stories; see `05_CHARACTER_ROSTER_20.md`. All 6 characters may use placeholders during mechanics testing; art/rigger acceptance is separate. Reuse one locomotion/idle/talk animation family when feasible; do not assume one automatic rig works for wildly different animal anatomy without testing.

## C. Main chapter: A Place Among Friends

**Quest M01 — Arrival (3–5 min)**
- Spawn at the bus stop in morning. Signpost indicates village center.
- Approach Mayor Pip at Town Hall porch. Talk, choose between two friendly greeting responses.
- Mayor introduces the Village Album and points out Square, Park, Flower Shop.
- Reward: WELCOME album stamp **and +40 Village Coins**. World change: Pip relocates to square after greeting.
- Failure safety: if player wanders, a single discreet compass arrow guides back; no forced teleport.

**Quest M02 — A Small Garden (6–10 min)**
- Find Lumi outside Flower Shop. Short story: a shared garden can use color.
- Enter Park Social, interact with designated soil bed; choose lavender / daisies / red blossoms. Plant and water.
- On first story gardening action, Lumi triggers a scripted gentle scene transition and the first flower blooms immediately (tutorial exception). Other future plants follow the 24-minute game day.
- Reward: FIRST_FLOWER **and +30 Village Coins**. World change: planted color persists in the bed and Lumi later stops there in afternoon.
- Repeatable after story: change one planted variety or add a second plot; no requirement to harvest items for money.

**Quest M03 — Frame a Memory (5–8 min)**
- Milo offers a 3-shot photo walk: Square Fountain, Shop Street, Gazebo.
- Player freely frames each scene and confirms a photo. Album marks SQUARE_VIEW, SHOP_STREET_VIEW and PARK_VIEW separately.
- Wrong/unclear frame: gently show landmark cue, allow retry with no penalty.
- Reward: a framed-memory decorative marker available at player doorstep **and +30 Village Coins**; photo album has at least 3 visible entries.

**Quest M04 — A Cozy Corner (7–10 min)**
- Meet Finn at Park gazebo. He offers three furnishing choices for one Square socket: `garden_bench` / `flower_planter` / `warm_lantern`.
- Player previews chosen furnishing, rotates it in quarter-turns, confirms; no additional materials/currency needed for this tutorial project.
- World change: furnishing remains after leaving/re-entering the region and app restart; a resident later stands or sits nearby (appropriate to choice).
- Reward: COZY_CORNER. The player can revisit the socket and change among unlocked alternatives later.

**Quest M05 — Everyone Has a Story (8–12 min)**
- Poppy is first found at the Bakery front. Listen to short conversation about the village gathering.
- After one gardening or photo milestone, Poppy moves to café seating. Follow up there; response acknowledges the player's observed action.
- Lumi also has a second short dialogue at the garden after first bloom.
- Reward: FRIEND_Poppy and FRIEND_Lumi album stamps. No reputation meter or daily dialogue grinding.

**Quest M06 — The First Evening (5–8 min)**
- After M01, M02 and M04, the mayor invites player to the square gathering. No wait for wall clock: player may choose “Meet this evening” at Mayor's noticeboard, smoothly switching to evening.
- Five named residents converge at Square or adjacent café/gazebo; soft lanterns light; NPCs idle/talk; the placed Cozy Corner decoration is highlighted in a natural composition.
- Player can walk around, speak to Mayor Pip, take a final optional photo. Short closing text unlocks EVENING_TOGETHER.
- Save chapter completion. Village remains playable with daily cycles and side album entries.

**Quest M07 — Our First Extra Piece of Land (first optional home-building chapter, 6–10 min)**
- Unlocks after M03; does **not** block M06 evening gathering. Player already has 100 earned VC from M01–M03.
- Mayor Pip introduces the residential boundary board outside the player home; walk to a highlighted empty parcel directly adjoining the starter 8×8 m area.
- Show price **100 VC**. Press Preview to show the extended grass ground, corner boundaries and an automatic accessible connection; Confirm spends 100 VC **once** and unlocks the plot. Cancel does not spend. The player can walk onto the purchased land immediately.
- Player chooses the new plot’s first terrain finish (grass/dirt/cobble/deck) and places two unlocked decoration pieces, then rearranges one item. There is no generation cost or hidden building permit.
- Reward: `LAND_PLOT_01_OWNED` build progression flag and one resident reaction. Every installed piece and the land boundary persist after app restart.
- Future plot 2 price 150 VC, plot 3 price 250 VC. Earning: one daily resident-care action gives +25 VC, once per in-game day.
- No real-money land sales in the first release. Optional monetization later requires a separate product decision.

### Scripted starter dialogue samples (tone authority)

**Pip at arrival:** “Chào mừng đến Moonberry! Ở đây không cần làm điều gì thật lớn. Một góc vườn đẹp, một người bạn mới — vậy là ngày đã vui rồi.”

**Lumi at garden:** “Mỗi người sẽ chọn một màu hoa khác nhau. Cậu muốn để lại màu gì trong khu vườn chung?”

**Milo at Square:** “Cậu thấy đài phun nước không? Đừng chỉ chụp đẹp — thử tìm một góc mà cậu sẽ muốn nhớ nhé!”

**Finn after placement:** “Hay thật. Từ giờ nơi này có một góc nhỏ mang dấu ấn của cậu.”

Dialogue above is **new sample content**, not previously approved canon; add localized keys during implementation.

## D. Repeatable play without busywork

Each in-game day offers only these optional, short reasons to return:
1. **Garden change:** water/tend/choose different flower appearance; an established flower doesn't die if ignored.
2. **Photo prompt:** one suggested daytime/evening landmark angle with new album sticker or decor palette swatch on first completion, no repeat farming.
3. **Resident moment:** one of the cast reacts to a recently changed village element. Dialogue line rotates from a small written bank; no deep procedural social AI.
4. **Cozy Corner remix:** re-arrange the approved public socket with already unlocked objects, no cost.
5. **Home plot build:** experiment with paths, edging, fences, planters and trees on purchased land; one resident-care activity per in-game day yields +25 VC toward adjacent land. No obligation to log in daily.

At the end of the W01 content, the village must still feel usable, even if there's no fresh story. Later regions are earned through future approved world content, not placeholder gates pretending to be open.

## E. Save and failure expectations

Store: character/avatar identity, world day/phase, 9 album stamps, 3 photo entries (or fallback card records), planter variety/growth, Cozy Corner selection/rotation, **Village Coins balance, purchase-event keys, owned plot IDs, owned piece inventory, piece positions/orientations/terrain styles and daily care reward flags**, NPC quest flags, village chapter completion, settings. Versioned save with deterministic load; a quit at any point never erases completed work. Repeated Talk/photo/plant inputs must not duplicate stamps or rewards.

No loss condition, locked-out progress, indefinite real-time wait, day resets that remove achievements, or stranded avatar outside nav boundary.

## F. Release-slice acceptance: exact player test

**20-minute new-user vertical loop:** From boot, a player can reach the village, talk to Pip, plant a flower, take a meaningful photo, place a furnishing, witness a friendly response and quit/reload to see those states preserved — without opening a board game.

**Land-building acceptance:** A new player earns exactly 100 VC from M01–M03, purchases the first adjacent parcel for 100 VC, can freely walk through the opened boundary, place, rotate, move and store at least two distinct construction objects, and reload with layout intact. A rejected purchase or invalid placement costs nothing; a repeated confirmation cannot charge twice. After buying, all four major village routes are still accessible.

**W01 content completion:** A new player can reach EVENING_TOGETHER and the visible evening gathering, with no dev console or undocumented input. Residents appear in all three time phases; one changed public item actually affects resident placement or remark. The park and main square are not empty dioramas.

**Exploration check:** No path blocked by building collision, non-playable scenery looks clearly non-playable, landmarks are visible from designed sightlines, route traversal validated on the actual greybox, all major UI actions are usable on tablet touch.

**Return check:** App restart retains album, garden, furnishing and chapter flags; 2 visits do not duplicate NPCs/props. Players can keep exploring when all quests are done.