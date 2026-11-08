# Balance sheet template

Files the systems-designer writes, all under `.company/balance/`, with `<system>` the short kebab-case name of the system:

| File | What it is |
|---|---|
| `<system>.csv` | The balance sheet: every parameter, one row each. |
| `<system>_sim.py` | The simulation. Python 3, standard library only, seeded, reads the CSV. |
| `<system>_runs.csv` | The simulation's output: one row per day per strategy per seed (summary rows are optional). |

The designer must **run** the simulation (`python3 .company/balance/<system>_sim.py`) and report what it found. A balance sheet without a run is not done (org chart: never ship numbers that have not been simulated).

## 1. Balance sheet columns (`<system>.csv`)

```
id,kind,name,value,unit,min,max,source,notes
```

| Column | Meaning |
|---|---|
| `id` | Short stable key used in code, for example `farm_yield`. |
| `kind` | One of `source` (money or items enter), `sink` (leave), `price`, `rate`, `cap`, `multiplier`, `start`, `time`. |
| `name` | Human name. |
| `value` | The current value. |
| `unit` | Unit: `coins`, `coins/day`, `items`, `percent`, `ticks`, `days`. |
| `min`, `max` | The range the designer would accept. The sensitivity sweep uses them. |
| `source` | Where the number comes from: `design B7`, `playtest`, `copied from <game>`, `guess`. |
| `notes` | One line of reasoning. |

Example rows:

```
id,kind,name,value,unit,min,max,source,notes
start_coins,start,Starting coins,100,coins,50,200,design B7,Enough for one upgrade
farm_yield,source,Farming income,12,coins/day,8,16,guess,Safe and steady
trade_margin,source,Trading margin,0.08,fraction,0.04,0.15,guess,Risky; needs capital
craft_income,source,Crafting income,10,coins/day,6,14,guess,Needs a tool
tax_rate,sink,Daily tax,0.01,fraction,0,0.05,design B3,Sink on balance
upkeep,sink,Daily upkeep,2,coins/day,0,6,design B3,Flat sink
horizon,time,Days simulated,100,days,30,365,design B7,
```

## 2. What the simulation must contain

- **Horizon** (days or ticks) from the sheet, for example 100 in-game days.
- **Strategies:** at least three distinct ways a player could play (including the "obvious" one, a cautious one, and an exploit-minded one found by reading the rules). Each is a function that, given the state, picks an action each day.
- **Agents and seeds:** run each strategy over many seeds (30 or more) so noise does not look like a result.
- **Per-day logging** of the supply (total currency or items in the world), a price index, and each strategy's net worth.
- **Checks** that print a verdict for each, as in section 3.
- **Sensitivity sweep:** repeat the run with each parameter set to its `min` and `max`. Report which parameters flip a finding.

## 3. Findings to report

| Finding | Test (default thresholds; state any you change) |
|---|---|
| Runaway inflation | The money supply or price index more than doubles between day 50% and day 100% of the horizon with no stabilizing sink; or growth is still accelerating at the end. |
| Deflation or starvation | Median net worth falls for the last 20% of the horizon. |
| Dominant strategy | One strategy's median net worth is over 1.5 times the next best by the end, in at least 80% of seeds. |
| Dead strategy | A strategy's median net worth is under 0.5 times the best, in at least 80% of seeds, or no one would pick it even when the others are known. |
| Dead sink or source | A sink or source whose flow is under 1% of the total flow over the horizon. |
| Time-to-first-goal | Median days to first milestone is outside the target in design B7. |
| Fragile balance | The conclusion flips when a parameter moves inside its `min` to `max` range. |

For each finding, give the number, the seed count, the parameter(s) responsible, and a proposed fix with the re-run result. The designer ends with `PASS` (no open finding), or `REVISE` (to the `game-designer` if a rule causes it, otherwise to itself).

## 4. Minimal simulation skeleton (`<system>_sim.py`)

Copy it, rename the strategies and the daily rules to match the design, and keep the checks.

```python
#!/usr/bin/env python3
"""Balance simulation for <system>. Standard library only. Run from the project root."""
import csv
import random
import statistics
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
NAME = Path(__file__).stem.removesuffix("_sim")
SEEDS = 40


def load_params(overrides=None):
    params = {}
    with open(HERE / f"{NAME}.csv", newline="") as f:
        for row in csv.DictReader(f):
            params[row["id"]] = float(row["value"])
    params.update(overrides or {})
    return params


# --- Strategies: each returns this day's gross income given the state --------
def farm(p, s, rng):
    return p["farm_yield"] * rng.uniform(0.8, 1.2)

def trade(p, s, rng):
    # needs capital; risky
    return s["coins"] * p["trade_margin"] * rng.uniform(-1.0, 2.0)

def craft(p, s, rng):
    return p["craft_income"] * rng.uniform(0.9, 1.1)

STRATEGIES = {"farm": farm, "trade": trade, "craft": craft}


# --- One run ------------------------------------------------------------------
def run(strategy, params, seed):
    rng = random.Random(seed)
    s = {"coins": params["start_coins"]}
    rows = []
    for day in range(1, int(params["horizon"]) + 1):
        income = STRATEGIES[strategy](params, s, rng)
        tax = max(s["coins"], 0) * params["tax_rate"]
        s["coins"] += income - tax - params["upkeep"]
        rows.append({"day": day, "strategy": strategy, "seed": seed,
                     "coins": round(s["coins"], 2)})
    return rows


def run_all(params):
    out = []
    for name in STRATEGIES:
        for seed in range(SEEDS):
            out.extend(run(name, params, seed))
    return out


# --- Analysis -----------------------------------------------------------------
def final_by_strategy(rows, horizon):
    res = {}
    for r in rows:
        if r["day"] == horizon:
            res.setdefault(r["strategy"], []).append(r["coins"])
    return res


def supply_at(rows, day):
    return sum(r["coins"] for r in rows if r["day"] == day)


def findings(rows, params):
    h = int(params["horizon"])
    finals = final_by_strategy(rows, h)
    med = {k: statistics.median(v) for k, v in finals.items()}
    best = max(med, key=med.get)
    out = []
    # Dominant strategy
    others = sorted((v for k, v in med.items() if k != best), reverse=True)
    if others and others[0] > 0 and med[best] > 1.5 * others[0]:
        out.append(f"DOMINANT: {best} ends at {med[best]:.0f}, over 1.5x the next best ({others[0]:.0f})")
    # Dead strategies
    for k, v in med.items():
        if k != best and med[best] > 0 and v < 0.5 * med[best]:
            out.append(f"DEAD: {k} ends at {v:.0f}, under half of {best} ({med[best]:.0f})")
    # Runaway inflation (supply as a proxy; replace with a real price index if the design has one)
    mid, end = supply_at(rows, h // 2), supply_at(rows, h)
    if mid > 0 and end > 2 * mid:
        out.append(f"INFLATION: total supply grew {end / mid:.1f}x from day {h // 2} to day {h}")
    return out or ["NONE"], med


def sweep(base):
    """Move each parameter to its min and max; report if the finding set changes."""
    flips = []
    base_f, _ = findings(run_all(base), base)
    with open(HERE / f"{NAME}.csv", newline="") as f:
        for row in csv.DictReader(f):
            for bound in ("min", "max"):
                p = load_params({row["id"]: float(row[bound])})
                f2, _ = findings(run_all(p), p)
                if f2 != base_f:
                    flips.append(f"{row['id']}={row[bound]}: {f2}")
    return flips


def main():
    params = load_params()
    rows = run_all(params)
    with open(HERE / f"{NAME}_runs.csv", "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["day", "strategy", "seed", "coins"])
        w.writeheader()
        w.writerows(rows)
    result, med = findings(rows, params)
    print("Median final coins:", {k: round(v) for k, v in med.items()})
    print("Findings:")
    for line in result:
        print(" -", line)
    print("Sensitivity (parameter changes that alter the findings):")
    for line in sweep(params) or ["none"]:
        print(" -", line)
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

Notes for the designer:
- Replace the toy income rules with the flows in design doc section B3. One function per strategy. Add shared markets (prices that respond to supply and demand) if the design has them; that is where inflation hides.
- Keep the output CSV columns `day,strategy,seed` plus one column per tracked quantity (`coins`, `supply`, `price_index`, and so on).
- Record in the memo: the command run, the seed count, the horizon, the output, and any threshold you changed.
