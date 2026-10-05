# CozyUni — Agent Readiness Audit — 2026-10-05

Status: **A0 + A1 IMPLEMENTED / CI GREEN / READY FOR A2 LUDO RULE ENGINE**

## Decision

The repository now contains enough authority and executable Godot foundation for an implementation agent to proceed with the next bounded milestone without inventing product scope or engine architecture.

This does **not** mean “build the whole game autonomously.” Work remains milestone-gated by `docs/PRODUCTION_MASTER_PLAN.md`.

## Completed foundation

### A0 — Godot production foundation — PASS

Implemented:
- root `AGENTS.md` authority and stop conditions;
- shipping-vs-world production arbitration;
- Godot engine/version/language lock;
- real `project.godot` bootstrap;
- typed-GDScript shared app/core/data foundations;
- canonical runtime JSON mirror layer;
- versioned local settings foundation;
- deterministic match seed service;
- audio-service foundation;
- CI with game/commerce/catalog/runtime-data validation;
- Godot 4.7.2 headless import/parse + boot smoke.

### A1 — Shared Shell — PASS

Implemented shell path:

```text
Splash
 -> Game Library
 -> Game Start
 -> Local Player Setup
 -> Match Summary
 -> Tutorial when required
 -> Countdown
 -> Development Stub Match
 -> Final Results
      -> Rematch
      -> Change Players
      -> Game Library
```

Also implemented:
- explicit route state machine + invalid-transition rejection;
- only games admitted by `docs/data/app_shell_v1.json` appear in Game Library;
- current build exposes Cozy Ludo only;
- 2/3/4 player setup from canonical Ludo data;
- unique approved CozyUni avatar assignment/cycling;
- 16-character local names;
- tutorial completion persistence and replay reset;
- settings/accessibility controls from the shared lock;
- pause shell with Resume / How to Play / Settings / Restart / Leave;
- restart/leave confirmation policy;
- rematch starting-player rotation state;
- development-only match completion stub, explicitly not gameplay scoring;
- shell route headless smoke test;
- canonical `docs/data/` -> `data/` semantic drift validator.

CI evidence on main after A1:
- canonical game data validation: PASS
- commerce data validation: PASS
- cosmetic catalog validation: PASS
- runtime mirror sync: PASS
- Godot 4.7.2 import/parse: PASS
- shell route smoke: PASS
- main scene headless boot: PASS

## Next admitted milestone — A2 only

**Cozy Ludo production rules engine + automated acceptance tests.**

Authority:
- `docs/games/01_COZY_LUDO.md`
- `docs/data/games/ludo_v1.json`
- `docs/engineering/01_GODOT_PROJECT_ARCHITECTURE.md`
- `docs/engineering/HEADLESS_SIMULATION_HARNESS.md`

A2 must implement rules without depending on rendered board/UI nodes:
- pure match state;
- deterministic D6/RNG;
- legal-piece calculation;
- deploy / movement / safe / capture / home / finish-clamp rules;
- one non-chainable bonus roll after a successful original 6;
- no-legal-move turn end;
- stale/double action rejection by revision;
- immediate first-winner end;
- deterministic final ranking;
- serialization/debug state;
- production-engine interface usable by future headless simulation.

A2 does **not** add final board art, online play, bots, new Ludo rules, or monetization.

## Remaining hard gaps after A2

### Track A — shipping game
1. Connect simulator to production Ludo engine.
2. A3 playable Ludo vertical slice using the real A2 rules engine.
3. A4 visual/audio/localization/accessibility/device-performance polish.
4. Admit Caro only after the Ludo gate.

### Track B — world visual R&D
1. Add actual approved `References/CozyUni_STYLE_LOCK.png`.
2. Add/approve W01 Hero + Layout references.
3. Build W01 primitive blockout.
4. Prove exactly one complete concept -> 3D -> Godot import pipeline.
5. Finish W01 visual gate, then HOLD before W02–W08 unless explicitly admitted.

### Commerce
Commerce documentation/schema is substantially ahead of implementation. Paid CC remains disabled until real backend code, Apple verification, idempotency/refund/reconciliation tests, and StoreKit Test/Sandbox evidence exist.

## Agent permission boundary

An agent may proceed with **A2 only** on the shipping critical path.

An agent may not:
- skip directly to all five games;
- implement online room/matchmaking;
- invent bots;
- invent deep life-sim systems;
- generate final art without required references;
- weaken failed QA gates to make a task appear complete;
- let world R&D block the shipping critical path.

## Current readiness score

- Design / product authority: **~92%**
- Engine / production foundation: **~90%**
- Shared-shell implementation readiness: **PASS**
- A2 Ludo rules-engine readiness: **YES**
- Autonomous full-product readiness: **not the target**

The correct next implementation target is now **A2 Cozy Ludo headless production rules engine**.
