# CozyUni — Game-First Render Priority v0.1

Status: **CURRENT PRODUCTION PRIORITY**

This document supersedes the old broad asset checklist as the active render order.

Principle: **do not render more world assets just because credits exist. Render assets when an active game needs them, or when the asset has very high reuse value in the Cozy World / Life Hub.**

---

## 1. Existing world library — REUSE FIRST

The project already has enough concept-rendered world content to start building a lively explorable hub.

### Characters
Existing approved/candidate cast includes:
- Rabbit
- Poppy Bear
- Milo Dog
- Lumi Cat
- Mayor Pip Hedgehog
- Fox
- Duck
- Sheep
- additional Dog
- Koala
- Panda

### Shared village props
Examples already rendered:
- wooden crate
- barrel
- hand/utility cart
- parcel box
- village lantern
- bench
- direction signpost
- flower planter/bucket
- produce basket
- firefly jar

### Nature
Existing families include:
- multiple hero tree silhouettes
- fruit/blossom trees
- pine/willow/old tree variants
- bushes and hedges
- flowering bushes
- berry bush
- lavender/daisy/sunflower patches
- mushrooms
- reeds/cattails

### Food / produce
Existing concepts cover many useful world/game items:
- bread/croissant
- apples/strawberries/carrots/pumpkin
- milk/cheese/honey
- fish
- eggs
- meat/sausages/ham
- cabbage/lettuce/bok choy/broccoli/cucumber/scallion

### Vehicles / transport
Existing corrected Style-D concepts include:
- bicycle
- cargo bicycle/tricycle
- scooter
- small car
- pickup
- shuttle bus
- delivery truck
- small boat
- cable car cabin
- tourist train

Additional reserve concepts exist for luxury/tourist transport and boats. They should only be produced when a real module/region needs them.

### Buildings / shops
The library already covers:
- civic/landmark architecture
- station/terminal/lighthouse/hotel/lodge/market/library/barn/café/marina directions
- additional public/cultural/service buildings
- daily-life village shops
- service/town shops
- specialty shop concepts

Do not commission more generic houses/buildings until a world zone or game specifically requires them.

### Infrastructure
Existing concepts include:
- stone and wooden bridges
- bus stop
- train platform
- dock/pier
- street lamp
- direction sign
- fountain
- stairs
- cable-car/funicular structures
- road straight/curve/intersection
- sidewalk/curb
- rail straight/curve
- railway crossing
- tunnel
- retaining wall
- ferry gangway
- urban service props
- harbor/mountain infrastructure

### Parks / recreation
Existing concepts include:
- gazebo/bandstand
- playground tower
- swings
- picnic pavilion
- pergola
- outdoor café kiosk
- garden footbridge
- chess/game table
- outdoor stage
- skate ramp
- basketball
- mini soccer
- tennis practice
- volleyball
- table tennis
- archery
- mini golf
- climbing wall
- calisthenics
- batting cage

**Conclusion:** the world backbone is already broad. The next production priority is game-specific interaction art, not more generic environment volume.

---

# 2. World-use plan for the existing assets

The current asset library should be assembled into a **Cozy World / Life Hub** with an Animal-Crossing-like atmosphere but a much smaller feature scope.

Use existing assets to build:
- Moonberry Village core
- countryside/farm edge
- park and recreation district
- town/service street
- station/transit district
- harbor/seaside district
- mountain/cable-car district

World goals:
- pleasant walking/exploration
- recognizable destinations
- game entrances/venues
- ambient NPCs
- transport transitions
- photo-friendly scenes
- light seasonal dressing later

Do not wait for perfect interiors. Most buildings can initially function as exterior landmarks, portals or background destinations.

---

# 3. ZERO-CREDIT / ENGINE-FIRST CONTENT

Do not render these as monolithic 3D assets:
- Ludo board/path
- Checkers board
- Chess board
- Goose/Journey path board
- Tycoon board
- board text
- card faces
- money values
- ownership colors
- movement arrows/highlights
- special-space icons

These should be generated in engine/UI so rules and layout can change without re-rendering art.

---

# 4. Priority P0 — Shared Board Game Kit

Render these before large game-specific packs because several games can reuse them.

### P0.1 — Cozy six-sided dice
Use: Cozy Ludo, Cozy Journey, Cozy Tycoon, future dice games.

Requirements:
- chunky rounded cube
- clear pips
- no text/logo
- Style D
- easy physics/animation

### P0.2 — Winner trophy
Use: every game results screen / Life Hub display.

### P0.3 — First-player / turn marker
Use: multiple tabletop games.

Possible design: simple berry/leaf/crown marker; one solid object.

### P0.4 — Universal reward/star token
Use: results, achievements, festival/life-hub rewards.

### P0.5 — Cozy coin / berry coin
Use: Cozy Tycoon and optional world reward presentation.

**P0 total new renders: approximately 5.**

Do not force a 10-image pack.

---

# 5. Priority P1 — Cozy Ludo Asset Kit

Goal: first low-risk family prototype.

Reuse existing animal characters as player identity and, if rig/scale works well, as moving board pieces.

### Render only if needed
1. **Finish Pavilion / Home Goal** — one hero destination object.
2. **Safe-Space Marker** — simple flower/berry pad or small shrine marker.
3. **Shortcut Gate** — compact readable arch/gate.
4. **Celebration Trophy** — reuse P0 trophy; no new render.
5. **Lucky Gift Box** — reuse existing gift/parcel concept if suitable.
6. **Fallback Pawn** — only render if full characters are too large/noisy for board readability.

Possible fallback pawn strategy:
- one generic pawn shape
- runtime recolor by player
- animal icon appears in UI rather than requiring four unique models

**Expected new renders after reuse: ~2–4.**

---

# 6. Priority P2 — Cozy Journey / Goose-Family Kit

This should reuse Ludo's Path Board Engine and the existing transport/world library.

Existing world assets already cover much of the fantasy:
- train
- station/platform
- boat/dock/ferry structures
- cable car/funicular
- bridges
- roads
- signposts
- picnic/park structures

### Potential new renders
1. **Journey Destination Gate** — final festive/world-tour destination.
2. **Travel Suitcase Token** — compact, reusable in world hub.
3. **Rest/Picnic Marker** — only if existing picnic assets are too large.
4. **Travel Trophy / Passport Stamp Object** — optional; preferably UI rather than 3D.

Special spaces should mainly use icons + existing world props.

**Expected new renders: ~2–3.**

---

# 7. Priority P3 — Cozy Checkers Kit

Board is procedural.

### New renders
1. **Checker Piece** — one strong round/chunky piece model.
2. **King/Crown Topper** — optional separate topper or elevated variant.

Player sides use runtime materials/colors.

Optional:
3. **Board-side decorative marker** — only if visual tests show the game feels too sterile.

**Expected new renders: 2–3.**

---

# 8. Priority P4 — Cozy Chess Kit

Board is procedural.

Render six unique piece archetypes only:
1. King
2. Queen
3. Bishop
4. Knight
5. Rook
6. Pawn

Rules:
- same material language across all six
- strong silhouettes
- no thin fragile ornaments
- avoid over-detailed medieval sculpture
- runtime recolor/material differentiates players

Optional world reuse:
- enlarged versions can decorate the Chess Garden / club exterior.

**Expected new renders: exactly 6 core pieces.**

---

# 9. Priority P5 — Cozy Tycoon Kit

Do not begin until economy/gameplay research is approved.

Reuse existing buildings as property identities. Never render one new building per property.

### Candidate new 3D assets only after rules are locked
1. Coin stack / coin bag
2. Ownership/development marker
3. Small shop-upgrade marker
4. Major-development/landmark marker
5. Auction gavel
6. Bank/treasury chest
7. Transport ticket/token
8. Player token fallback if existing characters are not appropriate

Cards, deeds, prices, rent tables and event text are UI/2D assets.

**Expected new 3D renders: ~5–8, not dozens.**

---

# 10. Priority P6 — Life Hub enrichment only after first game prototype

If the world feels empty after assembling the existing library, render only small high-reuse outdoor interaction assets.

Candidate pack:
- mailbox
- birdhouse
- birdbath
- watering can
- picnic blanket/basket variant
- outdoor café table set
- small public notice board
- simple clothesline
- dog/pet water bowl
- small decorative rock cluster

These are intentionally easy AI→3D objects and can make the hub feel lived-in without requiring interiors.

Do not make this pack before checking the assembled world first.

---

# 11. Recommended actual render order

1. P0 shared dice
2. P0 trophy
3. P0 turn marker
4. P0 reward/star token
5. P0 cozy coin
6. Cozy Ludo finish pavilion
7. Cozy Ludo safe-space marker
8. Cozy Ludo shortcut gate
9. Test first Ludo prototype
10. Only then produce the next game kit actually entering implementation

Do not render Chess, Tycoon and Journey kits in advance merely because they are listed here.

---

# 12. Asset ROI rule

Before rendering any new asset, classify it:

### A — Mandatory gameplay
The prototype cannot function/read correctly without it.

### B — High-reuse world asset
Useful across multiple games/regions and visibly improves the Life Hub.

### C — Cosmetic polish
Nice but not necessary.

Render order is always:
**A → B → C.**

If an asset is C and the current game is not yet fun, do not render it.
