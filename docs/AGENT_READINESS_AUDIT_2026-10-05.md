# CozyUni — Agent Readiness Audit — 2026-10-05

Status: **FOUNDATION COMPLETE / A0 PARTIALLY IMPLEMENTED / READY FOR BOUNDED AGENT WORK**

## Decision

The repository now contains enough authority for an implementation agent to work on the next bounded milestone without inventing product scope or engine architecture.

This does **not** mean “build the whole game autonomously.” Work remains milestone-gated by `docs/PRODUCTION_MASTER_PLAN.md`.

## What is now agent-ready

- root `AGENTS.md` authority and stop conditions;
- shipping-vs-world production arbitration;
- Godot engine/version/language lock;
- real `project.godot` bootstrap;
- shared app/core/data foundations;
- bootable Game Library foundation scene;
- canonical game/economy/catalog validators;
- Godot 4.7.2 headless CI smoke workflow;
- five locked GDDs + machine-readable data;
- headless simulation contract;
- asset import/world assembly contract;
- input/camera/UI technical contract;
- save/localization/accessibility contract;
- performance budget and QA/release gates;
- asset source-of-truth repaired to include modular inventory + batch sheets;
- canonical `References/` path contract.

## Remaining hard gaps before production completion

### Track A — shipping game
1. Finish A0 acceptance by confirming CI green against current main.
2. A1 Shared Shell full stub flow.
3. A2 Cozy Ludo production rule engine + automated acceptance tests.
4. Connect simulator to the production Ludo engine.
5. A3 playable Ludo vertical slice.
6. A4 visual/audio/localization/accessibility/device-performance polish.

### Track B — world visual R&D
1. Add the actual approved `References/CozyUni_STYLE_LOCK.png`.
2. Add/approve W01 Hero + Layout references.
3. Build W01 primitive blockout.
4. Prove exactly one complete concept -> 3D -> Godot import pipeline.
5. Finish W01 visual gate, then HOLD before W02–W08 unless explicitly admitted.

### Commerce
Commerce documentation/schema is substantially ahead of implementation. Paid CC remains disabled until real backend code, Apple verification, idempotency/refund/reconciliation tests, and StoreKit Test/Sandbox evidence exist.

## Agent permission boundary

An agent may now proceed with the active milestone named in `docs/PRODUCTION_MASTER_PLAN.md`.

An agent may not:
- skip directly to all five games;
- implement online room/matchmaking;
- invent bots;
- invent deep life-sim systems;
- generate final art without required references;
- weaken failed QA gates to make a task appear complete;
- let world R&D block the shipping critical path.

## Current readiness score

- Design / product authority: **~90%**
- Engine / production foundation: **~85%**
- Autonomous full-product readiness: **not the target**
- Bounded next-milestone readiness: **YES**

The correct next implementation target is **A1 Shared Shell** only after confirming the current A0 CI/headless gate is green.
