# CozyUni — Living World Gameplay GDD v1.2

## 1. Fantasy and identity

Genre: **3D cozy village adventure + light life simulation + community-building**, family-friendly, single-player and offline-first at initial release. Third-person/gentle isometric follow camera; tablet landscape first, desktop development input second. Player controls an anthropomorphic resident.

**Pitch:** “Every little thing you do leaves a warm trace.” Instead of saving the world, the player takes a small, lived-in village and makes it more personal: a bench that residents start using; a planter the player grew; a photo in the village journal; a lively evening in the square. Later travel reveals seven other distinct regions.

First experience starts in Moonberry. The village is **already happy and inhabited**, not abandoned or ruined; it simply has room for the player's contribution. Avoid generic ‘fix 100 broken objects’ quests.

## 2. Player-facing loop

```text
EXPLORE freely (observe an interesting person/place/event)
  -> CHOOSE an activity or short resident story
  -> DO something tactile (plant, frame a photo, arrange, converse)
  -> GET a persistent reward (album page, decoration, world improvement, relationship beat)
  -> SEE the world change
  -> DISCOVER another place/person or return tomorrow
```

Session design: 10–20 minutes feels complete; a player can leave at any point. There is no match clock, winner, board path or round-end ranking.

### Four intertwined pursuits (NOT separate games)

**Neighborhood Projects.** Upgrade *public spaces*, beginning with the square/garden/park. Choose between 2–3 clear placements; after completion the new object remains and NPCs use it. The first release has 3 projects, not a free-build construction sandbox.

**Resident Moments.** Each recurring character has a small story and predictable presence. Players can speak with them and later witness a scene depending on what was done. For W01, implement just one two-step story per 4 residents, no infinite relationship economy.

**Village Album.** A journal records photos, discovered places, residents met, and memories of completed public projects. It is the story/collection overview, not an achievement spam wall. Album collections incentivize exploration across the eight regions.

**Home Plot & Land Expansion (new core pillar).** Player begins with an 8×8 m personal plot near the W01 Residential lane and may buy three approved adjacent 8×8 m land parcels using earned **Village Coins**. Build mode lets players connect paths, choose terrain finishes and place owned decorations/structures on a 2 m engine grid. The civic Square, Town Hall, public roads, NPC venues and entrances stay immutable. See `06_LAND_EXPANSION_MODULAR_BUILDING.md` and `07_W01_BUILD_PIECES_AND_PLOT_LAYOUT.md` for exact rules. Building is *not* a separate minigame; residents visit the player’s constructed area and the result stays visible after reload.

## 3. Playable actions and feedback

**MOVE.** Free analog movement, no grid/node hopping. Walk is default; run modifier optional. No jumping/platforming/combat. Camera keeps avatar and nearby interactions clear.

**LOOK / PHOTO.** Enter an uncluttered camera composition mode from the album or at a landmark. Center a designated landmark or scene; show a clear subject highlight or ‘Moment found’ when framed. Press shutter; capture one album entry (a small viewport image where supported; otherwise a grounded thumbnail + timestamp/title, no silent failure). One photo per unique moment earns its discovery stamp; repeat photos are allowed but do not farm progress.

**TALK.** On proximity to a known resident, show Talk. Dialogues max 2–5 boxes per interaction, with occasional 2-way choice affecting the immediately visible cosmetic/project preference but never locking the player out of content.

**GARDEN.** Interact with a designated community planter. Select one of three starter flower varieties, plant (one input), water (one input), then return at the next game-day transition to see the bloom. First tutorial planting blooms in the same session via a scripted time-of-day advance: no forced waiting. Flowers persist until replaced; no death/wither penalty in W01.

**ARRANGE / BUILD.** Public Square projects still use approved sockets. **Personal land** offers a real build mode: buy adjacent plots, lay engine-built grass/cobble/dirt/decking cells, add modular fences/path edges and place approved reusable props on snap points. Rotate 90°, preview before confirming, move/store owned pieces with no deletion loss; ensure a 2 m walkable access route. Save land ownership and every piece placement. This is controlled modular building, not invisible socket-only decoration or unrestricted terraforming.

**OBSERVE / GREET.** NPCs follow simple morning/afternoon/evening location slots. Greeting and discovering a resident at the right venue yields a story beat or album update, not currency farming.

**COLLECT.** Limited visible collectibles such as a flower variety, a beautiful view, or community memory. No hundreds of debris pickups, giant inventory, drop rates or mandatory grinding.

## 4. Progression — one transparent system

The **Village Album** has pages. Players unlock story/collection pages by completing real activities or meaningful resident moments, not by paying real money or accumulating generic XP. Land ownership and build layouts are tracked separately from album stamps. Buying a parcel can open a small construction chapter without turning album completion into an economic grind.

For W01, use exactly 9 first-release album stamps:
- WELCOME (met Mayor Pip),
- SQUARE_VIEW (photographed fountain),
- SHOP_STREET_VIEW (photographed shop street),
- PARK_VIEW (photographed garden gazebo),
- FIRST_FLOWER (grew one planter),
- FRIEND_Poppy (heard Poppy's short scene),
- FRIEND_Lumi (heard Lumi's short scene),
- COZY_CORNER (placed a lasting public decoration),
- EVENING_TOGETHER (witnessed the gathering).

W01 chapter-one presentation happens when **WELCOME + FIRST_FLOWER + COZY_CORNER + EVENING_TOGETHER** are earned. The first optional land expansion (`M07`) follows M03 and continues after that celebration; player does **not** need to buy land to see the first ending. Optional stamps remain discoverable. There is no fail state and no requirement to do photo/garden in a fixed order beyond the guided first encounter.

### What is gained
- player-owned land that can visibly grow from 1 to 4 connected plots;
- placeable/repositionable world pieces on purchased land;
- visible changes in the village;
- small decor choices for public square and a personal exterior doorstep;
- additional dialogue, resident presence and album pages;
- later: access to W02–W08 as content milestones, not random roadblocks.

Only **one earned soft currency: Village Coins (VC)**, used in W01 specifically for land expansion. Intro milestones award +40 VC for M01, +30 VC for M02 and +30 VC for M03; first plot purchase costs 100 VC, so the first expansion cannot require grind or real money. Thereafter the resident-care daily action awards +25 VC once per in-game day; later plot prices are 150 and 250 VC. No star/XP currencies, energy, stamina, premium pressure or material accounting for W01. Existing `Cozy Credits` premium commerce remains dormant and must not be injected into buying required world land.

## 5. World clock and residents

First-release time is **session-simulated**, not real-world 24-hour calendar:
- 1 full in-game day: 24 minutes of active world play;
- morning 8 minutes; afternoon 8 minutes; evening 8 minutes;
- do not run the clock while paused/quit or inside cutscenes;
- optional **Rest until morning** at home/guest cottage so plants mature without a real-time wait;
- save day phase, gardening state and resident story flags.

Each NPC has one principal zone per phase, a simple path between zones, and one idle or social activity. NPCs should not vanish telepathically in front of the player; when their next destination is off-camera, relocate safely. The initial requirement is a deterministic schedule, not autonomous AI simulation.

W01 activity schedule proposal:

| Resident | Morning | Afternoon | Evening |
|---|---|---|---|
| Mayor Pip | Town Hall porch | Square | Square gathering |
| Poppy Bear | Bakery frontage | Café outdoor table | Park gathering |
| Lumi Cat | Flower Shop | Community planters | Square gathering |
| Milo Dog | Main Street | Scenic park/photo spot | Square gathering |
| Finn Fox | Park gazebo | Residential lane | Square gathering |

These **roles/schedules are new gameplay design decisions**, not facts previously locked by the repository. CHR identity and Style D are sourced from the catalog.

## 6. Player choice without expensive branching

Player selects a preferred **Cozy Corner** furnishing: flowering planter, garden bench, or warm lantern. All paths satisfy the first milestone, but the chosen item remains visible and influences 1–2 short resident remarks. The player may change the selection later at the same socket; no irreversible decisions.

No feature should require bespoke branching cutscenes or unique complex animation rigs.

## 7. Sensory quality and rewards

Visible response within 1–2 seconds of an action: plant soil change, decor preview, album card reveal, resident reaction, lantern lighting. Audio should be soft and non-repetitive; optional reduced motion. Decorated places become occupied or used by an NPC in at least one later phase. Changes to player world persist across app restart.

## 8. Interaction/UI layout

Tablet landscape gameplay shows predominantly the world:
- top-left: small day/phase + current album chapter, not a full dashboard;
- top-right: Album and Pause buttons;
- near player residence only: a small contextual **Build / Land** interaction; no always-visible building toolbar while exploring;
- lower area: compact one-contextual-action prompt, not 9 permanent buttons;
- overlay when interacting: dialogue card / 3-option public decoration picker / planter picker / photo composition overlay / **personal-land build palette + parcel preview**;
- notifications: one lightweight toast for a completed album stamp.

The player never sees Ludo/Caro/Chess/Journey/Tycoon cards in the main world HUD. Old board-game shell stays in archive until new entry routing is implemented.

## 9. What makes the game playable rather than a walkable tech demo

- at least one owned starting plot, one **real purchased adjacent land plot**, and several different valid land-piece arrangements;
- placement preview, refund-safe move/store actions and saved layout after restart;

- at least 4 residents with predictable movement and unique reactions;
- at least 3 distinct player activities (plant, photo, decorate);
- at least 3 persistent transformations of an environment or album;
- at least 1 evening convergence of residents;
- clear reason to return after a first 20-minute session;
- first progression arc actually ends in a satisfying, observable scene.

## 10. Deliberate exclusions for v1

No board games; no dice/nodes; no combat; no deep fishing or farming economies; no full shop interiors; no **rebuilding town/civic buildings**; no co-op multiplayer; no **paid currency to access land**; no huge NPC dialogue tree; no timed reward calendar; no dynamic weather simulation required; no delivery work loop; no unbounded procedural terraforming or unlimited plot purchases. Player-owned **modular land construction is INCLUDED** in W01, but only in its bounded residential expansion pocket.