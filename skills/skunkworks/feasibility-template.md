# Feasibility memo template

Fill this in for `.company/YYYY-MM-DD_HHMM_skunkworks_feasibility.md`. It follows the shared memo format (`~/.claude/company/memo-template.md`): front matter, Summary, Findings, Decisions needed, Decisions made, Handoffs, Appendix. The headings under Findings below are the department's own. Delete the guidance text (in angle brackets) when you fill it in. Plain markdown, no emojis, uppercase verdict labels.

---

```markdown
---
department: skunkworks
project: <project id from the ledger>
date: YYYY-MM-DD HH:MM
status: final | draft | blocked
---

# Feasibility: <goal in five words>

## Summary
<Three sentences at most. The question, the VERDICT in capitals (FEASIBLE / FEASIBLE WITH CHANGES / NOT FEASIBLE AT THIS SCALE / UNKNOWN), the next action.>

## Findings

### 1. Goal
<One sentence with a number and units. Example: "A 10 g steel ball leaves the barrel at 30 m/s.">

### 2. Constraints
| Constraint | Value |
|---|---|
| Budget | <amount> |
| Space | <size, room> |
| Tools on hand | <list> |
| Time | <available> |
| Builder profile | <experience with the relevant hazards; workspace; mentor present yes/no; age if under 18> |

### 3. Calculation
<Each line: quantity, formula, value with units. Carry units through every step. Give a range (low / expected / high) wherever an input is uncertain.>

| # | Quantity | Formula | Low | Expected | High | Units |
|---|---|---|---|---|---|---|
| 1 | Target kinetic energy | E = 1/2 m v^2 | | | | J |
| 2 | Energy stored | E = 1/2 C V^2 | | | | J |
| 3 | Required end-to-end efficiency | (1) / (2) | | | | % |

### 4. Assumptions
<Numbered, one per line. Each says what is assumed and how it could be wrong. Example: "A1. Coil-stage efficiency of 5 to 20 percent. Source: <citation or 'estimate'>. If it is 1 percent, row 3 fails by 5x.">

### 5. Skeptic's challenges
| # | Challenge | Corrected figure (if any) | Resolution |
|---|---|---|---|
| C1 | | | accepted / rebutted / open |

Loops used: <0, 1 or 2> of 2.

### 6. Verdict
**<FEASIBLE | FEASIBLE WITH CHANGES | NOT FEASIBLE AT THIS SCALE | UNKNOWN>**
- Reason in one or two sentences, pointing at the rows above.
- Margin: <how far the key figure is from the limit>
- What would flip the verdict: <the assumption or number that, if wrong, changes the answer>
- Relaxed goal (FEASIBLE WITH CHANGES only): <number and units>
- Scale that would work (NOT FEASIBLE only): <number and units>

### 7. Minimum experiment
<Omit for NOT FEASIBLE AT THIS SCALE, and on a safety STOP.>
- **Question the test answers:** <one assumption, e.g. A1>
- **Single variable:** <what changes>; held constant: <list>
- **Procedure:** <numbered, short>
- **Expected result:** <number and units>
- **Pass / fail threshold:** pass if <measurement> is at least <value>; fail if below <value>.
- **Test-only parts list:**

| Part | Qty | Rough price |
|---|---|---|
| | | |

- **Conditions:** <builder profile, copied from section 2>

### 8. Safety review
Reviewed against `safety-gates.md`. Verdict: **PASS | STOP** (loops used: <n> of 2)

| Hazard class | Applies | Tier | Required controls |
|---|---|---|---|
| | yes / no | | |

<On STOP: the hazard, why it applies, and what would make it acceptable: lower energy, a different method, a qualified adult or mentor present, or "do not do this". Leave out the procedure and parts list.>

### 9. Notebook entry
<Pointer: "Appended to .company/lab-notebook.md, entry dated YYYY-MM-DD HH:MM.">

## Decisions needed
<Only the user can decide: for example relax the goal, buy the test parts, confirm a mentor. Each with options and a recommendation. "None." if none.>

## Decisions made
- YYYY-MM-DD HH:MM <gate answer, one line each>

## Handoffs
- To /research-desk: <what and why>

## Appendix
### chief-scientist
<working notes> Verdict: PASS
### theorist
<working notes> Verdict: PASS
### skeptic
<its full output> Verdict: PASS | REVISE
### experimentalist
<working notes> Verdict: PASS
### safety-officer
<its full output> Verdict: PASS | REVISE | STOP
```

---

# Lab notebook entry format

`.company/lab-notebook.md` is **append-only**. The lab-manager adds one entry per run at the end of the file. It never edits, reorders or deletes earlier entries, even to fix a typo; a correction is a new entry that refers to the old one. If the file does not exist, create it with the title line `# Lab notebook` and then append.

Append with a shell append (`>>`), not a rewrite of the file.

```markdown

---
## YYYY-MM-DD HH:MM · <goal in five words>
- **Memo:** <path to the feasibility memo>
- **Goal:** <number and units>
- **Verdict:** <FEASIBLE | FEASIBLE WITH CHANGES | NOT FEASIBLE AT THIS SCALE | UNKNOWN>; safety <PASS | STOP>
- **Tried:** <what was calculated or tested, one or two lines>
- **Failed or refused, and why:** <what did not work, which assumption was wrong, or which hazard was refused>
- **Learned:** <figures worth reusing, with units>
- **Next:** <the experiment, the handoff, or "none">
- **Corrects:** <date of an earlier entry, only if this entry corrects one>
```

When a test has actually been run later (by the user), the same file gets a new entry with the measured result and the pass/fail outcome against the threshold in the memo.
