# CozyUni — World Asset Harvest Plan v1.0

Status: **CURRENT / TEMPORARY PRODUCTION PRIORITY OVERRIDE / CREDIT-EXPIRY MODE**

Decision date: **2026-10-11**

Purpose: convert expiring free 3D-generation credits into a coherent, reusable production asset bank for the full CozyUni world before those credits expire.

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

## 3. Credit policy

The planning baseline is approximately **9,000 expiring credits**.

The exact live balance and actual per-task charge are authoritative. Never assume every task costs exactly the same amount.

Planning model, based on the recently observed ~60-credit image-to-3D task:

| Allocation | Planned 3D calls | Approx. credits at 60/call |
|---|---:|---:|
| Shared world kit | 45 | 2,700 |
| W01 Moonberry Village | 20 | 1,200 |
| W02 Countryside / Farm | 12 | 720 |
| W03 Woodland Meadow | 12 | 720 |
| W04 Lake & Riverside | 12 | 720 |
| W05 Town District | 14 | 840 |
| W06 Harbor & Seaside | 12 | 720 |
| W07 Mountain & Cable Car | 12 | 720 |
| W08 Resort / Tourist | 6 | 360 |
| Production subtotal | **145** | **8,700** |
| Emergency reserve | **~5** | **~300** |
| Total planning envelope | **~150** | **~9,000** |

Rules:

- **8,700 credits is a target envelope, not a mandatory spend.**
- Keep approximately **300 credits / 3–5%** as a late-stage failure/hero reserve until the main queue is healthy.
- If live balance differs from 9,000, scale the queue to the real balance.
- If actual charge per call differs, recalculate immediately from the ledger.
- Failed tasks do not automatically authorize a paid rerun.
- Never generate outside the frozen manifest only because credits remain.

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

Within the 145-call production envelope, prefer:

1. shared high-reuse KIT/PROP;
2. irreplaceable HERO landmarks;
3. route-defining architecture;
4. region-specific nature/structures;
5. activity props with clear gameplay use;
6. optional decorative variants last.

This order intentionally differs from map-by-map assembly.

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
- approximately 3–5% reserve was held until the final review and then either used deliberately or left unused for a documented reason.

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
