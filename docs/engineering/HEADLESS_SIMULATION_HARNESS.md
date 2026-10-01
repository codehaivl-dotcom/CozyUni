# CozyUni — Headless Simulation Harness v1.0

Status: **IMPLEMENTATION CONTRACT**

Purpose: allow 100k+ deterministic gameplay simulations without creating a second approximate rules engine.

---

## 1. Non-negotiable rule

The simulator MUST call the same rule-state/action-validation code used by the production game.

Forbidden:
- reimplementing Ludo/Journey/Tycoon rules separately in Python;
- hard-coding a second copy of board constants;
- using different RNG semantics from production;
- skipping legal-action checks because a bot "knows" the rules.

Allowed:
- headless presentation-free adapter around production rules engine;
- deterministic policy bots that choose among legal actions exposed by production engine;
- analysis tooling in Python after results are exported.

---

## 2. Required game-engine interface

Each simulatable game exposes conceptually:

```text
createMatch(config, seed) -> MatchState
getPhase(state) -> Phase
getLegalActions(state) -> Action[]
applyAction(state, action) -> MatchState
isTerminal(state) -> bool
getResult(state) -> MatchResult
getMetrics(state) -> GameMetrics
```

Rules engine owns legality.
Bot owns only choice among returned legal actions.

No bot may construct an action that is absent from `getLegalActions`.

---

## 3. RNG contract

One match seed -> one deterministic RNG stream.

Required:
- seed stored in result;
- RNG algorithm/version identified in result metadata;
- identical rules version + config hash + seed + bot policy versions must replay identically;
- no wall-clock/random-device calls in rules engine during simulation.

If RNG algorithm changes, bump RNG version and invalidate prior deterministic baseline comparison.

---

## 4. Config authority

Simulator reads the same machine-readable game data used by runtime:

- `docs/data/games/ludo_v1.json`
- `docs/data/games/journey_v1.json`
- `docs/data/games/tycoon_v1.json`

Run-count/gate config:
- `docs/data/game_simulation_config_v1.json`

Do not copy constants into simulator source.

---

## 5. Output directory

One run set writes:

```text
sim-output/<game>/<timestamp>_<rules_version>_<config_hash>/
  manifest.json
  matches.csv
  players.csv
  summary.json
  failed_seeds.txt
```

Optional:
- `events.csv` only for targeted diagnostic runs, not required for every 100k batch.

---

## 6. `manifest.json`

Required shape:

```json
{
  "game_id": "cozy_ludo",
  "rules_version": "1.1",
  "game_data_file": "docs/data/games/ludo_v1.json",
  "game_data_sha256": "...",
  "simulation_config_sha256": "...",
  "rng_algorithm": "<production RNG name>",
  "rng_version": 1,
  "bot_policy_versions": {"default": 1},
  "player_count": 4,
  "requested_runs": 100000,
  "completed_runs": 100000,
  "seed_start": 1,
  "created_utc": "...",
  "build_commit": "git sha"
}
```

No baseline is valid without a manifest.

---

## 7. `matches.csv`

Required columns for all games:

```text
run_id
game_id
rules_version
seed
player_count
winner_slot
turns
duration_seconds_est
terminal_reason
```

`winner_slot`:
- integer 0..N-1 for unique winner;
- blank only when game can end as shared draw/no unique winner.

Additional game-specific numeric columns may be appended.

---

## 8. `players.csv`

Required one row per match/player:

```text
run_id
seed
player_count
slot
rank
won
final_score
```

Game-specific extra columns:

### Ludo
- home_count
- total_progress
- captures
- pieces_in_yard
- bonus_rolls
- no_legal_moves

### Journey
- final_space
- positive_specials
- negative_specials
- picnic_extra_rolls
- train_uses
- ferry_uses
- cable_car_uses

### Tycoon
- prosperity
- coins
- properties
- transports
- complete_districts
- total_upgrade_levels
- community_stars
- trades_offered
- trades_accepted
- meaningful_decisions
- no_choice_turns

---

## 9. Duration model

Until actual playtest telemetry exists, estimated duration uses animation/action timing model, not CPU simulation wall-clock time.

CPU runtime must never be reported as player session length.

Each game adapter calculates `duration_seconds_est` from:
- action count;
- locked animation timing;
- configured human-decision placeholder where specified by simulation config.

When real telemetry exists, update decision-time assumptions via versioned simulation config, not code constants.

---

## 10. Ludo bot policy

Ludo balance bot must be deterministic for same state/seed tie-break.

V1 policy objective is not to be "smart"; it is to produce stable unbiased legal play.

Action preference order:
1. finish a piece Home if legal;
2. capture opponent on non-safe cell if legal;
3. deploy Yard piece on 6 if legal;
4. move piece with greatest resulting progress;
5. deterministic seeded tie-break among equal choices.

This policy must be versioned as `LUDO_POLICY_V1`.

Balance review must also include at least one alternate legal random policy to confirm conclusions are not purely policy artifacts.

---

## 11. Journey bot policy

There is usually no strategic piece choice after roll because one token/player.

Policy:
- roll when legal;
- accept forced movement;
- take required extra roll.

Thus Journey simulation is primarily stochastic rules analysis, not AI strategy analysis.

---

## 12. Tycoon policy bots

All bots see only public match state and legal actions.

### `CONSERVATIVE_V1`
- buys property/transport only when post-purchase coins remain >=30;
- prioritizes completing existing district;
- upgrades only when post-upgrade coins remain >=25;
- Community contribution only when coins >=40;
- Fast Travel chooses destination only when expected immediate tile value is non-negative by static rule table;
- trades only for district completion and rejects deals that reduce own static Prosperity estimate.

### `BALANCED_V1`
- buys property/transport when affordable and post-purchase coins remain >=15;
- prioritizes district completion, then transports, then highest income/buy ratio;
- upgrades when affordable and post-upgrade coins remain >=10;
- Community contribution when coins >=25;
- uses Fast Travel when target is unowned desirable property, beneficial self property, Rest/Community when policy values it, or positive expected event;
- trades for district completion or clear value improvement.

### `AGGRESSIVE_V1`
- buys any affordable unowned property/transport with post-purchase coins >=0;
- prioritizes highest income potential and district completion;
- upgrades whenever legal/affordable;
- Community contribution when legal unless it blocks a currently available purchase/upgrade of higher static value;
- uses Fast Travel aggressively toward acquisition/income opportunities;
- accepts higher-risk trades when projected Prosperity improves.

Static policy valuation tables must live in simulation policy config/versioned code, not change game rules.

---

## 13. Meaningful decision metric for Tycoon

A turn has a meaningful decision when at least one state exposes >=2 materially different legal actions where outcomes differ in ownership, coins, stars, travel destination, upgrade state, or trade state.

Pure UI confirmations do not count.

Report:

```text
decision_turn_ratio = meaningful_decision_turns / total_turns
no_choice_turn_ratio = no_choice_turns / total_turns
```

Review trigger from current design:
- >20% no-choice turns after opening phase requires design review.

---

## 14. Failure capture

Any exception/invariant failure writes seed to `failed_seeds.txt`.

CI/debug command must support replay:

```text
simulate --game cozy_ludo --players 4 --seed <failed_seed> --trace
```

Trace mode may emit full action/event history for one seed only.

Do not emit full traces for 100k production batches by default.

---

## 15. Analyzer

Use:

```text
python tools/analyze_sim_results.py sim-output/.../matches.csv --players sim-output/.../players.csv
```

Analyzer computes generic distributions and slot win rates from exported results.

Game-specific reports may extend it but must not change raw simulation outcomes.

---

## 16. Baseline rule

A balance-affecting change is not complete until:
1. validators pass;
2. production rule tests pass;
3. required simulation batch completes;
4. new summary compared with previous baseline;
5. material differences documented.

Never tune solely from one anecdotal match or one seed.
