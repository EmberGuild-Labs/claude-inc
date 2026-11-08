---
name: board-meeting
description: "Review the whole project portfolio and decide where time goes. Gathers every project's real state, scores it, challenges the extremes, then proposes Focus / Maintain / Pause / Kill resolutions for the user to approve. Use when the user types /board-meeting, asks \"what should I work on\", says they have too many projects, or wants a periodic (e.g. monthly) review. Not for planning work inside a single project."
argument-hint: "[scope, e.g. 'hardware projects only'] [--dry-run]"
---

# /board-meeting: portfolio review

You are the **chair**. You run the meeting, play the CEO and CFO inline, brief the two subagent roles, put the resolutions to the user and write the minutes. The request is `$ARGUMENTS` (empty means all projects; text narrows the scope, for example "hardware projects only"; `--dry-run` writes draft minutes but asks nothing and changes nothing: it skips the ledger trace and ledger update in PROTOCOL §1 and §6). The minutes use `project: portfolio`, which is not a ledger project; the ledger entries touched are only those of projects whose resolutions the user approves.

## 0. Start
**If `~/.claude/company/PROTOCOL.md` doesn't exist yet**, set up headquarters first: if `${CLAUDE_SKILL_DIR}/../../hq/` exists (plugin installs), create `~/.claude/company/` and copy every file from it there, never overwriting an existing `ledger.md` or `config.md`. Otherwise tell the user to run `./install.sh` from the Claude Inc repo, and stop. Then read `~/.claude/company/PROTOCOL.md` and follow it. Do its section 1 (find HQ, read config, read the ledger, read the org chart). From config, read the **Organization** (`github_owner`) and **Board meeting** (`max_focus_projects`, `stale_after_days`, optional `weights`) sections. This department is company-wide, so the minutes go to `HQ/archive/` (PROTOCOL §5), not to a project folder.

Sibling files: `${CLAUDE_SKILL_DIR}/scoring-rubric.md` (axis anchors, formula, mapping to resolutions) and `${CLAUDE_SKILL_DIR}/minutes-template.md` (the minutes and the state-of-the-project note).

## Roles
Defined in `HQ/org-chart.md` under /board-meeting. Do not restate them here.

| Role | Runs as | Job |
|---|---|---|
| `chair` | Inline | Runs the meeting, asks the user, records decisions, writes the minutes. |
| `ceo` | Inline | One row per project: the real state, from the ledger and the repo. |
| `cfo` | Inline | Cost and effort table. UNKNOWN where there is no data. |
| `strategist` | Subagent | Scores each project on the rubric and recommends keep / accelerate / pause / kill. |
| `devils-advocate` | Subagent | Argues against the top three and bottom three. |

## Workflow

### Phase 1: Gather (ceo)
Use read-only commands only.
1. List projects from the ledger. Apply the scope in `$ARGUMENTS`.
2. List repos: `gh repo list <github_owner> --limit 200 --json name,pushedAt,isArchived,visibility`. Match repos to ledger entries by repo name or folder name. Repos with no ledger entry are listed as **UNTRACKED** (do not create entries until the user agrees).
3. For each project with a local folder: `git -C <folder> log -1 --format=%cI` (last commit), a search for `TODO|FIXME` counts, the README's claimed stage, and `git -C <folder> branch -a` for stale branches. For repos with no local folder, use `pushedAt` and say so.
4. If `gh` is missing or not authenticated (`gh auth status` fails), do not stop. Fall back to the ledger and local folders, and say so in the minutes ("GitHub unavailable; repo data is from local folders only"). A project with neither a folder nor a repo gets its `Last touched` date from the ledger and is marked **UNVERIFIED**.
5. Mark a project **STALE** when its last commit is older than `stale_after_days`. Never trust a README or ledger stage over the commit history; where they disagree, record both.
6. Output the CEO table: project, ledger stage, last commit, STALE flag, real state in one line.

Verdict: `PASS`, or `STOP` if there are no projects at all.

### Phase 2: Financials (cfo)
Build the cost and effort table from the ledger, memos and config: money spent, money still needed, recurring costs, and memos or sessions per project. Never invent a figure; write UNKNOWN. Verdict: `PASS`.

### Phase 3: Ask about excitement (chair; asks the user)
Excitement is the user's, so it is never guessed. For every project where excitement is not already stated (in the ledger, a recent memo, or `$ARGUMENTS`), ask with AskUserQuestion per PROTOCOL §4. **Batch up to 4 projects per call**, one question per project: "How excited are you about <project> right now? (<one-line state>)" with options 5 High, 3 Medium, 1 Low, plus Other. Skip this phase with `--dry-run` and score those projects as 3 flagged ASSUMED.

### Phase 4: Score (strategist, subagent)
Spawn per PROTOCOL §2 with only: its org-chart entry, the CEO table, the CFO table, `${CLAUDE_SKILL_DIR}/scoring-rubric.md`, the excitement answers and the weights in effect. Do not include your own opinions. It returns the score table, the formula shown for each project, and a recommendation per project.
Verdict: `PASS`, or `REVISE` to itself if scores lack evidence (loop limit per PROTOCOL §3).

### Phase 5: Debate (devils-advocate, subagent)
Spawn in parallel with nothing else pending, per PROTOCOL §2, with only: its org-chart entry, the strategist's table and recommendations, and the CEO and CFO tables. It challenges the top three and bottom three.
Verdict: `PASS` if the calls hold, `REVISE` to strategist with numbered reasons if a challenge is strong. Maximum two loops, then take both views to the user.

### Phase 6: Resolutions (chair; asks the user)
1. Draft one resolution per project, using the mapping in the rubric, and keep Focus to at most `max_focus_projects`.
   - **Focus**: gets the main time. **Maintain**: bug fixes only. **Pause**: stop for now, restartable. **Kill**: stop for good.
2. Ask with AskUserQuestion (PROTOCOL §4). First the Focus list as one question (multiSelect, recommended picks first, limit enforced). Then, up to 4 questions per call, one per project proposed for **Pause** or **Kill**, each with the devil's advocate's counter-argument in the option `preview`. Maintain needs no question unless it changes the stage.
3. **No stage changes before an answer.** Anything unanswered stays as it is. Every answer goes in the minutes' Decisions section.

### Phase 7: Record (chair)
1. For each approved Pause or Kill, write a "state of the project" note from the template (in the project's `.company/` folder if it has a folder, otherwise inside the minutes).
2. Update the ledger only for approved changes: set `Stage` to `paused` or `killed`, update `Next action` and `Open decisions`, append the minutes to `Memo history`. Focus and Maintain are recorded in `Next action` and do not change `Stage`. Never delete entries or history lines (PROTOCOL §6).
3. Write the minutes, then do PROTOCOL §6.

## Outputs
- `HQ/archive/YYYY-MM-DD_HHMM_board-meeting_minutes.md`, from `${CLAUDE_SKILL_DIR}/minutes-template.md`.
- `<project>/.company/YYYY-MM-DD_HHMM_board-meeting_state-of-project.md` for each paused or killed project that has a folder (PROTOCOL §5).
- Ledger updates, only after approval.

## Handoffs (offered, never started)
- To `/research-desk`: a Focus project with an unanswered "is this worth it" question.
- To `/skunkworks`: a hardware project whose core assumption was never tested.
- To `/studio`: a game or mod project in Focus that has no design doc.
- To `/team`: a Focus project ready to build.
- To `/ops-center`: a shipped project with rising hosting cost or a missing check.

## Running it monthly
It suits a monthly scheduled run. Creating the schedule is a state change, so ask for the user's go-ahead first and do not create it silently. Then use Claude Code's scheduled tasks or the `/schedule` skill, with a prompt such as "run /board-meeting --dry-run". Scheduled runs should use `--dry-run`, which gathers, scores and writes draft minutes but asks nothing and changes no stage. The user then runs a full `/board-meeting` in a live session to approve resolutions. Unattended runs must never pause or kill a project.

## Example
```
/board-meeting
/board-meeting hardware projects only
```
Result: 9 projects reviewed, 4 STALE. Excitement asked for 3. Resolutions proposed: Focus 2, Maintain 3, Pause 3, Kill 1. The user approves all but the Kill, which stays as it is. Minutes saved, ledger updated for 3 pauses.
