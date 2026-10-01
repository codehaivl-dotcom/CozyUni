# CozyUni — World Asset Production Master v1.0

Status: **WORLD ASSET LIBRARY PLAN / LOCAL AI GENERATION SOURCE**

Purpose: define a complete, coherent exterior-world asset library that can later support the real CozyUni life-sim/world phase.

Important production boundary:
- The **world game itself is still deferred** by `COZYUNI_WORLD_BIBLE.md`.
- This document allows asset concepts to be generated locally in advance without implying that world coding should begin now.
- Current board-game production remains independent.
- Local generation agents may use this file pack-by-pack.

This document follows `docs/assets/00_RENDER_RULES_LOCKED.md`.

---

# 1. World target

The eventual CozyUni world must be capable of feeling like a real small life-sim world rather than a decorative game-selection lobby.

Target regions:
1. **Moonberry Village** — community core
2. **Countryside / Farms**
3. **Woodland / Meadow**
4. **Lake / Riverside**
5. **Town / Urban Quarter**
6. **Harbor / Seaside**
7. **Mountain / Cable-Car Region**
8. **Resort / Tourist District**

The asset library must support:
- walking/exploration
- recognizable neighborhoods
- NPC daily-life staging
- shops and public spaces
- transport
- collection activities
- light fishing/gardening/outdoor activities later
- seasonal dressing
- social/photo locations
- board-game venues later

The goal is **coverage and reuse**, not maximum asset count.

---

# 2. Canonical art direction shorthand

Use the locked Style D rules. Local generation agents may prepend this shorthand to asset prompts:

> **CozyUni Style D:** premium cozy stylized 3D game asset, soft chunky rounded forms, strong readable silhouette, clean color blocking, hand-painted PBR feel, warm cream/sage/muted-teal/coral/sunflower-yellow/natural-wood palette, clearly separated materials, moderate detail, family-friendly, real-time-game readable, AI-image-to-3D-friendly construction; never photorealistic, never clay/ceramic/porcelain, never washed-out beige, never cluttered.

For image-to-3D source renders:
- one object only unless explicitly marked `SET`
- complete object visible
- clean 3/4 front view by default
- neutral warm off-white background
- flat/simple ground contact
- soft studio shadow
- no people
- no background scene
- no tiny text/logo dependency
- no thin loose cables/chains/ropes
- no transparent hero geometry

Buildings must remain identifiable without relying on signs and must differ by silhouette, roof, facade, material, entrance/window language and functional hero feature.

---

# 3. Naming / local folder convention

Recommended local folders:

```text
Pack 01 — Shared Village Props
Pack 02 — Nature Core - Trees
Pack 03 — Bushes + Flowers + Ground Nature
Pack 04 — Food & Produce
Pack 05 — Vehicles & Transport Core
Pack 06 — Landmark & Civic Buildings
Pack 07 — Houses & Shops
Pack 08 — Infrastructure
Pack 09 — Parks & Recreation
Pack 10 — Farm & Countryside
...
Pack 26 — Hero Landmark Audit
```

Concept filename:

`P<pack>_<ID>_<slug>_concept.png`

Example:

`P10_FARM101_wheelbarrow_concept.png`

Do not mark an asset complete merely because a PNG exists. Local pipeline should separately track concept accepted -> 3D generated -> 3D QA accepted.

---

# 4. Existing local packs — KEEP / VERIFY, DO NOT BLINDLY REGENERATE

The user already has local generation folders corresponding to Packs 01–09. Treat these as the first source library and compare local files before generating replacements.

## PACK 01 — SHARED VILLAGE PROPS — EXISTING LOCAL

Known/core direction:
1. Wooden crate
2. Wooden barrel
3. Hand / utility cart
4. Parcel box
5. Village lantern
6. Wooden bench
7. Direction signpost
8. Flower planter / bucket
9. Produce basket
10. Firefly jar

Use: every region, shops, village, board dressing, later life-sim interactions.

## PACK 02 — NATURE CORE: TREES — EXISTING LOCAL

Core family:
1. Large oak
2. Rounded maple
3. Slender birch
4. Apple tree
5. Pear tree
6. Peach blossom tree
7. Cozy pine
8. Small willow
9. Decorative lantern tree
10. Twisted old village tree

## PACK 03 — BUSHES + FLOWERS + GROUND NATURE — EXISTING LOCAL

Core family:
1. Round bush
2. Tall hedge bush
3. Pink flowering bush
4. White flowering bush
5. Berry bush
6. Lavender patch
7. Daisy patch
8. Sunflower patch
9. Mushroom cluster
10. Reeds / cattails

## PACK 04 — FOOD & PRODUCE — EXISTING LOCAL

Existing library already covers much more than one ten-item pack, including:
- bread / croissant
- apple / strawberry
- carrot / pumpkin
- milk / cheese / honey
- fish
- eggs
- beef / sausage / ham
- cabbage / lettuce / bok choy / broccoli / cucumber / scallion

Do not regenerate these unless current renders fail Style D or 3D conversion.

## PACK 05 — VEHICLES & TRANSPORT CORE — EXISTING LOCAL

Core family:
1. Bicycle
2. Cargo tricycle / cargo bicycle
3. Cozy scooter
4. Tiny car
5. Small pickup
6. Shuttle bus
7. Delivery box truck
8. Small boat
9. Cable-car cabin
10. Tourist train

Vehicles must remain chunky and simplified; avoid realistic mechanical clutter.

## PACK 06 — LANDMARK & CIVIC BUILDINGS — EXISTING LOCAL

Expected/known directions include:
- train station
- ferry terminal
- lighthouse
- seaside hotel
- mountain lodge
- market hall
- library / cultural hall
- farm barn complex
- urban corner café / shop-house
- marina / yacht club

Verify local inventory before adding a duplicate.

## PACK 07 — HOUSES & SHOPS — EXISTING LOCAL

Existing concepts cover daily-life shops, services and specialty stores.

Core identities already discussed/generated include:
- bakery
- flower shop
- fish market
- general store
- produce market
- café / tea house
- bookshop
- pharmacy / clinic
- post office / parcel shop
- hardware / workshop
- toy shop
- pet shop
- laundry
- barber / salon
- tailor
- blacksmith
- gift / souvenir directions

Hard rule: do not create ten copies of one cottage with different signs.

## PACK 08 — INFRASTRUCTURE — EXISTING LOCAL

Existing library includes:
- stone bridge
- wooden bridge
- bus stop shelter
- train platform
- dock / pier
- street lamp
- road signpost
- fountain
- stairs
- cable-car / funicular structure
- road modules
- sidewalk / curb
- rail modules
- railway crossing
- tunnel portal
- retaining wall
- ferry gangway
- utility / service infrastructure
- harbor / mountain infrastructure

## PACK 09 — PARKS / SPORTS / OUTDOOR RECREATION — EXISTING LOCAL

Known library includes:
- gazebo / bandstand
- playground tower
- swing set
- picnic pavilion
- pergola
- outdoor café structure
- pond footbridge
- public game table
- outdoor stage
- skate ramp
- basketball
- mini football
- wall court
- volleyball
- table tennis
- archery
- mini golf
- climbing wall
- calisthenics
- batting cage

This is already broad enough for the first world pass.

---

# 5. PACK 10 — FARM & COUNTRYSIDE CORE — TODO

Goal: make countryside/farm areas feel functional rather than decorative.

1. `FARM101` — Chunky wooden wheelbarrow
2. `FARM102` — Watering can
3. `FARM103` — Farm tool rack with shovel + rake as one stable SET
4. `FARM104` — Hay bale stack, 3-bale compact SET
5. `FARM105` — Feed sack stack, 3 sacks
6. `FARM106` — Wooden produce cart
7. `FARM107` — Small chicken coop, no animals
8. `FARM108` — Farm water trough
9. `FARM109` — Compost bin / wooden compost box
10. `FARM110` — Simple greenhouse hut, chunky framed structure, no fragile glazing emphasis

Avoid thin fence meshes in this pack; fences should be engine-repeatable modules or existing infrastructure.

---

# 6. PACK 11 — LAKE / RIVERSIDE CORE — TODO

Goal: support fishing, picnic, walking and waterside identity.

1. `LAKE111` — Small wooden fishing dock module
2. `LAKE112` — Fishing rod stand / rod holder, chunky simplified
3. `LAKE113` — Fishing tackle box
4. `LAKE114` — Lifebuoy stand, thick ring + post
5. `LAKE115` — Rowboat / tiny lake boat
6. `LAKE116` — Riverside bench variant
7. `LAKE117` — Lily-pad cluster SET
8. `LAKE118` — Large riverside rock cluster
9. `LAKE119` — Small waterside shrine / marker
10. `LAKE120` — Picnic blanket + basket compact SET

Water itself is engine material, not an AI 3D asset.

---

# 7. PACK 12 — HARBOR / SEASIDE DRESSING — TODO

Goal: give the harbor a working-port and seaside-town feel without realistic industrial complexity.

1. `SEA121` — Harbor bollard
2. `SEA122` — Coiled thick mooring rope as compact prop
3. `SEA123` — Fish crate stack
4. `SEA124` — Lobster / fishing basket stack
5. `SEA125` — Harbor cargo handcart
6. `SEA126` — Small dockside crane, highly simplified chunky construction
7. `SEA127` — Navigation buoy / beacon
8. `SEA128` — Beach changing hut
9. `SEA129` — Beach umbrella + table compact SET
10. `SEA130` — Wooden beach chair / deck chair

No thin loose rigging or realistic ship machinery.

---

# 8. PACK 13 — MOUNTAIN / FOREST / CAMPING — TODO

Goal: create a convincing mountain route and outdoor activity zone.

1. `MTN131` — Camping tent, closed/simple form
2. `MTN132` — Campfire stone ring with stacked logs, no flame required in mesh
3. `MTN133` — Camping backpack placed on ground
4. `MTN134` — Trail marker post
5. `MTN135` — Mountain lookout telescope
6. `MTN136` — Log pile
7. `MTN137` — Fallen log
8. `MTN138` — Large tree stump
9. `MTN139` — Mountain boulder cluster
10. `MTN140` — Small trail shelter / hikers' hut

Fire, smoke and fog are VFX, not baked hero geometry.

---

# 9. PACK 14 — TOWN STREET / URBAN SERVICES — TODO

Goal: make the town quarter feel serviced and lived-in.

1. `URB141` — Public trash bin
2. `URB142` — Recycling station
3. `URB143` — Parcel locker kiosk
4. `URB144` — Ticket / transit kiosk
5. `URB145` — Parking meter
6. `URB146` — Fire hydrant
7. `URB147` — Utility cabinet
8. `URB148` — Public information board
9. `URB149` — Bicycle rack, thick simplified loops
10. `URB150` — Public drinking fountain

If any item already exists in Pack 08 locally, SKIP it and do not create a duplicate just to fill ten.

---

# 10. PACK 15 — RESIDENTIAL EXTERIOR / DAILY LIFE — TODO

Goal: make house areas believable enough for a later life-sim without requiring interiors.

1. `HOME151` — Mailbox on post
2. `HOME152` — Birdhouse
3. `HOME153` — Birdbath
4. `HOME154` — Porch bench
5. `HOME155` — Outdoor shoe / boot rack
6. `HOME156` — Small gardening tool box
7. `HOME157` — Pet water + food bowl SET
8. `HOME158` — Compact outdoor laundry basket
9. `HOME159` — Garden hose reel with hose simplified into one thick coherent form
10. `HOME160` — Small front-door welcome planter SET, no text

Do not generate full furnished interiors in this phase.

---

# 11. PACK 16 — SHOPFRONT & MARKET DRESSING — TODO

Goal: allow existing shops to feel functionally different without creating new buildings.

1. `SHOP161` — Produce display stand
2. `SHOP162` — Bakery bread display rack
3. `SHOP163` — Flower bucket display SET
4. `SHOP164` — Wooden merchandise shelf
5. `SHOP165` — Market scale
6. `SHOP166` — Chalkboard-shaped sign, blank surface, no text
7. `SHOP167` — Foldable market table / counter
8. `SHOP168` — Awning module, chunky curved canopy
9. `SHOP169` — Parcel trolley
10. `SHOP170` — Small shop crate-stack display

These should be modular and reusable by multiple shops.

---

# 12. PACK 17 — PARK / PLAZA / SOCIAL LIFE — TODO

Goal: fill the gap between large recreation structures and everyday social spaces.

1. `PARK171` — Picnic table
2. `PARK172` — Small round café table + 2 chairs SET
3. `PARK173` — Large square planter box
4. `PARK174` — Park map / notice kiosk, blank display
5. `PARK175` — Drinking fountain variant
6. `PARK176` — Public chess / board-game table
7. `PARK177` — Decorative low stone planter
8. `PARK178` — Small plaza clock on pedestal
9. `PARK179` — Community donation / book-swap box
10. `PARK180` — Photo spot frame / decorative standing frame

No text baked into signs.

---

# 13. PACK 18 — FESTIVAL / EVENT CORE — TODO

Goal: one reusable event kit that can dress the whole world seasonally without rebuilding environments.

1. `FEST181` — Festival entrance arch
2. `FEST182` — Small vendor booth
3. `FEST183` — Prize booth
4. `FEST184` — Festival drum
5. `FEST185` — Large gift pile
6. `FEST186` — Lantern cluster on chunky stand
7. `FEST187` — Banner pole with one thick fabric banner
8. `FEST188` — Balloon bouquet on solid weighted base; no loose strings
9. `FEST189` — Event trophy pedestal
10. `FEST190` — Small stage speaker / audio cabinet

Strings of lights/bunting should normally be engine splines or VFX rather than hero AI geometry.

---

# 14. PACK 19 — RESORT / TOURISM CORE — TODO

Goal: make tourist/resort district distinct from ordinary harbor/town.

1. `RES191` — Beach cabana
2. `RES192` — Resort deck chair
3. `RES193` — Resort parasol + side table SET
4. `RES194` — Hotel luggage trolley
5. `RES195` — Souvenir kiosk
6. `RES196` — Tourist photo-frame landmark
7. `RES197` — Hot-spring / stone soaking basin
8. `RES198` — Resort ticket booth
9. `RES199` — Scenic-view bench
10. `RES200` — Small resort welcome arch, no text

---

# 15. PACK 20 — TERRAIN / ROCK / CLIFF DRESSING — TODO

Goal: provide reusable 3D breakup pieces around engine-built terrain.

1. `TER201` — Large rounded boulder
2. `TER202` — Medium 3-rock cluster
3. `TER203` — Mossy rock cluster
4. `TER204` — Flat stepping-stone SET
5. `TER205` — Cliff-edge cap rock module
6. `TER206` — Cliff-side rock module
7. `TER207` — Cave entrance rock arch
8. `TER208` — Riverbank rock cluster
9. `TER209` — Snow-capped mountain rock
10. `TER210` — Small pebble/gravel cluster SET

Do not attempt to generate the entire world terrain as one AI model.

---

# 16. PACK 21 — WORLD INTERACTION PROPS — TODO

Goal: future life-sim interaction points that are obvious from gameplay distance.

1. `INT211` — Community notice board
2. `INT212` — Wishing well
3. `INT213` — Donation box / community chest
4. `INT214` — Public telescope
5. `INT215` — Collection display cabinet / outdoor collection stand
6. `INT216` — Fishing spot marker
7. `INT217` — Gardening pot / planting bed module
8. `INT218` — Lost-and-found chest
9. `INT219` — Bell / town interaction bell on sturdy stand
10. `INT220` — Photo booth / camera stand structure

These are interaction anchors; UI prompt is engine-generated.

---

# 17. PACK 22 — COLLECTIBLES / WORLD FINDS — TODO

Goal: small discoverable objects for future collection loops. Keep silhouettes exaggerated enough for visibility.

1. `COL221` — Large stylized seashell
2. `COL222` — Spiral seashell
3. `COL223` — Fossil stone / fossil chunk
4. `COL224` — Large acorn
5. `COL225` — Pinecone
6. `COL226` — Rare mushroom
7. `COL227` — Berry bundle
8. `COL228` — Flower bouquet
9. `COL229` — Message bottle, opaque stylized glass look without transparency dependency
10. `COL230` — Small treasure / keepsake box

Collectibles may later use runtime glow; do not bake glow into geometry.

---

# 18. PACK 23 — WORK / UTILITY / MAINTENANCE — TODO

Goal: support NPC jobs and world storytelling without complex machinery.

1. `WORK231` — Toolbox
2. `WORK232` — Broom + dustpan stable SET
3. `WORK233` — Cleaning bucket
4. `WORK234` — Hand truck / dolly
5. `WORK235` — Paint bucket + thick brush SET
6. `WORK236` — Wood-cutting stump with logs, no axe embedded if unsafe for reconstruction
7. `WORK237` — Sack pile
8. `WORK238` — Fishing supply crate
9. `WORK239` — Delivery parcel stack
10. `WORK240` — Gardener's wheel cart / garden trolley

---

# 19. PACK 24 — TRANSIT & TRAVEL DETAIL — TODO

Goal: turn existing train/ferry/bus/cable-car infrastructure into believable travel locations.

1. `TRV241` — Ticket machine
2. `TRV242` — Route-map stand, blank display surface
3. `TRV243` — Platform bench
4. `TRV244` — Luggage trolley
5. `TRV245` — Suitcase stack
6. `TRV246` — Baggage scale
7. `TRV247` — Travel sign totem, icons only / no text required
8. `TRV248` — Ferry life-ring stand
9. `TRV249` — Platform clock on sturdy post
10. `TRV250` — Small station parcel cart

Skip anything already covered well by Pack 08.

---

# 20. PACK 25 — SEASONAL DRESSING BASE — TODO

Goal: low-cost world transformation across seasons/events.

1. `SEA251` — Spring flower arch
2. `SEA252` — Spring flower basket cluster
3. `SEA253` — Summer lemonade / juice stand, no text
4. `SEA254` — Autumn leaf pile
5. `SEA255` — Pumpkin harvest display
6. `SEA256` — Hay / harvest decoration stack
7. `SEA257` — Snowman
8. `SEA258` — Winter gift stack
9. `SEA259` — Large holiday wreath on simple stand
10. `SEA260` — Seasonal lantern tree / decorated small tree

Snow cover, falling leaves, rain and lighting are shaders/VFX, not separate geometry packs.

---

# 21. PACK 26 — HERO LANDMARK AUDIT — CONDITIONAL

This pack is **not an automatic generation queue**. First compare Pack 06/07 local assets. Generate only missing hero landmarks needed to give the eight world regions strong identities.

Candidate landmark slots:

1. `HERO261` — Moonberry Town Hall / Mayor Hall
2. `HERO262` — Central Market Hall
3. `HERO263` — Grand Train Station
4. `HERO264` — Harbor Ferry Terminal
5. `HERO265` — Lighthouse
6. `HERO266` — Countryside Windmill
7. `HERO267` — Mountain Lodge
8. `HERO268` — Cable-Car Station
9. `HERO269` — Seaside Hotel
10. `HERO270` — Marina / Yacht Club

Rules:
- If an acceptable version already exists locally: **SKIP**.
- Every generated landmark must have a clearly different silhouette.
- No two hero buildings may share the same roof/massing grammar with only color/sign changes.

---

# 22. REGION COVERAGE MATRIX

Use this matrix to assemble future zones from the asset library rather than generating region-specific duplicates.

| Region | Primary packs |
|---|---|
| Moonberry Village | 01, 02, 03, 07, 08, 15, 16, 17, 21 |
| Countryside / Farms | 02, 03, 04, 06, 10, 20, 23 |
| Woodland / Meadow | 02, 03, 13, 20, 21, 22 |
| Lake / Riverside | 02, 03, 11, 20, 21, 22 |
| Town / Urban Quarter | 06, 07, 08, 14, 16, 17, 23, 24 |
| Harbor / Seaside | 05, 06, 08, 12, 19, 20, 24 |
| Mountain / Cable Car | 02, 05, 08, 13, 20, 24 |
| Resort / Tourist | 05, 06, 17, 18, 19, 24, 25 |

One asset may appear in multiple regions. Reuse is intentional.

---

# 23. WORLD ASSET CATEGORIES THAT SHOULD BE BUILT IN ENGINE, NOT AI-RENDERED AS MONOLITHIC OBJECTS

Do not spend generation credits on whole-world structures that are easier to author procedurally/modularly:

- terrain heightfield
- entire mountain ranges
- whole lake/ocean water surfaces
- world sky
- grass fields
- full road network
- full rail network
- sidewalks as a whole city mesh
- rivers as one mesh
- snow/rain/fog volumes
- huge fence networks
- power/telephone wires
- bunting/light strings spanning streets
- full village/world diorama
- text-heavy road signs

Use engine terrain, splines, shaders, repeated modules and decals for these.

AI→3D is for recognizable standalone objects and modular hero pieces.

---

# 24. AI GENERATION PRIORITY WAVES

The local agent may generate in this order.

## Wave A — Highest reuse / daily-life density

Generate first if missing:
- Pack 10 Farm & Countryside
- Pack 15 Residential Exterior
- Pack 16 Shopfront & Market Dressing
- Pack 20 Terrain / Rock Dressing
- Pack 21 World Interaction Props
- Pack 23 Work / Utility

Reason: these assets make existing buildings/nature immediately feel more alive.

## Wave B — Region identity

Then:
- Pack 11 Lake / Riverside
- Pack 12 Harbor / Seaside
- Pack 13 Mountain / Camping
- Pack 14 Urban Services
- Pack 19 Resort / Tourism
- Pack 24 Transit Detail

## Wave C — Retention / atmosphere

Then:
- Pack 18 Festival
- Pack 22 Collectibles
- Pack 25 Seasonal Dressing

## Wave D — Hero gap repair

Finally:
- Pack 26 only after checking the existing hero-building inventory.

Do not regenerate Packs 01–09 wholesale unless their current concepts fail Style D or image-to-3D QA.

---

# 25. PER-ASSET GENERATION TEMPLATE FOR LOCAL AGENT

Use:

```text
Create exactly ONE isolated asset:
[ASSET NAME + FUNCTION]

CozyUni Style D: premium cozy stylized 3D game asset, soft chunky rounded forms, strong readable silhouette, clean color blocking, hand-painted PBR feel, warm cream/sage/muted-teal/coral/sunflower-yellow/natural-wood palette, clearly separated materials, moderate detail, family-friendly, real-time-game readable, AI-image-to-3D-friendly construction.

Material rule: NOT clay, NOT ceramic, NOT porcelain, NOT wax, NOT monochrome beige. Use visibly distinct painted wood/plaster/stone/matte-metal/fabric materials appropriate to the asset.

Image-to-3D source render: one object only, centered, complete object visible, clean 3/4 front view, neutral warm off-white background, flat/simple ground contact, soft studio shadow, even lighting, no people, no environment, no text/logo, no cropped parts, no thin loose cables/chains/ropes, no transparent hero geometry.

The asset must read clearly from an isometric life-sim/gameplay camera and remain physically coherent as a standalone 3D model.
```

For plants/trees: explicitly require trunk/base visible.
For vehicles: wheels and underside readable.
For buildings: add unique silhouette / roof / massing / entrance / facade rule.

---

# 26. LOCAL AGENT PACK PROTOCOL

For each pack:

1. Read the whole pack before generating.
2. Compare local files first.
3. Skip any already-accepted asset with the same functional role.
4. Generate **one image per asset**, never a contact sheet unless explicitly requested.
5. Do not add filler assets to make a pack look larger.
6. Validate Style D before moving to image-to-3D.
7. Reject clay/ceramic/waxy/washed-out outputs even if geometry is clean.
8. Reject assets with hidden bases, cropped silhouettes or merged background props.
9. Preserve pack and asset IDs in filenames.
10. Keep generation local; this markdown is the shared planning source, not a requirement to commit generated images to Git.

---

# 27. COMPLETENESS TARGET

The purpose of this master is not to guarantee that every listed asset ships.

A first convincing CozyUni world should be possible when the library has:
- 10+ usable residents/characters
- 15–25 distinct buildings/landmarks
- 20+ tree/bush/flower variants
- 20+ food/produce objects
- 10+ vehicles/transport objects
- 25+ infrastructure modules/props
- 20+ park/recreation objects
- 60+ small daily-life/shop/work/interactable props
- 20+ region-specific lake/harbor/mountain/resort props
- 10+ seasonal/event dressing objects
- 10+ collectibles/world finds

The Packs 01–26 plan is intentionally enough to exceed that baseline while keeping most assets reusable.

**Do not judge completeness by raw asset count. A smaller library assembled coherently with strong region identity is better than hundreds of unrelated AI props.**
