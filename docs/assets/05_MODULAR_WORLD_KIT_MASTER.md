# CozyUni — Modular Worldbuilding Kit Master

Status: READY FOR LOCAL GENERATION
Purpose: create an **infinite modular kit** in the same CozyUni art style so the agent can assemble villages, town centers, rail areas, harbor zones, parks, mountain areas, lakefronts, and board-game-like overworld spaces without inventing missing parts.

---

## 1. Core production goal

This file defines the **modular building blocks** of the CozyUni world.
Unlike hero buildings or one-off props, these assets are meant to:

- repeat cleanly
- snap together easily
- support many map layouts
- share the same art style as the approved CozyUni references
- be readable from a high 3/4 isometric life-sim camera
- be simple enough for AI image-to-3D workflows

This is the kit that makes the world scalable.

---

## 2. Style lock (must apply to every asset)

### CozyUni Style D — mandatory

- premium cozy stylized 3D game asset
- soft rounded geometry
- clean readable silhouette
- charming but not childish
- hand-painted PBR feeling
- bright but controlled palette
- clear material separation
- simplified detail suitable for gameplay camera
- game-ready proportions
- suitable for AI image-to-3D conversion

### Material rule

Must read clearly as:
- painted wood
- natural wood
- stone
- plaster
- painted metal
- glass
- foliage
- dirt / grass / cobble / sand

Must **NOT** look like:
- clay
- ceramic
- porcelain
- wax
- monochrome beige mass
- toy plastic
- muddy generic blob

### Composition rule for generation renders

For each asset render:
- exactly one asset per image unless the asset is a stable SET
- centered
- full object visible
- clean neutral background
- no extra environment scene
- no text labels
- no characters
- no unnecessary clutter

For modular ground pieces:
- top and side planes must be readable
- edges must be visible
- silhouette must show module shape clearly

---

## 3. Engine-built vs asset-built

### Engine-built (do not waste render budget)
These are handled by engine materials / terrain / paint systems:

- terrain blend layers
- grass painting
- foliage scatter
- decal placement
- water surface behavior
- fog / lighting
- spline placement
- repetition of modular parts

### Asset-built (must be rendered)
These require render assets:

- path modules
- road modules
- curb modules
- retaining walls
- stair modules
- bridge modules
- dock modules
- rail modules
- platform modules
- cliff / rock modules
- border / edge modules
- plaza floor modules
- canal / harbor edge modules

---

## 4. Generation template — single modular asset

Use this prompt structure for each asset:

```text
Create exactly ONE isolated modular game asset: <ASSET ID — NAME>.

Target style: CozyUni Style D — premium cozy stylized 3D life-sim game asset, soft rounded forms, clean readable silhouette, slightly exaggerated proportions, hand-painted PBR feeling, polished and game-ready, readable from a high 3/4 isometric camera.

Material rule: clear material separation. NOT clay, NOT ceramic, NOT porcelain, NOT wax, NOT monochrome beige, NOT toy plastic. The asset must clearly read as wood, stone, painted metal, dirt, grass, or foliage depending on the design.

Modular rule: this asset is part of an infinite worldbuilding kit. The module must be simple, snap-friendly, readable from above, and easy to repeat. Top plane, edges, and side planes must be clearly visible.

Image-to-3D source render: one object only, centered, full object visible, isolated on a clean neutral background, no extra scene, no text, no characters, no clutter.
```

### Extra prompt tags by category

- Ground tile: `tileable feel, clean edges, readable top surface, slight bevel, stable footprint`
- Border / curb: `straight modular edge, repeatable segment, clean side profile`
- Stair: `clear steps, even rhythm, sturdy footprint`
- Rock / cliff: `stackable terrain module, broad readable shape, no noisy micro-detail`
- Bridge / dock: `structurally readable, clear walkway plane, clean support silhouette`
- Rail: `modular track piece, readable sleeper rhythm, clean alignment`

---

## 5. Category plan

This master kit is split into 12 modular packs.

1. Ground Base Tiles
2. Paths & Roads
3. Borders & Curbs
4. Plaza & Floor Surfaces
5. Rock & Cliff Modules
6. Stairs & Ramps
7. Fences & Boundaries
8. Bridges & Water Crossings
9. Harbor & Canal Modules
10. Rail & Transit Modules
11. Grass / Garden / Planter Borders
12. Utility Terrain Details

---

# 6. MASTER CHECKLIST

---

## PACK 01 — Ground Base Tiles (24)

Purpose: base surfaces used under all world zones.

- [ ] MOD001 — Soft Grass Tile A
- [ ] MOD002 — Soft Grass Tile B
- [ ] MOD003 — Wild Meadow Grass Tile
- [ ] MOD004 — Worn Grass Tile
- [ ] MOD005 — Warm Dirt Tile A
- [ ] MOD006 — Warm Dirt Tile B
- [ ] MOD007 — Muddy Dirt Tile
- [ ] MOD008 — Sandy Soil Tile
- [ ] MOD009 — Fine Gravel Tile
- [ ] MOD010 — Pebble Ground Tile
- [ ] MOD011 — Cobblestone Tile A
- [ ] MOD012 — Cobblestone Tile B
- [ ] MOD013 — Old Stone Paving Tile A
- [ ] MOD014 — Old Stone Paving Tile B
- [ ] MOD015 — Brick Paving Tile A
- [ ] MOD016 — Brick Paving Tile B
- [ ] MOD017 — Wooden Deck Tile A
- [ ] MOD018 — Wooden Deck Tile B
- [ ] MOD019 — Boardwalk Tile A
- [ ] MOD020 — Boardwalk Tile B
- [ ] MOD021 — Plaza Stone Tile A
- [ ] MOD022 — Plaza Stone Tile B
- [ ] MOD023 — Harbor Stone Slab Tile
- [ ] MOD024 — Mountain Path Tile

---

## PACK 02 — Paths & Roads (32)

Purpose: loop roads, pedestrian paths, village lanes, city streets.

- [ ] MOD025 — Narrow Dirt Path Straight
- [ ] MOD026 — Narrow Dirt Path Curve
- [ ] MOD027 — Narrow Dirt Path T-Junction
- [ ] MOD028 — Narrow Dirt Path Crossroad
- [ ] MOD029 — Cobble Path Straight
- [ ] MOD030 — Cobble Path Curve
- [ ] MOD031 — Cobble Path T-Junction
- [ ] MOD032 — Cobble Path Crossroad
- [ ] MOD033 — Old Stone Path Straight
- [ ] MOD034 — Old Stone Path Curve
- [ ] MOD035 — Old Stone Path T-Junction
- [ ] MOD036 — Old Stone Path Crossroad
- [ ] MOD037 — Village Road Straight Narrow
- [ ] MOD038 — Village Road Curve Narrow
- [ ] MOD039 — Village Road Straight Wide
- [ ] MOD040 — Village Road Curve Wide
- [ ] MOD041 — Village Road T-Junction
- [ ] MOD042 — Village Road Crossroad
- [ ] MOD043 — Road End Cap A
- [ ] MOD044 — Road End Cap B
- [ ] MOD045 — Alley Path Straight
- [ ] MOD046 — Alley Path Curve
- [ ] MOD047 — Puddle Path Straight
- [ ] MOD048 — Mud Hazard Path Segment
- [ ] MOD049 — Wooden Plank Path Straight
- [ ] MOD050 — Wooden Plank Path Curve
- [ ] MOD051 — Slope Path Up A
- [ ] MOD052 — Slope Path Up B
- [ ] MOD053 — Boardwalk Street Straight
- [ ] MOD054 — Boardwalk Street Curve
- [ ] MOD055 — Shared Street Junction
- [ ] MOD056 — Round Corner Plaza Road Tile

---

## PACK 03 — Borders & Curbs (26)

Purpose: transition edges between path, road, grass, water, raised surfaces.

- [ ] MOD057 — Stone Curb Straight A
- [ ] MOD058 — Stone Curb Straight B
- [ ] MOD059 — Stone Curb Outer Corner
- [ ] MOD060 — Stone Curb Inner Corner
- [ ] MOD061 — Stone Curb T-Junction
- [ ] MOD062 — Wooden Border Straight
- [ ] MOD063 — Wooden Border Corner
- [ ] MOD064 — Grass-to-Road Edge Straight
- [ ] MOD065 — Grass-to-Road Edge Curve
- [ ] MOD066 — Dirt-to-Road Edge Straight
- [ ] MOD067 — Dirt-to-Road Edge Curve
- [ ] MOD068 — Plaza Edge Straight
- [ ] MOD069 — Plaza Edge Corner
- [ ] MOD070 — Canal Edge Straight
- [ ] MOD071 — Canal Edge Corner
- [ ] MOD072 — Harbor Edge Straight
- [ ] MOD073 — Harbor Edge Corner
- [ ] MOD074 — Retaining Wall Top Edge A
- [ ] MOD075 — Retaining Wall Top Edge B
- [ ] MOD076 — Cliff Edge Grass Cap
- [ ] MOD077 — Cliff Edge Stone Cap
- [ ] MOD078 — Planter Border Straight
- [ ] MOD079 — Planter Border Corner
- [ ] MOD080 — Flowerbed Border Straight
- [ ] MOD081 — Flowerbed Border Corner
- [ ] MOD082 — Low Embankment Edge

---

## PACK 04 — Plaza & Floor Surfaces (20)

Purpose: focal public areas, squares, stations, market grounds.

- [ ] MOD083 — Small Town Plaza Tile A
- [ ] MOD084 — Small Town Plaza Tile B
- [ ] MOD085 — Large Square Plaza Tile A
- [ ] MOD086 — Large Square Plaza Tile B
- [ ] MOD087 — Market Court Floor Tile
- [ ] MOD088 — Festival Stage Floor Tile
- [ ] MOD089 — Station Platform Floor Tile
- [ ] MOD090 — Ferry Terminal Floor Tile
- [ ] MOD091 — Harbor Warehouse Floor Tile
- [ ] MOD092 — Museum Courtyard Floor Tile
- [ ] MOD093 — Café Terrace Floor Tile
- [ ] MOD094 — Garden Court Floor Tile
- [ ] MOD095 — Brick Terrace Tile
- [ ] MOD096 — Stone Terrace Tile
- [ ] MOD097 — Covered Arcade Floor Tile
- [ ] MOD098 — Indoor-Outdoor Pavilion Floor Tile
- [ ] MOD099 — Alpine Lookout Floor Tile
- [ ] MOD100 — Board Game Town Square Tile
- [ ] MOD101 — Scenic Viewpoint Floor Tile
- [ ] MOD102 — Chess Garden Floor Tile

---

## PACK 05 — Rock & Cliff Modules (28)

Purpose: terrain shaping and elevation.

- [ ] MOD103 — Small Rock Cluster A
- [ ] MOD104 — Small Rock Cluster B
- [ ] MOD105 — Medium Rock Cluster A
- [ ] MOD106 — Medium Rock Cluster B
- [ ] MOD107 — Mossy Boulder A
- [ ] MOD108 — Mossy Boulder B
- [ ] MOD109 — Flat Stepping Rock A
- [ ] MOD110 — Flat Stepping Rock B
- [ ] MOD111 — Cliff Wall Straight A
- [ ] MOD112 — Cliff Wall Straight B
- [ ] MOD113 — Cliff Wall Straight C
- [ ] MOD114 — Cliff Outer Corner
- [ ] MOD115 — Cliff Inner Corner
- [ ] MOD116 — Cliff End Cap
- [ ] MOD117 — Cliff Top Cap A
- [ ] MOD118 — Cliff Top Cap B
- [ ] MOD119 — Layered Stone Ledge A
- [ ] MOD120 — Layered Stone Ledge B
- [ ] MOD121 — Rubble Pile A
- [ ] MOD122 — Rubble Pile B
- [ ] MOD123 — Alpine Stone Outcrop
- [ ] MOD124 — Harbor Seawall Rock Base
- [ ] MOD125 — Canal Retaining Rock Base
- [ ] MOD126 — Grass Cliff Mini Segment
- [ ] MOD127 — Stone Ridge Segment
- [ ] MOD128 — Slope Boulder Barrier
- [ ] MOD129 — Decorative Ruined Stone Chunk
- [ ] MOD130 — Cave Mouth Cliff Frame

---

## PACK 06 — Stairs & Ramps (18)

Purpose: readable elevation change modules.

- [ ] MOD131 — Stone Stair Straight Short
- [ ] MOD132 — Stone Stair Straight Long
- [ ] MOD133 — Stone Stair Wide
- [ ] MOD134 — Stone Stair Outer Corner
- [ ] MOD135 — Stone Stair Inner Corner
- [ ] MOD136 — Brick Stair Short
- [ ] MOD137 — Brick Stair Long
- [ ] MOD138 — Wooden Stair Short
- [ ] MOD139 — Wooden Stair Long
- [ ] MOD140 — Harbor Ramp Straight
- [ ] MOD141 — Harbor Ramp Wide
- [ ] MOD142 — Market Ramp Straight
- [ ] MOD143 — Park Ramp Straight
- [ ] MOD144 — Alpine Ramp Stone
- [ ] MOD145 — Boardwalk Ramp
- [ ] MOD146 — Station Ramp Module
- [ ] MOD147 — Funicular Access Ramp
- [ ] MOD148 — Low Plaza Step Module

---

## PACK 07 — Fences & Boundaries (22)

Purpose: soft spatial organization, not hard enclosure everywhere.

- [ ] MOD149 — Low Wooden Fence Straight
- [ ] MOD150 — Low Wooden Fence Corner
- [ ] MOD151 — Low Wooden Fence Gate Segment
- [ ] MOD152 — Painted Picket Fence Straight
- [ ] MOD153 — Painted Picket Fence Corner
- [ ] MOD154 — Stone Post Fence Straight
- [ ] MOD155 — Stone Post Fence Corner
- [ ] MOD156 — Rope Dock Barrier Straight
- [ ] MOD157 — Rope Dock Barrier Corner
- [ ] MOD158 — Metal Rail Straight
- [ ] MOD159 — Metal Rail Corner
- [ ] MOD160 — Plaza Safety Rail Straight
- [ ] MOD161 — Plaza Safety Rail Corner
- [ ] MOD162 — Garden Hedge Straight
- [ ] MOD163 — Garden Hedge Corner
- [ ] MOD164 — Flower Planter Divider
- [ ] MOD165 — Canal Guard Rail Straight
- [ ] MOD166 — Canal Guard Rail Corner
- [ ] MOD167 — Alpine Safety Fence Straight
- [ ] MOD168 — Alpine Safety Fence Corner
- [ ] MOD169 — Bus Stop Queue Rail
- [ ] MOD170 — Festival Crowd Barrier

---

## PACK 08 — Bridges & Water Crossings (18)

Purpose: rivers, canals, streams, garden crossings.

- [ ] MOD171 — Small Wooden Footbridge Straight
- [ ] MOD172 — Small Wooden Footbridge Arched
- [ ] MOD173 — Stone Garden Bridge Straight
- [ ] MOD174 — Stone Garden Bridge Arched
- [ ] MOD175 — Narrow Canal Bridge Straight
- [ ] MOD176 — Narrow Canal Bridge Arched
- [ ] MOD177 — Village Creek Bridge
- [ ] MOD178 — Plaza Water Bridge
- [ ] MOD179 — Boardwalk Connector Bridge
- [ ] MOD180 — Harbor Service Bridge
- [ ] MOD181 — Decorative Park Bridge
- [ ] MOD182 — Stepping Stone Crossing Set
- [ ] MOD183 — Culvert Crossing Module
- [ ] MOD184 — Mountain Stream Bridge
- [ ] MOD185 — Pedestrian Overpass Segment
- [ ] MOD186 — Transit Footbridge Segment
- [ ] MOD187 — Bridge Entry Cap A
- [ ] MOD188 — Bridge Entry Cap B

---

## PACK 09 — Harbor & Canal Modules (20)

Purpose: seaside town, marina, lakefront, ferry zone.

- [ ] MOD189 — Wooden Dock Straight A
- [ ] MOD190 — Wooden Dock Straight B
- [ ] MOD191 — Wooden Dock Corner Outer
- [ ] MOD192 — Wooden Dock Corner Inner
- [ ] MOD193 — Dock T-Junction
- [ ] MOD194 — Small Pier End Cap
- [ ] MOD195 — Harbor Stone Quay Straight
- [ ] MOD196 — Harbor Stone Quay Corner
- [ ] MOD197 — Canal Boardwalk Straight
- [ ] MOD198 — Canal Boardwalk Corner
- [ ] MOD199 — Harbor Gangway Ramp
- [ ] MOD200 — Ferry Queue Lane Module
- [ ] MOD201 — Mooring Post Pair
- [ ] MOD202 — Small Buoy Cluster
- [ ] MOD203 — Harbor Ladder Wall Module
- [ ] MOD204 — Boat Slip Marker Module
- [ ] MOD205 — Fishing Platform Module
- [ ] MOD206 — Canal Lock Gate Mini Module
- [ ] MOD207 — Marina Edge Module
- [ ] MOD208 — Floating Dock Segment

---

## PACK 10 — Rail & Transit Modules (22)

Purpose: station districts, scenic rail, tourist transport.

- [ ] MOD209 — Railway Track Straight A
- [ ] MOD210 — Railway Track Straight B
- [ ] MOD211 — Railway Track Curve Left
- [ ] MOD212 — Railway Track Curve Right
- [ ] MOD213 — Railway Switch Junction
- [ ] MOD214 — Railway End Cap
- [ ] MOD215 — Low Station Platform Straight
- [ ] MOD216 — Low Station Platform Corner
- [ ] MOD217 — Raised Station Platform Straight
- [ ] MOD218 — Raised Station Platform Ramp
- [ ] MOD219 — Tram Track Embedded Street Tile
- [ ] MOD220 — Tram Stop Curb Module
- [ ] MOD221 — Bus Bay Platform Module
- [ ] MOD222 — Funicular Track Straight
- [ ] MOD223 — Funicular Track Slope
- [ ] MOD224 — Cable Car Tower Base Pad
- [ ] MOD225 — Scenic Rail Tunnel Portal
- [ ] MOD226 — Scenic Rail Bridge Deck
- [ ] MOD227 — Railroad Crossing Module
- [ ] MOD228 — Tourist Train Boarding Pad
- [ ] MOD229 — Transit Stair Access Segment
- [ ] MOD230 — Transit Direction Sign Base

---

## PACK 11 — Grass / Garden / Planter Borders (24)

Purpose: beautification modules that still stay modular and readable.

- [ ] MOD231 — Grass Tuft Cluster A
- [ ] MOD232 — Grass Tuft Cluster B
- [ ] MOD233 — Meadow Flower Patch A
- [ ] MOD234 — Meadow Flower Patch B
- [ ] MOD235 — Shrub Border Straight
- [ ] MOD236 — Shrub Border Corner
- [ ] MOD237 — Hedge Island Small
- [ ] MOD238 — Hedge Island Large
- [ ] MOD239 — Planter Box Straight
- [ ] MOD240 — Planter Box Corner
- [ ] MOD241 — Low Flower Strip Straight
- [ ] MOD242 — Low Flower Strip Corner
- [ ] MOD243 — Canal Reed Cluster
- [ ] MOD244 — Harbor Grass Patch
- [ ] MOD245 — Mountain Wildflower Patch
- [ ] MOD246 — Plaza Tree Pit Border
- [ ] MOD247 — Garden Bed Oval Module
- [ ] MOD248 — Garden Bed Round Module
- [ ] MOD249 — Seasonal Leaf Pile Module
- [ ] MOD250 — Decorative Moss Patch Module
- [ ] MOD251 — Park Mulch Bed Module
- [ ] MOD252 — Fence-Base Flower Cluster
- [ ] MOD253 — Tiny Mushroom Patch Module
- [ ] MOD254 — Boardwalk Planter Strip

---

## PACK 12 — Utility Terrain Details (28)

Purpose: small modules that enrich the world without being one-off hero props.

- [ ] MOD255 — Small Puddle Patch A
- [ ] MOD256 — Small Puddle Patch B
- [ ] MOD257 — Mud Patch A
- [ ] MOD258 — Mud Patch B
- [ ] MOD259 — Worn Footpath Decal Module
- [ ] MOD260 — Wheel Track Decal Module
- [ ] MOD261 — Stone Patch Broken Edge
- [ ] MOD262 — Brick Patch Broken Edge
- [ ] MOD263 — Drain Cover Ground Module
- [ ] MOD264 — Grate Ground Module
- [ ] MOD265 — Utility Box Ground Pad
- [ ] MOD266 — Bollard Pair Module
- [ ] MOD267 — Lamp Base Ground Module
- [ ] MOD268 — Sign Base Ground Module
- [ ] MOD269 — Bench Pad Ground Module
- [ ] MOD270 — Fountain Base Surround Module
- [ ] MOD271 — Bus Stop Ground Marking Tile
- [ ] MOD272 — Ferry Queue Ground Marking Tile
- [ ] MOD273 — Bicycle Parking Ground Module
- [ ] MOD274 — EV Parking Ground Module
- [ ] MOD275 — Market Stall Footprint Tile
- [ ] MOD276 — Festival Booth Footprint Tile
- [ ] MOD277 — Chess Garden Grid Tile
- [ ] MOD278 — Board Game Start Tile Base
- [ ] MOD279 — Scenic View Marker Tile
- [ ] MOD280 — Rock Scatter Surface Detail
- [ ] MOD281 — Small Rubble Scatter Module
- [ ] MOD282 — Sand Drift Surface Detail

---

## PACK 13 — Board-Game Overworld Utility Modules (14)

Purpose: shared modules useful for Ludo, Journey, Tycoon, Goose-like paths, and world map overlays.

- [ ] MOD283 — Node Pad Neutral A
- [ ] MOD284 — Node Pad Neutral B
- [ ] MOD285 — Lucky Node Pad
- [ ] MOD286 — Event Node Pad
- [ ] MOD287 — Property Node Pad
- [ ] MOD288 — Station Node Pad
- [ ] MOD289 — Harbor Node Pad
- [ ] MOD290 — Shortcut Entry Marker
- [ ] MOD291 — Start Tile Marker
- [ ] MOD292 — Turn Arrow Ground Marker
- [ ] MOD293 — Dice Plaza Floor Marker
- [ ] MOD294 — Delivery Spot Marker
- [ ] MOD295 — Route Highlight Base Tile
- [ ] MOD296 — Goal Plaza Marker

---

## PACK 14 — Recommended priority order

### Tier 1 — render first
These give the fastest worldbuilding value:

1. PACK 01 — Ground Base Tiles
2. PACK 02 — Paths & Roads
3. PACK 03 — Borders & Curbs
4. PACK 05 — Rock & Cliff Modules
5. PACK 06 — Stairs & Ramps
6. PACK 09 — Harbor & Canal Modules
7. PACK 10 — Rail & Transit Modules

### Tier 2 — render next
8. PACK 08 — Bridges & Water Crossings
9. PACK 11 — Grass / Garden / Planter Borders
10. PACK 12 — Utility Terrain Details

### Tier 3 — render after that
11. PACK 04 — Plaza & Floor Surfaces
12. PACK 07 — Fences & Boundaries
13. PACK 13 — Board-Game Overworld Utility Modules

---

## 7. Production guidance for the agent

When generating these modular assets:

- do not improvise the art style
- do not create scenic background compositions
- do not merge multiple unrelated modules into one image
- keep every module readable and reusable
- avoid noisy micro-detail
- keep structural planes broad and clean
- prioritize repeatability over spectacle

### For repeated sets
If two variants are requested (A / B), the second should:
- stay in the same family
- vary surface pattern / silhouette subtly
- remain interchangeable

### For corners / junctions
Make sure corners are visually clear and usable:
- outer corner
- inner corner
- T-junction
- crossroad if needed

---

## 8. Final note

This document is not a list of hero props.
It is the **modular backbone** of the CozyUni world.
If this kit is built well, the world can scale far beyond one village and support:

- life-sim world maps
- town centers
- harbor towns
- mountain transport areas
- parks and leisure zones
- railway districts
- board-game overworld boards
- lightweight Animal Crossing–style scenic assembly
