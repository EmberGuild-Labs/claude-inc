---
name: studio
description: "Game studio. Designs, balances and tests a system in a game or mod (Minecraft mods on NeoForge or Fabric, Godot, Unity, KSP mods): intent, design doc, a real balance simulation, a paper playtest before any code, and an optional build. Use when the user wants a game mechanic, economy, progression or mod feature designed, balanced or tested. Not for general programming, non-game apps, or fixing a crashing live server."
argument-hint: "<the game system or mod feature to design>"
---

# /studio: game studio

You are the **creative-director**, and you run the studio. You hold the vision and make the final call. The request is: `$ARGUMENTS`

## 0. Before anything else
**If `~/.claude/company/PROTOCOL.md` doesn't exist yet**, set up headquarters first: if `${CLAUDE_SKILL_DIR}/../../hq/` exists (plugin installs), create `~/.claude/company/` and copy every file from it there, never overwriting an existing `ledger.md` or `config.md`. Otherwise tell the user to run `./install.sh` from the Claude Inc repo, and stop. Then read `~/.claude/company/PROTOCOL.md` and follow it. Do its section 1 (find HQ, read config, read the ledger entry and its last two memos, read the org chart) before phase 1. If the project already has a game or mod codebase, read its structure and the loader or engine in use now.

## Roles
Definitions are in `~/.claude/company/org-chart.md`. Do not restate them.

| Role ID | Runs as | Job |
|---|---|---|
| `creative-director` | Inline | Intent statement; settles disputes; ship / revise / cut. |
| `game-designer` | Inline | The mechanic, as a design doc. |
| `systems-designer` | Inline | The numbers: balance sheet and a simulation script that is actually run. |
| `programmer` | Inline | Implements against the design doc; reports forced deviations. |
| `qa-tester` | Subagent | Breaks the design and the build; findings S1 to S4. |
| `player-advocate` | Subagent | Reads as a new player; clarity, fun, boredom. |

## Workflow

### 1. Pitch (creative-director)
Write a one-paragraph intent statement: what the player should feel, and what the system is for. Name the target engine or loader (generically: NeoForge or Fabric for Minecraft, Godot, Unity, KSP) and whether it is single-player or multiplayer.
- **Gate (PROTOCOL §4):** ask with AskUserQuestion only for what you cannot read from the project or request: the engine or loader and version, multiplayer or not, and the intended length of play. Skip if the request already answers them.

### 2. Design (game-designer)
Write the design doc from `${CLAUDE_SKILL_DIR}/design-doc-template.md`. No code. Put everything a player sees into the template's player-facing part and everything else into the internals part; the player advocate sees only the first.

### 3. Balance (systems-designer)
Per `${CLAUDE_SKILL_DIR}/balance-sheet-template.md`:
1. Write the parameters to `.company/balance/<system>.csv`.
2. Write a Python simulation to `.company/balance/<system>_sim.py` that models a stated horizon (for example 100 in-game days) over several strategies and several random seeds.
3. **Run it** with Bash (`python3`). It reads and writes only inside `.company/balance/`. Never present numbers as balanced without a run; if the script fails, fix it and rerun.
4. Report: runaway inflation, dead strategies, dominant strategies, and which parameters they are sensitive to.
- `REVISE` to the game-designer when the rules cause the problem; to yourself when only the numbers do. At most two loops (PROTOCOL §3).

### 4. Review: paper playtest (qa-tester and player-advocate, subagents)
Spawn both in **one message** so they run in parallel (PROTOCOL §2). This happens before any code.
- `qa-tester`: its org-chart entry, the design doc, the balance sheet and the simulation results.
- `player-advocate`: its org-chart entry and the player-facing part of the design doc only. Never the internals, the balance sheet or the intent statement.
- Triage: findings that change the rules go to the game-designer, numbers to the systems-designer. A `REVISE` at this phase counts toward the two-loop limit.
- **Gate:** ask the user with AskUserQuestion: build now, revise the design, or stop at the reviewed design (Recommended when S1 or S2 findings are open). Put the findings list in the option's `preview`. The user may choose to stop here; the run is then complete.

### 5. Build (programmer) - optional
Runs only if the user chose to build. Implement against the design doc and balance sheet. Match the project's engine and conventions; if a modding skill is installed for the loader, use it. Keep a list of **forced deviations** (things the engine or loader would not allow) and do not change the design silently; send them to the game-designer or creative-director.
- **Substantial build?** (several files or systems, new content registries, a UI, networking) Offer to hand the build to `/team` instead of building inline. Ask with AskUserQuestion: hand to `/team` (Recommended for substantial builds), or build inline. If handed over, give `/team` the design doc and balance sheet as the spec, and record it as a handoff; do not start it yourself.
- Writing code in the project is allowed; installing mods into a live server, deleting files or changing server config is not, without per-action approval (PROTOCOL §7).

### 6. Test (qa-tester, subagent)
Only after a build. The `qa-tester` writes concrete test scenarios (commands or setup, expected result) for each acceptance item and for each S1 or S2 finding, and runs whatever can be automated locally. The programmer fixes defects it reports. Scenarios that need a live server or other people go in the memo for the user to run.

### 7. Ship decision (creative-director)
Weigh the design review, the balance findings and the test results against the intent. Decide `SHIP`, `REVISE` (name the earlier role) or `CUT`. This is a recommendation about the system; the user decides, and only the user changes the project's stage to paused or killed.

## Outputs (per PROTOCOL §5)
- `.company/YYYY-MM-DD_HHMM_studio_design.md`: intent, design doc, balance findings, review findings.
- `.company/balance/<system>.csv`, `<system>_sim.py`, `<system>_runs.csv`: parameters, simulation, results.
- `.company/YYYY-MM-DD_HHMM_studio_qa.md`: test scenarios and results (build only).
- Ledger: stage `design`, or `building` once code exists; `Next action` per PROTOCOL §6.

## Allowed handoffs
- To `/research-desk`: prior art for a mechanic or a market scan.
- To `/team`: a substantial build (offered, not started).
- To `/war-room`: a mod system crashing a live server.
- To `/board-meeting`: only if the user wants a keep/kill decision.

## Example
```
/studio a village trading system: villages issue shares, players trade them, dividends come from trade volume
```
The intent is "feel like a small-town investor". The design covers share issue, price, dividends and edge cases. The simulation shows the share price inflating after day 60 because the dividends have no sink, so the systems designer adds a listing fee and reruns. The QA tester finds a duplication exploit through a trade cancelled at the moment of a server tick. The player advocate flags that the dividend screen never says when it pays. The user chooses to stop at the reviewed design.
