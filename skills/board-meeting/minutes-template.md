# Board minutes template

Copy the block below to `HQ/archive/YYYY-MM-DD_HHMM_board-meeting_minutes.md` and fill it in. It follows `HQ/memo-template.md`. Use `project: portfolio` in the front matter. Do not copy private values from `config.md` into the minutes; refer to hosts and accounts by role.

---
```markdown
---
department: board-meeting
project: portfolio
date: YYYY-MM-DD HH:MM
status: final | draft | blocked
---

# Board minutes, YYYY-MM-DD

## Summary
<Three sentences at most: how many projects, what the board recommends, what the user approved.>

## Meeting details
- Scope: <all projects | what $ARGUMENTS narrowed it to>
- Data sources: <GitHub plus local folders | local folders and ledger only (GitHub unavailable) | other>
- Stale threshold: <stale_after_days> days. Focus limit: <max_focus_projects>.
- Weights used: Momentum <n>, Finishability <n>, Learning <n>, Leverage <n>, Excitement <n>, Cost <n> (default | from config)
- Mode: live | dry-run (no questions asked, nothing changed)

## 1. State of the portfolio (CEO)
| Project | Ledger stage | Last commit | STALE | Real state (one line) |
|---|---|---|---|---|

Untracked repos (no ledger entry): <list, or "None.">
Disagreements between README or ledger and the commit history: <list, or "None.">

## 2. Money and effort (CFO)
| Project | Spent | Still needed | Recurring cost | Sessions or memos | Notes |
|---|---|---|---|---|---|
Unknowns are written UNKNOWN, never estimated.

## 3. Scores (strategist)
| Project | M | Fin | L | Lev | Exc | Cost | Weighted sum | Priority | Flags | Recommendation |
|---|---|---|---|---|---|---|---|---|---|---|

Arithmetic and one line of evidence per project: <below the table>

## 4. Challenges (devil's advocate)
| Project | Challenge | Changes the call? |
|---|---|---|

## 5. Resolutions
| Project | Proposed | Approved | Stage change |
|---|---|---|---|
| <name> | Focus / Maintain / Pause / Kill | YES / NO / NOT ASKED | <old stage> to <new stage>, or none |

- Focus (max <n>): <names>
- Maintain: <names>
- Pause: <names>
- Kill: <names>

Anything not approved stays as it was.

## Decisions needed
<Open questions for the user, with options and a recommendation. "None." if none.>

## Decisions made
- YYYY-MM-DD HH:MM <question and the user's answer, one line each, including excitement answers>

## Ledger changes
- <project>: Stage <old> to <new>. Next action: <text>.
(Or "None. No resolutions were approved.")

## Handoffs
- To /<department>: <what and why>

## Appendix
### chair
<Agenda notes. Verdict.>
### ceo
<Commands run and what they showed, trimmed. Verdict.>
### cfo
<Sources for each figure. Verdict.>
### strategist
<Full arithmetic. Verdict.>
### devils-advocate
<Full arguments, including why any held recommendation survives. Verdict.>
```

---

# State-of-the-project note template

Written for each project the user approves to Pause or Kill, so it can be restarted (or cleanly closed). Save it as `<project>/.company/YYYY-MM-DD_HHMM_board-meeting_state-of-project.md`. If the project has no local folder, put it in the minutes' Appendix under the project's name. Keep it under one page. Base it on the repo and memos, not on memory, and do not include secrets or private config values.

```markdown
---
department: board-meeting
project: <project id>
date: YYYY-MM-DD HH:MM
status: final
---

# State of the project: <project>

## Decision
<Paused | Killed> on YYYY-MM-DD. Reason in one or two sentences.
Restart trigger: <what would make this worth reviving, or "None; killed".>

## What it is
One paragraph: the goal, in measurable terms if it has them.

## Where it stands
- Stage when stopped: <stage>. Last commit: <date, short hash>.
- Done: <bullets>
- In progress or half-done: <bullets, with file paths>
- Known broken: <bullets>

## How to restart
1. <Where the code is and how to run it.>
2. <What to read first: README sections, memos, notes.>
3. <The very next task, concrete enough to start without thinking.>

## Open decisions and risks
- <Decision or question, with the options known so far>

## Parts, accounts and costs still running
- <Anything bought, owned or billed. Say what to cancel if killed, as a suggestion only; cancelling needs the user's approval.>

## Links
- Repo: <owner/repo or none>. Memos: <paths>. Last board minutes: <path>.
```
