# CozyUni — Simulation Schema & Balance Gates v1.1

Status: **IMPLEMENTATION READY**

Purpose: define deterministic simulation contracts before gameplay tuning.

Detailed harness authority:
- `docs/engineering/HEADLESS_SIMULATION_HARNESS.md`

Machine-readable run/gate config:
- `docs/data/game_simulation_config_v1.json`

Machine-readable game data:
- `docs/data/games/ludo_v1.json`
- `docs/data/games/caro_v1.json`
- `docs/data/games/journey_v1.json`
- `docs/data/games/chess_v1.json`
- `docs/data/games/tycoon_v1.json`

## Rules

- Simulator must call the same rules engine used by production.
- No parallel simplified balance simulator.
- All randomness comes from seeded production RNG.
- Every result stores seed + config version/hash + build commit.
- CPU simulation runtime is not player session duration.
- Bot policy may choose only from production `getLegalActions` output.

## Output set

Every large run exports:

```text
manifest.json
matches.csv
players.csv
summary.json
failed_seeds.txt
```

Generic analyzer:

```bash
python tools/analyze_sim_results.py matches.csv --players players.csv --out summary.json
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
- no-legal-move frequency
- comeback frequency

Review triggers:
- starting position difference >3 percentage points from equal-share expectation
- P95 4P estimated duration >15 minutes

Required policies:
- `LUDO_POLICY_V1`
- at least one seeded legal-random policy as sensitivity check

## Journey simulation

Minimum:
- 100000 matches per player count

Measure:
- turns to finish
- starting-slot win rate
- transport usage
- special tile landing frequency
- negative event frequency
- Picnic extra-roll rate
- shortcut/special EV
- comeback rate

Review triggers:
- starting position difference >3 percentage points from equal-share expectation
- P95 4P estimated duration >12 minutes

## Caro

Do not use balance bots as a substitute for rule correctness.

Tic-Tac-Toe:
- exhaustive state/rule tests where practical

Five-in-a-Row:
- property-based win-detection tests
- overline acceptance tests
- occupied overwrite rejection
- board-full draw
- deterministic side assignment

## Chess

Do not tune standard chess rules.

Use legal-rule regression/perft-style suites for:
- move generation
- self-check legality
- castling
- en passant
- promotion
- repetition identity
- 50-move rule
- insufficient material cases

## Tycoon simulation

Minimum:
- 100000 seeded matches per 2P/3P/4P

Required policy families:
- `CONSERVATIVE_V1`
- `BALANCED_V1`
- `AGGRESSIVE_V1`

Measure:
- Prosperity P10/P50/P90/mean
- Coins end distribution
- leader gap by round
- property concentration
- district completion rate
- L1/L2 upgrade rate
- transport ownership
- Community Stars
- event contribution by card
- starting-slot win rate
- runaway-leader index
- meaningful decision ratio
- no-choice turn ratio
- trade offer/acceptance rate by policy pair

Review triggers:
- starting-slot advantage >3 percentage points
- one event card contributes >10% of average final Prosperity swing by itself
- one district is clearly dominant in expected return without compensating cost/risk
- >20% of turns have no meaningful decision after opening phase

## Result metadata

Every simulation baseline must identify:
- game ID
- GDD/rules version
- game data SHA-256
- simulation config SHA-256
- RNG algorithm/version
- bot policy versions
- player count
- run count
- seed range/seed list strategy
- git build commit

A result without this metadata is not a valid baseline.

## Regression rule

A balance/rule change requires:
1. data validators pass;
2. game rule tests pass;
3. required simulation batch completes;
4. new summary compared against previous baseline;
5. material differences documented;
6. failed seeds replayable in trace mode.

Do not approve tuning based on anecdotal matches alone.
