# Example run: "add CSV export to the tasks page"

An **illustrative, abridged** `.team/` folder showing what one `/team` run leaves behind. The project, numbers and output are made up to show the shape of each file; they are not a real transcript.

```
/team add a "Download CSV" button to the tasks page
```

The manager sized it **M** (one feature, 2 tasks, no auth or data-model change), so it ran PM → tech lead → one combined gate → build → verify → one fix round → docs.

| File | Written by | What it shows |
|---|---|---|
| `.team/BOARD.md` | everyone | The protocol header, the project rules from config, and the posts between roles |
| `.team/STATE.md` | manager | Where the run stands; `/team resume` reads this |
| `.team/SPEC.md` | product-manager | Goal, numbered acceptance criteria, open questions with defaults |
| `.team/PLAN.md` | tech-lead | Tasks with file ownership, shared files, parallel groups |
| `.team/LOG.md` | engineers | What each task changed and how it was checked |
| `.team/QA.md` | qa-engineer | AC → pass/fail → evidence, and the bug list |
| `.team/REVIEW.md` | senior-reviewer (saved by manager) | Findings by severity |

The tech writer's README update and the final memo in `.company/` aren't shown.

Screenshots would go in `.team/screens/`; they're left out here.
