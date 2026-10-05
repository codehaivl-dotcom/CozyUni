# CozyUni — Performance & Device Budgets v1.0

Status: **PRELIMINARY PRODUCTION GATE / MEASURE, DO NOT GUESS**

These are the first enforceable budgets for agent work. They may be revised only from device evidence; agents must not silently loosen them.

## 1. Baseline product class

Primary release UX: landscape iPad/tablet.

Initial representative baseline class:
- Apple A14-class tablet performance or better;
- 4 GB system memory class;
- native device build, not editor performance.

Desktop development machines are not valid performance authority.

If release later targets weaker hardware, create a new measured device tier rather than pretending desktop numbers transfer.

## 2. Frame-rate target

### Board games
- target: **60 FPS**;
- target frame budget: **16.67 ms**;
- representative gameplay P95 should remain <= 16.67 ms on baseline device after warm-up;
- no repeated > 33 ms hitch during ordinary turns/animations.

### World Visual MVP
- target: **60 FPS**;
- P50 <= 16.67 ms;
- P95 target <= 20 ms in representative route captures;
- sustained > 25 ms is a performance defect;
- repeated > 33 ms hitches are a release blocker for the affected route.

A later 30 FPS quality mode requires an explicit product decision. Agents cannot use 30 FPS as an automatic escape hatch.

## 3. Memory

On the baseline 4 GB class device:
- steady-state target <= **1.2 GB** resident app memory;
- peak target <= **1.5 GB** during region/game transitions;
- unbounded growth across rematches/region transitions is always a defect.

Measure:
- after boot;
- after 3 consecutive matches/rematches;
- after repeated world region transitions once world exists;
- after opening/closing settings/tutorial/store surfaces when implemented.

## 4. Scene complexity guidance

These are warning budgets, not excuses to skip profiling.

### Board scene
- visible triangles target <= **500k**;
- draw calls target <= **400**;
- transparent material surfaces kept minimal;
- no full-world background loaded behind a board unless proven cheap.

### World region
- visible triangles target <= **1.5M** in normal route views;
- > **2.0M** visible triangles is a warning requiring evidence/optimization;
- draw calls target <= **700** normal route, <= **900** hero vista;
- repeated small decoration should prefer instancing/MultiMesh when appropriate.

Source asset triangle count alone is not the performance metric; measure what the camera actually renders.

## 5. Generated 3D asset budgets

Do not ship raw image-to-3D output blindly.

Default review bands:
- tiny repeated prop: prefer <= 5k–15k triangles;
- common medium prop: prefer <= 10k–30k;
- building/common large object: prefer <= 30k–100k depending screen importance;
- hero landmark: may exceed common budgets only with measured justification;
- characters require their own animation/deformation budget and must not inherit static hero-mesh density.

If a generated source arrives at hundreds of thousands/millions of triangles, treat it as **source**, not automatically runtime-ready.

## 6. Texture budgets

Default mobile production guidance:
- tiny/repeated props: 512–1024 where visually sufficient;
- common props/buildings: 1024 preferred;
- 2048 reserved for assets that visibly benefit at gameplay camera distance;
- 4K textures require explicit evidence and should be exceptional on mobile.

Prefer compressed/imported GPU formats appropriate to Godot/iOS export.

Warning target for one loaded world region:
- keep estimated resident texture footprint comfortably below **512 MB**;
- duplicated identical textures/materials are defects.

Do not upscale a blurry source texture and count that as added detail.

## 7. Materials / transparency

Performance-sensitive rules:
- reuse material families;
- batch/atlas when quality and authoring remain sane;
- avoid many unique transparent materials;
- alpha blending for foliage/FX must be tested in overdraw-heavy views;
- large screen-space transparent layers are performance-review items.

## 8. Lighting/shadows

Start simple:
- one primary directional light where appropriate;
- baked/static lighting may be evaluated per world workflow;
- limit dynamic shadow-casting lights;
- small decorative lights should not all cast real-time shadows;
- board-game presentation does not require a physically complex lighting rig.

Any expensive lighting feature needs before/after frame evidence.

## 9. Physics/navigation budgets

- static environment uses simple collision where possible;
- decorative scatter should usually have no collision;
- avoid per-frame nav rebuilds;
- repeated props must not create hundreds of unnecessary physics bodies;
- board rules never use physics collision as game-rule authority.

## 10. Loading and transitions

Initial targets on representative release hardware:
- app boot to usable Game Library: <= **4 s** after engine startup measurement point;
- board-game scene transition: <= **2 s** target;
- world region transition: <= **4 s** target with loading feedback if not seamless;
- no main-thread freeze > **500 ms** without an intentional loading state.

Record cold/warm conditions when reporting results.

## 11. Performance test routes

### Shared shell
`Boot -> Library -> Start -> Setup -> Match stub -> Results -> Rematch -> Library`

### Ludo
Measure:
- idle board;
- dice animation;
- longest token movement;
- capture animation;
- results transition;
- three rematches.

### W01
Measure canonical route:
`Entrance -> Main Street -> Village Square -> Town Hall -> Shop Street -> Park/Game Venue -> Exit`

Capture a hero vista separately because it may be the heaviest composition.

## 12. Evidence format

Every performance gate report records:
- commit SHA;
- Godot version;
- device/model + OS;
- build configuration;
- route/state;
- FPS/frame-time P50/P95/max or equivalent profiler samples;
- memory steady/peak;
- draw calls;
- visible primitives/triangles when available;
- screenshot identifying measured scene;
- regression versus prior accepted baseline.

`runs fine on my PC` is not evidence.

## 13. Optimization order

When a scene fails:
1. identify actual bottleneck in profiler;
2. remove accidental duplicated work/resources;
3. reduce offscreen/irrelevant rendering;
4. instance repeated assets;
5. simplify collision/navigation;
6. reduce material/draw fragmentation;
7. introduce LOD/visibility ranges;
8. optimize mesh/texture density;
9. adjust expensive effects/lighting;
10. only then consider changing product-quality target.

Do not destroy art quality by random decimation before measuring the bottleneck.
