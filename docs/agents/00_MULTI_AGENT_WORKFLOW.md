# CozyUni — Multi-Agent Production Workflow v1.0

Status: **CURRENT / AGENT ORCHESTRATION AUTHORITY**

This workflow adapts the role-based production pattern used by `frabcd/codex-ai-game-studio` to CozyUni. CozyUni does **not** activate every specialist on every task. A small, explicit team is assigned to each admitted MVP step so agents cannot invent work or create an uncontrolled swarm.

## 1. Core rule

The repository still uses the one-step execution model:

`INSPECT -> ASSIGN ROLES -> PLAN EXACT SCOPE -> IMPLEMENT -> SPECIALIST REVIEW -> QA GATE -> EVIDENCE -> UPDATE STATE -> COMMIT -> STOP`

`docs/data/mvp_execution_v1.json` decides **what step may run**.
`docs/data/mvp_role_assignments_v1.json` decides **which roles may participate in that step**.
`docs/data/agent_roles_v1.json` defines **what each role is allowed to do**.

No role may expand the current step, unlock a future step, relax a gate, or create a new feature because it appears useful.

## 2. Orchestration model

Every admitted step has exactly:
- one `lead_role` — owns the implementation/handoff for that step;
- zero or more `support_roles` — bounded specialists that may inspect, advise, or change only files explicitly delegated by the lead;
- one or more `review_roles` — independent reviewers that do not silently fix their own findings unless the lead explicitly delegates a corrective pass.

The `producer` coordinates the run but does not automatically write gameplay/world code.

### Single-writer rule

Parallel read-only analysis is allowed.
Parallel mutation of the same file is not.

For any mutable file, exactly one role owns that file during the current pass. Other roles return findings to the lead.

## 3. Required role handoff

Every participating role returns this compact handoff:

```text
ROLE:
STEP:
SCOPE RECEIVED:
FILES READ:
FILES CHANGED: none | [paths]
FINDINGS:
BLOCKERS:
TESTS / EVIDENCE:
VERDICT: PASS | CONCERNS | BLOCKED
HANDOFF TO:
```

A role must not hide assumptions. Unknown authority becomes a blocker, not an invented decision.

## 4. Gate behavior

The lead cannot mark the step PASS until all declared `review_roles` return PASS or an explicitly documented non-blocking CONCERN.

Blocking verdicts:
- `BLOCKED`
- failed automated tests;
- failed visual acceptance where required;
- failed performance gate where required;
- render outside authorization/budget;
- authority conflict.

Reviewers may never weaken the gate just to make the step pass.

## 5. Role activation rules

Only roles listed for the current step may be activated automatically.

A role outside the assignment requires one of:
1. the current step's declared `escalation_roles`; or
2. explicit user authorization.

If an unassigned specialty is genuinely required, stop with `ROLE_NOT_AUTHORIZED` or `MVP_BLOCKED_MISSING_DEPENDENCY` instead of silently adding another role.

## 6. Production roles

The canonical registry is `docs/data/agent_roles_v1.json`. The current role set is intentionally broad enough for the project but narrow enough to control scope:

- `producer` — coordination, status, scope, handoffs.
- `game-designer` — locked rules/design interpretation; no unilateral rule changes.
- `lead-programmer` — code architecture/review and file ownership boundaries.
- `godot-specialist` — Godot 4.7.2 scenes, resources, signals, import/runtime patterns.
- `gameplay-programmer` — production game-rule/gameplay implementation.
- `ux-designer` — flow, interaction clarity, touch/readability, tutorial UX.
- `ui-programmer` — Godot Control/HUD implementation.
- `art-director` — CozyUni visual/style acceptance and camera-level visual review.
- `level-designer` — route topology, spatial pacing, sightlines, traversal.
- `world-builder` — W01 scene assembly, collision/navigation and modular placement.
- `asset-pipeline-specialist` — asset reuse audit, render authorization, Tripo pipeline, import QA.
- `qa-lead` — test strategy, regression, severity and PASS/FAIL gate.
- `performance-analyst` — frame/memory/draw-call evidence and optimization diagnosis.
- `devops-engineer` — CI/build/export automation only.
- `accessibility-specialist` — readable/color-independent/touch/accessibility checks.
- `release-manager` — market-test/TestFlight/release package readiness.

## 7. Roles are not permission escalation

A subagent inherits the parent run's repository, sandbox, secret, render-budget and current-step restrictions.

A role name never grants permission to:
- use paid APIs when the step forbids rendering;
- access `TRIPO_API_KEY` unless the current step permits a Tripo execution;
- alter locked GDD/data;
- install plugins/dependencies;
- open later maps/games;
- commit secrets;
- skip tests/evidence.

## 8. Tripo / asset role separation

Only `asset-pipeline-specialist` may initiate a Tripo dry-run/execution by default.

Even that role must satisfy all existing conditions:
- current step render budget > 0;
- asset/family is allowlisted;
- camera-driven plan authorizes it;
- no acceptable reuse substitute exists;
- `docs/assets/07_TRIPO_API_V3_EXECUTION.md` is followed;
- dry-run occurs before any paid execution.

`art-director` approves visual quality but does not spend credits.
`world-builder` requests an asset but does not bypass the pipeline.

## 9. Recommended step workflow

At the start of every run:
1. validate repository and MVP graph;
2. validate role registry/assignments;
3. read `current_step`;
4. load only that step's assigned team;
5. producer/lead declares exact file ownership;
6. support roles inspect in parallel where safe;
7. lead applies bounded changes;
8. review roles independently inspect evidence;
9. QA/required gate decides PASS/BLOCKED;
10. update execution state only after PASS;
11. commit and STOP.

## 10. No committee-driven design drift

Multiple roles exist to improve quality, not to reopen locked decisions.

If roles disagree:
- locked repo authority wins first;
- domain owner explains the conflict;
- producer records it;
- if authority cannot resolve it, stop with `AUTHORITY_CONFLICT`.

Do not vote on game rules, art style, engine choice, render budget, or MVP scope.

## 11. Codex role configs

Role configs live under:

`.codex/agents/*.toml`

They intentionally inherit the active model and permission mode. They are project-specific bounded specialists, not independent project managers.

## 12. Validation

Run before implementation:

```bash
python tools/validate_agent_roles.py
python tools/validate_mvp_execution.py
```

CI must keep both validators green.
