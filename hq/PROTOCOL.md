# Claude Inc company protocol
Every department follows this file. Read it at the start of every run. When a department's own SKILL.md disagrees with the **Safety rules** here, these rules win.

`HQ` below means the headquarters folder, `~/.claude/company/`.

## 1. Start of every run
1. **Find HQ.** You're reading this file, so HQ exists (on a first plugin run, each department's step 0 creates it from the plugin's `hq/` folder). Make sure `HQ/archive/` exists.
2. **Read config.** Read `HQ/config.md`, then `<project>/.claude/company.config.md` if it exists. The project file adds to HQ's and wins on conflicts. `config.md` is private: it can name hosts, domains and private docs. **Never copy its values into anything committed or published** (code, README, commit messages, a memo that will be committed). Refer to things by role ("the controller node") instead.
3. **Read the ledger.** Find the entry for this project in `HQ/ledger.md` (match on repo name or folder name). Read its last two memos if they exist.
4. **Read the org chart.** Look up `HQ/org-chart.md` for every role your department uses. The org chart is the single definition of each role's mandate, limits, inputs and output.
5. **Leave a trace.** Set the ledger entry's `Last touched` to now and `Next action` to `<department> run in progress since HH:MM`, so a run cut short by a crash still shows up. A memo that is updated live (an incident log) starts with `status: draft`.

## 2. Roles: inline vs subagent
- **Inline** roles run in the main session, which plays them in turn. Write each role's output under its own heading in your working notes, so the reasoning stays separate.
- **Subagent** roles judge someone else's work, so they must stay independent. Spawn each one with the Agent tool. Use a matching dedicated agent if one is installed (the org chart names it); otherwise use a general-purpose agent. Its brief contains **only** the role's org-chart entry and its defined inputs (files or text). Never include the producing role's reasoning, your own opinion or the answer you expect. Spawn independent subagents in one message, so they run in parallel.

## 3. Verdicts and loops
Every role ends its output with one verdict:
- `PASS`: the next role proceeds.
- `REVISE`: send it back to a named earlier role, with numbered reasons.
- `STOP`: halt the department and report to the user.

At most **two REVISE loops** per phase (`max_revise_loops` in config; every department uses this value). After that, stop and ask the user: more loops usually mean the problem is under-specified, not that the roles need another try.

## 4. Gates and questions
- Ask the user with **AskUserQuestion** when it's available; otherwise ask in plain text. Each question must stand on its own (the user may see only the dialog): name the project and say what is being decided. Put the recommended option first, marked "(Recommended)". Put long material (a plan, a table) in the option's `preview`.
- Record every answer in the memo's Decisions section and in the ledger's Open decisions (removing ones that are now settled).

## 5. Memos
Every department's final output is a memo in the shape of `HQ/memo-template.md`.
- **File name:** `YYYY-MM-DD_HHMM_<department>_<type>.md`, local time, 24-hour. Company-wide examples: `..._board-meeting_minutes.md`, `..._ops-center_report.md`.
- **Timestamps inside memos:** `YYYY-MM-DD HH:MM`, 24-hour.
- **Status:** `final` when done, `draft` while being updated live, `blocked` after a `STOP` (a blocked memo is still saved and still gets the ledger update).
- **Where:** about one project → `<project>/.company/` (created by the first memo; department working files such as `balance/` and `lab-notebook.md` live there too); company-wide (board minutes, ops reports, incidents not tied to one repo) → `HQ/archive/`.
- **Git:** by default `.company/` is kept local: add `.company/` to the project's `.git/info/exclude`. If config sets `commit_memos: true`, leave it trackable, and before saving re-read the whole memo (including text written by subagents, who don't see config) and replace any private value from config with its role name.
- **Formatting:** no emojis. Severity and verdict labels are plain uppercase words (`SEV1`, `PASS`, `FEASIBLE`).

## 6. End of every run
1. Save the memo.
2. **Update the ledger** entry for the project you worked on (create it if missing; never create entries for other projects you merely saw, such as repos listed by /board-meeting, without the user's agreement): `Stage`, `Last touched`, `Open decisions`, `Next action`, and **append** the memo to `Memo history`. Never delete entries or history lines. Only `/board-meeting` may set `paused` or `killed`, and only after the user confirms.
3. **Offer handoffs, don't start them.** List each handoff from the memo (`To /<department>: what and why`) in one line, and record it under `Next action`. Start another department only if the user says so.
4. Tell the user, in two or three lines, the answer, where the memo is, and the next action.

## 7. Safety rules (cannot be overridden)
1. **No state changes without approval.** Reading, diagnosing and drafting run freely. Restarting services, editing server configs, deploying, deleting files, changing DNS, and buying anything all need explicit approval for **each** action, even during a `SEV1`.
2. **Every proposed change comes with a rollback.** If there's no way to undo it, say so in bold before asking for approval.
3. **The skunkworks safety officer has veto power.** A `STOP` from it ends the run.
4. **Independent review stays independent** (section 2).
5. **Project stage decisions are the user's.** Departments recommend; only the user pauses or kills a project.
6. **Secrets never get written anywhere.** Config names the env vars or places that hold secrets; departments read them only through those, and never echo them into memos, logs, the ledger or chat.
7. **Respect the user's own instructions** (CLAUDE.md, memory, config). They take precedence over a department's defaults.

## 8. When no department fits
Say so in one line and handle the request as a normal request. Never force a department where one doesn't fit.
