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

## 2. Character RIG_BASE — hard rules

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

## 3. Building rules

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

## 4. Props / food / vehicles / nature

- One asset per image unless the checklist explicitly says `SET`.
- Pure or near-clean neutral background.
- Entire object visible.
- No hand holding the object.
- Avoid cast shadows obscuring the bottom silhouette.
- For trees/plants: trunk/base fully visible; no terrain mound unless requested.
- For vehicles: wheels/underside readable and unobstructed.
- For food: stylized game-readable shape, not photoreal food photography.

## 5. File naming

Recommended concept filename:

`<PACK>_<ID>_<slug>_concept.png`

Examples:

- `B01_BLD001_mayor_hall_concept.png`
- `N01_NAT001_large_oak_concept.png`
- `F01_FOD001_baguette_concept.png`

3D output should preserve the same ID.

## 6. Checklist status semantics

- `[ ]` not started
- `[x]` final asset accepted
- Add `RETRY:` after the line when the concept must be regenerated.
- Add `3D:` path/link after acceptance when the 3D conversion is complete.

An item is **not complete** simply because an image exists. It is complete only when its render is accepted as suitable for 3D conversion.

## 7. Batch rule

Default production size = **10 assets per pack**.

Agent should process one pack at a time, update checkboxes only after validation, then continue to the next pack.

## 8. Validation before marking complete

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
