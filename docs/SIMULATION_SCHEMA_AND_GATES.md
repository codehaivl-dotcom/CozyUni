# CozyUni — Simulation Schema & Balance Gates v1.0

Status: IMPLEMENTATION READY

Purpose: define deterministic simulation contracts before gameplay tuning.

## Rules

- Simulator must call the same rules engine used by production.
- No parallel simplified balance simulator.
- All randomness comes from seeded RNG.
- Every result stores seed + config version.

## Match result envelope

```json
{
  "game_id": "cozy_ludo",
  "rules_version": "1.0",
  "seed": 12345,
  "players": 4,
  "winner": 2,
  "turns": 38,
  "duration_seconds": 420
}
```

## Ludo simulation

Minimum runs:
- 100000 matches per 2P/3P/4P

Measure:
- win rate by starting slot
- mean / median / P90 / P95 turns
- estimated duration
- captures per player
- bonus roll frequency
- pieces finished distribution
- comeback frequency

Review triggers:
- starting position difference >3 percentage points
- P95 duration >15 minutes
- excessive first-player advantage

## Journey simulation

Minimum:
- 100000 matches per player count

Measure:
- turns to finish
- transport usage
- special tile landing frequency
- negative event frequency
- shortcut EV
- comeback rate

## Tycoon simulation

Bots:
- conservative
- balanced
- aggressive

Measure:
- final wealth distribution
- leader gap after each round
- property concentration
- bankruptcy frequency
- comeback possibility
- average match length

## Output files

Every simulator run exports:
- summary.json
- raw_results.csv
- seed list
- regression baseline

A rules change requires comparing against previous baseline.
