# CozyUni — A2 Cozy Ludo Rules Acceptance — 2026-10-05

Status: **PASS / A2 EXIT GATE ACCEPTED**

Authority:
- `docs/PRODUCTION_MASTER_PLAN.md`
- `docs/games/01_COZY_LUDO.md`
- `docs/data/games/ludo_v1.json`
- runtime mirror `data/games/ludo_v1.json`

## Implemented production rules engine

- `src/modes/cozy_ludo/ludo_rules.gd`
- `src/modes/cozy_ludo/ludo_match.gd`

The rules/state owner is headless and presentation-independent. UI submits semantic intent; the match owner validates actions and advances a monotonic revision.

Covered behavior:
- 2/3/4 players;
- one active piece + two Yard pieces at start;
- deterministic seeded D6;
- 52-cell outer-loop mapping from personal starts;
- Home Lane progress 53–57 and final Home 58;
- deploy only on 6;
- own destination occupancy rejection;
- non-blocking intermediate pieces;
- safe-cell no-capture behavior;
- non-safe exact-landing capture -> Yard;
- finish overshoot clamp;
- original-6 single bonus roll;
- no bonus chaining from bonus roll;
- no legal move -> auto turn end + 0.8 s event;
- immediate first winner;
- deterministic final ranking + shared ties;
- stale/double action rejection by state revision;
- rematch starting-player rotation from original starting slot.

## Automated acceptance

Primary test:

`tests/ludo/ludo_rules_acceptance.gd`

CI command:

```bash
Godot_v4.7.2-stable_linux.x86_64 --headless --path . --script res://tests/ludo/ludo_rules_acceptance.gd
```

Confirmed GitHub Actions run:
- run: `37295052089`
- commit under test: `b3c54c36ce5e401a77bc83cb1697e509f93038b1`
- canonical data validators: PASS
- runtime data mirror validator: PASS
- Godot import/parse: PASS
- shell route smoke: PASS
- Cozy Ludo deterministic rule acceptance: **PASS**
- main scene boot smoke: PASS

## Defects found and corrected during gate

The acceptance gate caught JSON-number type normalization issues. JSON numeric arrays are not used through raw typed membership checks anymore for player counts/safe cells; values are normalized with `int(...)` before comparison.

Earlier parse/strict-type failures were also corrected rather than weakening the gate.

## Exit decision

A2 is accepted.

Next admitted milestone:

**A3 — Playable Cozy Ludo vertical slice**

Required A3 path:

`Game Library -> Ludo Start -> Local Setup -> Tutorial -> Countdown -> real Ludo Match -> Final Results -> Rematch`

A3 must use this production rules engine directly. Do not create a second UI-side rules implementation.
