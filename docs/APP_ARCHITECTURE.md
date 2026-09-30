# CozyUni — App Architecture v0.1

## Goal

One app, modular internally.

CozyUni should not become one monolithic game scene. The app shell and each game mode should remain independently testable and replaceable.

## Suggested module boundaries

### Shared shell
- boot/update
- profile/save
- localization
- settings/accessibility
- audio
- analytics
- navigation
- friends/lobby
- entitlements/IAP
- cosmetics/wardrobe

### World layer
- canonical resident IDs
- canonical shop IDs
- Moonberry map data
- shared item catalog
- shared animation/VFX references
- seasonal dressing hooks

### Mode interface
Every mode exposes a small common contract, conceptually:
- id / display metadata
- required assets
- supported player counts
- start config
- start / pause / resume / end
- result payload
- analytics hooks
- save scope

The shell should not know internal rules such as dice movement or firefly multipliers.

## Shared vs mode-local state

Shared:
- account/profile
- cosmetics
- unlocked regions/modes
- achievements
- global settings

Mode-local:
- match score
- temporary inventory
- board turn state
- orders
- fireflies carried
- mode-specific bots

Do not reuse a mode score such as Festival Stars as a global spendable currency without a separate design decision.

## Assets

Use stable asset IDs and a shared catalog.

Example categories:
- characters/rabbit
- characters/poppy
- shops/bakery
- shops/fish
- props/festival-crate
- items/bread
- ui/icons/star

A mode references catalog IDs rather than copying assets into mode-specific folders when possible.

## Download size strategy

One app does not mean all future content must ship in the initial binary.

Architecture should allow later optional/remote content packs where platform and engine support them. First release should remain compact and include only production-ready content.

## Testing rule

Every shared-system change must run:
- shell tests
- currently released mode regression tests
- save migration tests

Each mode keeps its own simulation/playtest gates.

## Repository shape (proposal)

```
/apps
  /cozyuni
/packages
  /core
  /world
  /ui
  /telemetry
  /save
/modes
  /festival-board
  /festival-rush
  /firefly-catch
/assets
  /characters
  /moonberry
/docs
```

Adapt this to the actual engine/toolchain rather than forcing the folder structure prematurely.
