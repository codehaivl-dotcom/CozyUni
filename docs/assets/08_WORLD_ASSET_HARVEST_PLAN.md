# CozyUni — World Asset Harvest Plan v1.1

Status: **CURRENT / TEMPORARY PRODUCTION PRIORITY OVERRIDE / CREDIT-EXPIRY MODE**

Decision date: **2026-10-11**

Purpose: spend the expiring free 3D-generation balance deliberately while producing a useful, immediately buildable CozyUni asset package first, then expand that package into a reusable world asset bank before the credits expire.

This document is a temporary production-priority override. It does **not** lower the quality bar, remove QA, or authorize random bulk generation.

## 1. Strategic decision

The previous production strategy rendered only assets immediately required by the active MVP step. That is normally the safer workflow.

The current constraint is different: a large pool of free 3D credits is expiring. Unused credits have zero future value.

Therefore the current critical path is:

```text
FULL-WORLD ASSET AUDIT
-> FREEZE HARVEST MANIFEST
-> PREPARE / APPROVE CONCEPT SOURCES
-> BATCH 3D GENERATION
-> DOWNLOAD / RECOVER
-> TECHNICAL QA
-> ASSET BANK
-> WORLD ASSEMBLY / GAMEPLAY AFTERWARD
```

The goal is **not** to spend credits for their own sake.

The goal is to transform expiring credits into assets with a high probability of use across the complete CozyUni world.

## 2. Scope

Harvest planning covers one connected CozyUni world composed of the eight already-defined regions:

- W01 — Moonberry Village
- W02 — Countryside / Farm
- W03 — Woodland Meadow
- W04 — Lake & Riverside
- W05 — Town District
- W06 — Harbor & Seaside
- W07 — Mountain & Cable Car
- W08 — Resort / Tourist Area

Also included:

- shared world kit used across multiple regions;
- reusable exterior architecture;
- route-defining buildings;
- reusable environment props;
- activity props with clear future use;
- limited interior-shell assets only when their reuse value is high.

Not included merely to consume credits:

- terrain base;
- grass surfaces;
- roads/path surfaces that are better engine-built;
- water surfaces;
- sky/cloud/fog;
- invisible blockers;
- navigation/collision volumes;
- UI;
- text-heavy signs;
- board-game grids/labels;
- simple geometric walls/floors that Godot can build cheaply;
- particle/VFX systems;
- characters unless a separate character pipeline explicitly approves them.

## 3. Useful-first burn strategy

The harvest must produce something useful **before** spreading effort across all eight maps.

The first concrete deliverable is:

`MOONBERRY_PRODUCTION_PACK_V1`

It must be sufficient to assemble a convincing W01 exterior experience without depending on speculative W02–W08 content.

This changes queue philosophy from:

```text
spread credits evenly across eight maps
```

to:

```text
finish one useful production pack
-> build the shared world construction kit
-> add activity/social/interior-support assets
-> seed future-region hero landmarks
-> consume remaining free credits through approved useful variants / backups
```

### 3.1 Credit envelope

Planning baseline: approximately **9,000 expiring credits**.

Observed planning cost: approximately **60 credits per image-to-3D task**.

The live provider balance and actual task usage remain authoritative.

| Burn stage | Planned 3D calls | Approx. credits @ 60 |
|---|---:|---:|
| A — Moonberry Production Pack v1 | 48 | 2,880 |
| B — Shared World Construction Kit | 52 | 3,120 |
| C — Activities / Social / Interior Support Kit | 25 | 1,500 |
| D — Future-region Hero Seed Pack | 15 | 900 |
| E — Final Reserve / Useful Variants / Hero Recovery | 10 | 600 |
| **TOTAL** | **150** | **9,000** |

This is a burn plan, not a promise that every task costs exactly 60 credits.

If the live balance differs, recompute stage E first, then stage D, while protecting stages A–C.

### 3.2 Stage A — Moonberry Production Pack v1

Goal: after Stage A, CozyUni owns one genuinely useful, coherent exterior production kit.

Target families include:

- Town Hall / civic anchor;
- fountain / square anchor;
- bakery;
- flower shop;
- general store;
- café/bookshop;
- 4–6 residential silhouettes;
- bus stop / arrival marker;
- Ludo/social venue;
- 2–3 tree silhouettes;
- bench;
- lamp;
- planter;
- signpost;
- fence family;
- gate;
- stairs/railing;
- gazebo/pergola;
- market stall;
- mailbox/community noticeboard;
- picnic/social table set;
- bridge/park connector where useful;
- rock/moss / flower clusters;
- one or two activity anchors.

Reuse already accepted S04/S05 assets where they are good enough. Do not regenerate them merely to fill Stage A numbers.

If reuse reduces Stage A paid calls, transfer saved calls into Stage B/C rather than inventing duplicate Moonberry assets.

Stage A is complete when a world-builder could assemble a polished W01 exterior using this pack plus engine-built terrain/road/water/UI.

### 3.3 Stage B — Shared World Construction Kit

Goal: create the reusable kit that prevents W02–W08 from becoming eight independent art projects.

Prioritize assets useful in 3+ regions:

- trees;
- bushes;
- flowers;
- rocks;
- benches;
- lamps;
- planters;
- fences;
- gates;
- stairs;
- railings;
- bridge modules;
- awnings;
- kiosks;
- market modules;
- outdoor seating;
- crates/barrels;
- signs;
- dock/harbor modules where reusable;
- generic civic/garden props.

This stage should consume more credits than any one future region.

### 3.4 Stage C — Activities / Social / Interior Support Kit

Goal: make the future world capable of supporting gameplay instead of being scenery-only.

Favor reusable objects for:

- fishing;
- gardening;
- cooking;
- crafting;
- photography;
- café/social interaction;
- community board;
- picnic/festival setup;
- home exterior / small interior starter pieces;
- board-game venue dressing.

Do not build complete interior sets for every shop.

### 3.5 Stage D — Future-region Hero Seed Pack

Only after A–C are healthy, spend on unique landmarks that are difficult to replace later.

Examples:

- W02 windmill / barn hero;
- W03 old hero tree / trail shelter;
- W04 fishing dock / shrine marker;
- W05 station / market hall;
- W06 lighthouse / ferry terminal;
- W07 cable-car station / lodge;
- W08 resort hotel / festival landmark.

This stage seeds future identity without committing to complete region production.

### 3.6 Stage E — Final burn

The last ~10 calls are not a permanent untouched reserve.

Hold them until A–D have been reviewed, then spend them before expiry on the highest-value remaining option:

1. failed HERO recovery;
2. missing high-reuse KIT;
3. visually distinct variant of a heavily repeated shared asset;
4. alternate source for an important asset with weak first output;
5. one additional activity/social asset with clear gameplay value.

Do not spend Stage E on invisible micro-props or near-duplicates.

The intended outcome is to use essentially the full free balance **without sacrificing asset usefulness**.

### 3.7 Burn rules

- Spend fast only after concept/source approval.
- Batch source review before 3D execution.
- Queue approved tasks in groups where the provider/tool safely supports it.
- Recover/download outputs promptly.
- Quick-triage each output into `BANK_ACCEPTED`, `REJECTED`, or `NEEDS_RUNTIME_QA`.
- Detailed runtime optimization may happen after the credit-expiry window.
- A failed non-HERO task normally yields the slot to another useful asset rather than an automatic retry.
- A failed HERO may use Stage E recovery capacity.

## 4. Asset classes

Every billable asset must be assigned exactly one production class.

### HERO
A landmark or identity anchor that the player recognizes immediately.

Examples:
- Town Hall;
- lighthouse;
- windmill;
- observatory;
- cable-car station;
- resort hotel.

### ROUTE
A building/object that defines a traversal beat or district identity.

Examples:
- bakery;
- café;
- bookstore;
- farmhouse;
- pier building;
- mountain lodge.

### KIT
Reusable modular geometry with value across several scenes.

Examples:
- bridge modules;
- stairs;
- railings;
- fence families;
- gates;
- storefront modules;
- awnings;
- harbor modules.

### PROP
Small reusable assets with high placement frequency.

Examples:
- benches;
- lamps;
- planters;
- signposts;
- trees;
- rocks;
- market stalls;
- crates/barrels;
- outdoor tables.

If an item cannot justify one of these four classes, it should normally remain engine-built or deferred.

## 5. Audit source pool

Audit before generation:

1. `docs/assets/04_ALL_IN_ONE_READY_GEN_ASSET_MASTER.md`
2. `docs/assets/05_MODULAR_WORLD_KIT_MASTER.md`
3. `docs/assets/06_MODULAR_WORLD_KIT_BATCH_SHEETS.md`
4. existing repository/local authoring assets explicitly available to the agent;
5. existing accepted 3D production assets;
6. the eight-region requirements in `docs/world/00_WORLD_VISUAL_MVP_LOCK.md`.

The existing ~296-piece library is a **candidate pool**, not an instruction to render 296 assets.

Audit actions:

- merge near-duplicates;
- reject low-reuse micro-variants;
- classify simple geometry as ENGINE_BUILT;
- reuse already-acceptable assets;
- retain unique hero landmarks;
- favor assets visible from gameplay cameras;
- favor assets reusable in multiple regions;
- favor assets that would be expensive or slow to author manually later.

## 6. Required harvest manifest

Before the first bulk billable run, create and freeze:

`evidence/asset-harvest/WORLD_ASSET_HARVEST_MANIFEST.csv`

Required columns:

```text
queue_index,
asset_id,
name,
region,
class,
priority,
reuse_regions,
source_authority,
concept_path,
concept_status,
generation_status,
task_id,
credits_used,
output_path,
triangle_count,
texture_size,
material_count,
technical_qa,
runtime_status,
notes
```

Allowed priorities:

- `P0` — must harvest before expiry;
- `P1` — harvest after P0 if credit/time remains;
- `P2` — reserve/fill only after P0/P1 quality is healthy;
- `DEFER` — do not spend current credits.

No anonymous/untracked paid task is allowed.

## 7. Queue ordering

Queue order is now explicitly **useful-first**:

1. finish `MOONBERRY_PRODUCTION_PACK_V1`;
2. finish the Shared World Construction Kit;
3. finish the Activities / Social / Interior Support Kit;
4. create future-region hero seeds;
5. consume the final free-credit balance on approved recovery or high-value variants.

Do not spread the first 3,000 credits across W01–W08.

The first checkpoint must leave the repository with a coherent production pack that is independently useful even if later world scope changes.

Credit-expiry harvesting is allowed to generate assets for W02–W08 **before those regions are assembled in Godot**.

That exception applies to asset creation only. Final world placement still obeys blockout, route, camera, collision and performance discipline.

## 8. Style authority

All new concepts and 3D sources must obey Style D and:

- `docs/assets/00_RENDER_RULES_LOCKED.md`;
- `References/CozyUni_STYLE_LOCK.png` when the generation route requires an attached style reference.

Target:

- premium clean cozy stylized 3D;
- strong readable silhouette;
- rounded/chunky but crisp forms;
- controlled colorful palette;
- stylized PBR;
- medium detail;
- game-production readability.

Reject:

- clay;
- ceramic/wax look;
- plush;
- photorealism;
- muddy painterly texture;
- monochrome beige;
- noisy micro-detail;
- poster scenes that are poor image-to-3D sources.

For image-to-3D source concepts prefer:

- one asset only;
- centered;
- complete silhouette visible;
- front 3/4 view;
- neutral/clean background;
- minimal overlapping scenery;
- no people/trees/fences fused to a building unless integral to the asset.

## 9. Concept pipeline

Do **not** interleave every concept with one 3D call if a batch can be reviewed first.

Preferred harvest workflow:

```text
manifest P0 batch
-> prepare concept/source images
-> Art Director batch review
-> freeze PASS set
-> Tripo dry-run validation
-> execute approved 3D queue
-> recover/download immediately
-> technical QA
-> asset bank status
```

A concept that fails Style D or 3D-source cleanliness is not eligible for paid conversion.

Do not silently reroll failed concepts.

## 10. Tripo execution

Use only:

`tools/tripo_v3.py`

and obey:

`docs/assets/07_TRIPO_API_V3_EXECUTION.md`

During active Asset Harvest Mode, a billable task is authorized when all are true:

1. the asset exists in the frozen harvest manifest;
2. its priority is currently admitted;
3. its concept/source is approved;
4. current live credit balance is known;
5. reserve policy remains satisfied;
6. the exact request passes dry-run/review;
7. the task is immediately recorded in the harvest ledger.

MVP-01 per-step render allowlists do **not** cap Harvest Mode tasks.

This exception exists only because this document is an explicit user-authorized production-priority override.

Secrets remain local:
- never commit API keys;
- never print or screenshot keys;
- never put keys in CLI arguments.

## 11. Ledger and recovery

Create/maintain:

`evidence/asset-harvest/TRIPO_HARVEST_LEDGER.md`

Record for every billable task:

- date/time;
- asset ID;
- task ID;
- balance before;
- charge;
- balance after;
- output/recovery status;
- source concept;
- final QA disposition.

Prefer `usage` / `recover` for existing tasks when supported by the repository helper.

Never create a new task to recover an existing paid output.

## 12. Technical QA

Every recovered 3D asset is checked for:

- corrupt/incomplete GLB;
- gross geometry failure;
- holes/intersections when visually relevant;
- normals;
- materials;
- texture presence/resolution;
- sensible scale target;
- pivot/ground contact feasibility;
- approximate triangle count;
- duplicate material waste;
- obvious image-to-3D artifacts.

Harvest QA has two acceptance levels:

### BANK_ACCEPTED
Worth preserving in the production asset bank. It may still need runtime optimization later.

### RUNTIME_ACCEPTED
Already validated in Godot at intended camera/usage.

Not every harvested asset needs immediate Godot scene integration before credit expiry. The time-critical goal is to secure useful source assets first.

## 13. Performance policy

Do not ship raw generated meshes blindly.

However, during the expiry window, source acquisition may precede final optimization.

A high-poly result may be stored as `BANK_ACCEPTED` when:
- visual quality is useful;
- geometry is recoverable;
- future decimation/LOD/retopo is feasible;
- it is not incorrectly marked runtime-ready.

Runtime limits remain governed by:

`docs/engineering/04_PERFORMANCE_BUDGETS.md`

Do not randomly decimate source assets merely to make the harvest report look green.

## 14. Stop conditions

Stop the paid queue for:

- `TRIPO_KEY_MISSING`;
- live balance cannot be verified;
- `TRIPO_DOC_MISMATCH`;
- repeated provider failure suggesting credits may be lost;
- Style D drift across a batch;
- manifest/ledger mismatch;
- a task would consume the emergency reserve before P0/P1 review;
- source concepts are not approved;
- output recovery is failing.

Do **not** stop merely because W02–W08 have not yet been assembled.

## 15. Completion target

Asset Harvest Mode is complete when:

- the full 8-region candidate pool has been audited;
- the manifest has explicit P0/P1/P2/DEFER decisions;
- the highest-value approved queue has been generated within the real expiring-credit balance;
- every paid task is recoverable/accounted for;
- useful outputs are preserved in the asset bank;
- rejected outputs are identified rather than silently promoted;
- Stage A produced a coherent Moonberry Production Pack before broad future-region harvesting;
- the shared and activity kits have explicit reusable value;
- the final reserve was deliberately consumed before expiry when safe, with any unused balance documented only if provider/time/quality constraints made further generation irrational.

After the expiry-sensitive harvest is secured, normal production returns to:

```text
blockout / world assembly
-> runtime import
-> gameplay systems
-> NPC/life systems
-> visual polish
-> device performance
```

The asset bank exists to accelerate that later work; it does not replace game production.
