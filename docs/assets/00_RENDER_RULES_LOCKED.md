# CozyUni Asset Production — Render Rules (LOCKED)

Status: **LOCKED**
Art direction: **Style D — Clean Game-Ready Cozy 3D**
Purpose: source-of-truth for all concept renders that will later be converted to 3D assets.

## 1. Global style

- Cozy stylized 3D, clean, readable, soft rounded shapes.
- Game-ready rather than painterly illustration.
- Warm materials: painted wood, light plaster, stone, fabric, simple metal.
- Controlled pastel palette; avoid noisy micro-detail and AI clutter.
- Strong silhouette readability at gameplay distance.
- Every asset must look like it belongs to the same universe.
- Reuse visual language, **not geometry**: buildings must not be same house with a new color/sign.

## 2. AI→3D feasibility — hard production constraint

CozyUni does not assume a traditional 3D artist will manually rescue every asset. A concept render is only valuable if it can reasonably survive the image→3D pipeline.

Prefer:
- one isolated object
- one obvious silhouette
- entire object visible
- simple/flat ground contact
- chunky structural forms
- large readable components
- limited thin geometry
- clean material separation
- no dependency on an unseen interior
- no requirement for precise mechanical articulation

Avoid unless explicitly justified:
- thin loose ropes, cables or chains
- dense railings made from dozens of tiny parts
- transparent layered hero geometry
- complex open machinery
- crowds or multiple merged characters
- tiny text as identity
- huge dioramas when individual assets can be assembled in engine
- assets that only work after manual sculpt/topology repair

**Game design must adapt to this constraint.** Do not choose gameplay that requires an art pipeline we do not have.

## 3. Character RIG_BASE — hard rules

Every character intended for auto-rig MUST follow all rules below:

- One character only.
- Full body visible head-to-toe.
- Front orthographic-like view / camera centered.
- Neutral straight posture.
- T-pose or clean rig pose: both arms straight outward and separated from torso.
- Legs straight and separated enough for segmentation.
- Hands/feet clearly visible; no crossed limbs.
- No held objects.
- No backpack, cape, bag, scarf, dangling accessories, large hat, or props.
- Clothing must not hide elbows, wrists, knees, ankles, or merge the legs.
- No action pose, hip tilt, body twist, or 3/4 pose.
- Simple clean background, even light, weak ground shadow only.
- Same facial/style language as the approved original CozyUni cast.

### Current approved cast direction

Rabbit, Poppy Bear, Milo Dog, Lumi Cat, Mayor Pip Hedgehog, Fox, Duck, Sheep, additional Dog, Koala, Panda.

## 4. Building rules

Every building must differ from its siblings in at least:

1. Overall silhouette.
2. Roof geometry.
3. Facade layout.
4. Door/window composition.
5. Material emphasis.
6. Hero functional prop cluster.

Hard negatives:

- No recolor-only variants masquerading as unique buildings.
- No same roof + same facade + different sign.
- No people.
- No complex environment/background.
- No neighboring buildings merged into the asset.
- No oversized trees hiding architecture.

Default render:

- One building per image.
- Isolated clean 3/4 front view.
- Entire footprint visible.
- Functional identity readable without text sign.
- Flat/simple ground contact suitable for image-to-3D.

## 5. Props / food / vehicles / nature

- One asset per image unless the production doc explicitly says `SET`.
- Pure or near-clean neutral background.
- Entire object visible.
- No hand holding the object.
- Avoid cast shadows obscuring the bottom silhouette.
- For trees/plants: trunk/base fully visible; no terrain mound unless requested.
- For vehicles: wheels/underside readable and unobstructed.
- For food: stylized game-readable shape, not photoreal food photography.

## 6. Board-game asset rule

Do **not** spend AI render credits on content that is cheaper and more flexible to build procedurally/in UI.

Prefer engine/UI for:
- full board surfaces
- square grids
- path layouts
- ownership/player colors
- labels and text
- card faces
- money values
- movement highlights
- rule indicators

Use AI→3D for:
- chess/checker/pawn pieces
- dice
- hero tokens
- trophies
- landmark props
- optional decorative pieces that can be reused in the Life Hub

Never render a whole board as one monolithic model merely because it looks attractive in a concept image. Rule/layout iteration must remain cheap.

## 7. File naming

Recommended concept filename:

`<PACK>_<ID>_<slug>_concept.png`

Examples:

- `B01_BLD001_mayor_hall_concept.png`
- `N01_NAT001_large_oak_concept.png`
- `G01_GAM001_cozy_dice_concept.png`

3D output should preserve the same ID.

## 8. Status semantics

- `[ ]` not started
- `[x]` final asset accepted
- Add `RETRY:` after the line when the concept must be regenerated.
- Add `3D:` path/link after acceptance when the 3D conversion is complete.

An item is **not complete** simply because an image exists. It is complete only when its render is accepted as suitable for 3D conversion.

## 9. Batch rule

Default production size = **10 assets per pack** when a ten-item pack is useful.

Do not invent filler assets merely to reach ten. Small game kits may intentionally contain 2–8 assets.

Agent should process one pack at a time, validate outputs, then continue.

## 10. Validation before marking complete

Character:
- limbs separated
- full body visible
- no forbidden accessory
- pose rig-compatible
- style match

Building:
- genuinely unique silhouette
- clear function
- clean footprint
- single asset
- no background contamination

Other assets:
- full silhouette visible
- correct category/style
- isolated
- usable for image-to-3D

Board/game asset:
- truly requires 3D rather than UI/procedural generation
- readable at board/table camera distance
- no unnecessary moving parts
- reusable where possible

## 11. Current render-priority source

Use `docs/assets/02_GAME_FIRST_RENDER_PRIORITY.md` for current production priority.

The older broad master checklist is not the current production order. New assets should be justified by an active game or by high-value reuse in the Cozy World / Life Hub.
