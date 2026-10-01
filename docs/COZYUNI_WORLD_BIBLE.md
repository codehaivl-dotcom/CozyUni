# CozyUni — World Bible v0.2

Status: **current product/world direction**

## 1. High concept

CozyUni is one connected cozy 3D universe for families and friends. It is **not nine unrelated games** and it is not a promise to build nine large indie games at once.

The product has two layers:

1. **Cozy World / Life Hub** — a persistent explorable world using the same residents, buildings, shops, parks, transport and regions.
2. **Family Game Table** — a growing collection of familiar board-game families rebuilt with CozyUni characters, presentation and light rule changes.

The target feeling is a weekend family/friends session: easy to understand, cute enough for children and younger players, but clean and pleasant enough that adults do not feel they are playing a disposable children's app.

## 2. Product promise

CozyUni should be understandable before it is deep.

Core rules:
- familiar gameplay first; do not invent complexity merely to be original
- one or two CozyUni twists are enough
- readable cute visuals over visual noise
- short onboarding
- low punishment and friendly competition
- same characters/world reused across games
- build one polished game at a time
- research and paper/prototype test before full production

The long-term advantage is not that every game is mechanically unprecedented. The advantage is the **shared world, shared cast, shared multiplayer shell, shared progression and consistent art identity**.

## 3. Multiplayer modes

Every suitable board game should be designed for two presentation modes while sharing the same authoritative rules engine.

### A. One Device / Table Mode

- 2–4 players may share one tablet/device like a physical board game.
- Players take turns on the same board.
- This is the baseline mode for games with fully public information.
- It must work without requiring accounts or multiple devices.

### B. Room Mode

- One player creates a room.
- Other players join with room code / QR / invite.
- Each player uses their own device while sharing the same match state.
- This mode becomes especially valuable for private information, personal HUD, cards, reactions and future social features.

Do not build separate game logic for the two modes. Input/presentation may differ; game rules must remain shared.

## 4. The Cozy World / Life Hub

The existing 3D asset library should not become a warehouse of unused models. It forms the world surrounding the board games.

The intended direction is **Animal-Crossing-like in atmosphere, not Animal Crossing in production scope**.

Useful Life Hub activities:
- walk around the world with a chosen resident/avatar
- discover districts and landmarks
- visit shop exteriors and public spaces
- enter game venues / tables from the world
- use train, bus, boat, cable car and other travel points to move between regions
- meet ambient NPC residents
- interact with a small number of outdoor props
- take screenshots / photo-mode style pictures
- see seasonal decoration changes
- earn or display light collectibles/cosmetics later

### Explicitly not required for the first Life Hub

- full house interiors
- room-decoration simulator
- complex villager relationship AI
- large crafting tree
- farming simulation
- hundreds of NPC schedules
- MMO-scale online world
- deep player economy

Those features would turn the wrapper into a second giant game and are outside the current strategy.

## 5. AI-first world production constraint

CozyUni has no traditional 3D art team. Most source assets are generated as AI concept renders and converted through image-to-3D workflows.

Therefore art feasibility is a product constraint, not merely an art constraint.

Prefer assets that are:
- one clear object
- strong silhouette
- isolated and easy to segment
- flat or simple ground contact
- chunky rather than thin/mechanically intricate
- readable from gameplay distance
- usable without custom interior topology
- reusable in multiple regions or games

Avoid making a game depend on:
- elaborate interiors
- thin ropes/cables/chains as hero geometry
- complex articulated machinery
- transparent layered structures
- large crowds
- dozens of unique character rigs
- assets that require manual sculpting to become usable

## 6. Anchor location: Moonberry Village

Moonberry Village remains the first identity anchor and can act as the first Life Hub district.

Recurring residents include the approved animal cast such as Rabbit, Poppy Bear, Milo Dog, Lumi Cat, Mayor Pip Hedgehog and the wider Fox/Duck/Sheep/Dog/Koala/Panda character family.

The village and surrounding world can reuse the already-created asset families:
- shops and civic buildings
- landmark architecture
- roads, rail, bridges and transit
- harbor and mountain infrastructure
- parks and outdoor leisure
- sports/recreation structures
- vehicles and boats
- trees, bushes, flowers and ground nature
- food/produce and village props

These assets should be placed to create a lively world before commissioning more decorative architecture.

## 7. World expansion model

The world expands by adding districts/regions, each with a clear visual identity and at least one useful activity or game connection.

Working region directions:
- Moonberry Village — community / board-game hub
- countryside and farms
- woodland / firefly meadow
- lake and riverside
- larger town / urban quarter
- harbor / seaside
- mountain / cable-car region
- resort / tourist district

Names are working concepts until explicitly locked.

A new region should justify itself through reuse and gameplay. Do not create a region only to consume more art assets.

## 8. Game venues inside the world

Board games can appear as physical/social destinations rather than disconnected menu icons.

Examples:
- Ludo / race pavilion in the village square
- Checkers tables in a park
- Chess Garden / chess club
- Goose-family travel board at a station or travel lodge
- Cozy Tycoon table in a market/civic hall

The player may still launch games directly from menus. The world presentation is an optional immersive wrapper, not a mandatory walk every time.

## 9. Shared universe systems

These belong to CozyUni rather than one game:
- player profile
- character selection
- cosmetics
- achievements
- collection book
- seasonal calendar
- settings/accessibility/localization
- save/account layer if introduced
- room/lobby identity
- rematch/session shell
- common audio/VFX language
- common results/reward presentation

Mode-specific score systems should not automatically become global currencies.

## 10. Tone and visual canon

- cozy, optimistic, readable
- playful competition rather than hostility
- soft rounded Style-D shapes
- controlled pastel palette
- strong silhouette at tablet/mobile distance
- restrained environment clutter
- buildings must differ through massing/roof/facade/function, not recolor alone
- cute does not mean visually noisy

## 11. Production rule

Every proposed game or world feature must answer:

1. Is the gameplay already understandable or cheaply testable?
2. Which existing CozyUni systems/assets does it reuse?
3. What new code is truly required?
4. What new 3D assets are truly required?
5. Can those assets be generated reliably by the AI→3D pipeline?
6. Does it improve the family/friends experience?
7. Can it be cut without damaging the rest of the product?

If the answer to #4 is a huge bespoke content set, or #5 is weak, the feature should be redesigned before production.
