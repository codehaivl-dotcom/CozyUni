# CozyUni — Asset Import & World Assembly v1.0

Status: **IMPLEMENTATION AUTHORITY**

## 1. Purpose

Define how generated/hand-authored 3D assets become stable Godot production assets and how the modular kit is assembled into world regions.

This file does not replace art-generation source documents.

## 2. Preferred interchange format

Preferred production interchange: **GLB/glTF 2.0**.

Rules:
- preserve original generated/export source beside processed candidates where practical;
- do not make `.godot/imported` data the source asset;
- source mesh/texture provenance must remain traceable;
- avoid proprietary-only formats as canonical production source.

## 3. Units and scale

Godot world convention:
- **1 Godot unit = 1 meter**.
- imported assets must be normalized to this convention before acceptance.

Every accepted 3D asset records or can deterministically infer:
- intended real/game scale;
- forward direction;
- up axis;
- pivot/ground-contact convention.

Do not compensate for wrong source scale by arbitrary per-instance scaling across the map.

## 4. Pivot conventions

### Standing props / characters / buildings
Pivot should be centered horizontally at the intended ground-contact plane unless a functional hinge/pivot is required.

### Modular floor/path pieces
Pivot and dimensions must support deterministic snapping.

### Doors/gates/rotating parts
Functional hinge may use a dedicated child node rather than corrupting the base-module origin.

## 5. Asset acceptance checks

Before production use, verify:
- mesh loads without importer error;
- correct scale;
- correct orientation;
- ground contact;
- normals/tangents appear correct;
- no obvious unintended holes/intersections;
- material slots are sensible;
- textures resolve;
- transparency is intentional;
- collision policy assigned;
- repeated asset cost is acceptable;
- visual check from canonical gameplay camera passes.

A pretty source render is not enough.

## 6. Material policy

Use standard Godot PBR channels where possible:
- base color/albedo;
- normal;
- roughness;
- metallic when physically appropriate;
- AO where useful.

Rules:
- no fake metallic values merely to create shine;
- minimize unique materials for repeated modular pieces;
- avoid unnecessary transparency;
- prefer shared material families/atlases when they materially reduce draw cost without visibly harming quality.

## 7. Collision policy

### No collision
Pure background/distant decorative asset.

### Primitive/simple collision
Default for:
- rocks;
- furniture;
- fences;
- props;
- buildings where only exterior blocking matters.

### Custom simplified collision
Use for:
- stairs;
- bridges;
- complex walkable route pieces;
- architectural forms where primitive collision breaks navigation.

### Mesh/trimesh collision
Exceptional. Use only for static assets when a simpler representation cannot preserve required playability.

Never use expensive geometry collision just because it is automatic.

## 8. World assembly categories

### A. Engine-built
Godot owns:
- terrain/large ground surfaces;
- water behavior;
- fog/environment;
- lighting;
- decals;
- broad material blending;
- procedural/scatter placement logic;
- board grids/paths/text/card UI where specified.

### B. GridMap / MeshLibrary candidates
Best for snap-friendly repeated modular structures:
- road/path pieces;
- curb/edge;
- retaining walls;
- cliff blocks where grid-like;
- stairs/ramps where dimensions are standardized;
- dock/boardwalk pieces;
- rail/platform structural modules.

GridMap is a placement tool, not permission to force every asset into a grid.

### C. MultiMesh candidates
Best for large counts of identical/simple instances:
- small grass/flowers;
- pebbles;
- repeated tiny rocks;
- repeated decorative clutter when interaction/collision is unnecessary.

### D. Individual scene instances
Use for:
- buildings;
- hero landmarks;
- large trees;
- vehicles;
- interactive props;
- unique architecture;
- assets needing animation or custom collision/logic.

## 9. Modular kit rule

Canonical modular inventory: `docs/assets/05_MODULAR_WORLD_KIT_MASTER.md`.

Batch render plan: `docs/assets/06_MODULAR_WORLD_KIT_BATCH_SHEETS.md`.

Batch sheets are a generation-credit optimization only. The engine still requires resulting pieces to become distinct, addressable production assets when gameplay/world assembly needs them separately.

Do not import a sheet-generated group as one inseparable world mesh if it prevents reuse/snapping/culling.

## 10. Modular dimensions

Before a family enters production, define one snap unit and record it in the import manifest/scene metadata.

Examples of family constraints that must be consistent:
- path width;
- curb height;
- stair rise/run;
- fence segment length;
- dock deck height;
- rail gauge/track connection points.

Do not guess dimensions independently per generated image.

If source generation produces incompatible dimensions, normalize during asset-prep before acceptance.

## 11. World region scene construction

Each W01–W08 region follows:

1. blockout primitives;
2. route/camera/collision/nav validation;
3. engine ground/water/environment;
4. structural modular replacement;
5. hero assets/buildings;
6. vegetation/props;
7. background silhouettes;
8. lighting/material polish;
9. visual/performance QA.

Do not start at step 4 before blockout acceptance.

## 12. Navigation

World route must use walkable surfaces that produce reliable navigation.

Rules:
- avoid navigation holes caused by decorative collision;
- dynamic decorative objects should not rebuild nav unnecessarily;
- stairs/ramps must be validated by actual traversal, not just nav debug visualization;
- every canonical entry/exit and hero route must be reachable in automated/manual smoke tests.

## 13. LOD / visibility / background

For World Visual MVP:
- use distance/visibility management for expensive distant assets;
- background-only buildings/terrain need not have full collision/interiors;
- hero assets may retain more detail than distant repeats;
- repeated generated meshes should not all remain at source maximum density.

Exact budgets live in `04_PERFORMANCE_BUDGETS.md`.

## 14. Asset manifest requirement

Production imports should converge on a machine-readable manifest with at least:

```text
asset_id
source_path
runtime_scene_or_mesh
category
intended_scale_m
pivot_policy
collision_policy
material_count
texture_set
lod_policy
world_usage
qa_status
```

Until the manifest tool exists, agents must preserve these facts in deterministic scene/import naming rather than inventing ad hoc conventions.

## 15. Reimport safety

A Godot reimport must not destroy manual production logic.

Place custom collision/logic in wrapper scenes when necessary instead of editing generated imported subresources in fragile ways.

Expected model:

```text
source.glb
 -> imported mesh scene
 -> CozyUni wrapper scene
      collision
      metadata
      optional animation/interaction nodes
```

## 16. Acceptance evidence

For representative/new asset families, save evidence of:
- source/reference;
- isolated render or turntable;
- Godot import view;
- gameplay-camera view;
- collision/nav debug view when relevant;
- measured runtime cost when repeated.

Asset is accepted only after visual + technical checks pass.
