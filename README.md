# Claude Inc

A suite of [Claude Code](https://claude.com/claude-code) skills that run your work like a small company. Each **department** is a skill with its own roles, workflow and deliverables. One front-desk command, `/company`, works out which department a request belongs to and routes it there. All departments share one org chart, one project ledger and one memo format, so they work from the same picture of what you're doing.

```
/company my reverse proxy is returning 502s on three subdomains
  -> Routing to /war-room (an outage on a live site).

/skunkworks can I build a coilgun that gets a steel ball to 30 m/s
  -> called directly, no routing

/team add a "Download CSV" button to the tasks page
  -> a full software team builds it, with your approval at each gate
```

---

## Contents
1. [Why](#why)
2. [Departments](#departments)
3. [How routing works](#how-routing-works)
4. [Installation](#installation)
5. [Configuration](#configuration)
6. [Directory layout](#directory-layout)
7. [Shared infrastructure](#shared-infrastructure)
8. [Department reference](#department-reference): [/war-room](#war-room) · [/skunkworks](#skunkworks) · [/studio](#studio) · [/board-meeting](#board-meeting) · [/research-desk](#research-desk) · [/ops-center](#ops-center) · [/team](#team)
9. [Cross-department handoffs](#cross-department-handoffs)
10. [Output conventions](#output-conventions)
11. [Safety rules](#safety-rules)
12. [Adding a department](#adding-a-department)
13. [Notes and decisions](#notes-and-decisions)
14. [Roadmap](#roadmap)
15. [License](#license)

---

## Why
A single Claude session tends to do whatever you ask, in the order you ask it. That's fine for small tasks. It works badly for:

- **Incidents**, where it starts changing things before anyone has worked out what's broken.
- **Ambitious hardware**, where it starts designing an enclosure before anyone has checked the physics.
- **Game systems**, where mechanics get written without anyone balancing the numbers or trying to break them.
- **Software features**, where code gets written before anyone agreed what "done" means, and nobody independent tests or reviews it.
- **A large project portfolio**, where nobody steps back to ask which projects deserve the time.

Departments fix this by putting the right roles in the right order, with gates between phases. Each role has one job and a defined output, and the next role works from that output instead of from a vague chat history. Roles whose job is to judge someone else's work run as **separate subagents**, so the work never grades itself.

---

## Departments
| Command | Department | Use it when | Main deliverable |
|---|---|---|---|
| `/war-room` | Incident response | Something is broken right now | Incident log + postmortem |
| `/skunkworks` | Moonshot R&D lab | You want to know whether a hard build can work at all | Feasibility report + minimum test plan |
| `/studio` | Game studio | Designing, balancing or testing a game or mod system | Design doc + balance sheet + QA report |
| `/board-meeting` | Portfolio review | Deciding what to work on across all projects | Board minutes with focus / maintain / pause / kill decisions |
| `/research-desk` | Research team | Investigating an idea before committing to it | Research brief with sources |
| `/ops-center` | Standing operations | Routine homelab health, capacity and cost review | Weekly ops report |
| `/team` | Product and engineering | Building, fixing or shipping software end to end | Working, tested, reviewed code + report |
| `/company` | Front desk | You don't want to pick a department | Routes to one of the above |

---

## How routing works
`/company` is the chairman's office. It doesn't do the work itself. It:

1. **Reads the request** and checks the project ledger for context (which project, its current stage, past memos).
2. **Classifies it** with the routing table (`skills/company/routing.md`).
3. **Announces the routing** in one line, e.g. `Routing to /war-room (an outage on a live site).`
4. **Hands off** by loading the department's skill with the request and the matching ledger entry.
5. **Checks the ledger** was updated when the department finishes, and offers any queued follow-up.

### Routing table
| Signal in the request | Department |
|---|---|
| "down", "broken", "502", "outage", "not responding", error output from a running service, a deploy that just went wrong | `/war-room` |
| "can I build", "is it possible", "how fast / how strong / how cold", physics, high energy, novel hardware | `/skunkworks` |
| game, mod, mechanic, balance, economy, level, Godot, Unity, NeoForge, Fabric, KSP | `/studio` |
| "what should I work on", "too many projects", priorities, "review everything", monthly or quarterly review | `/board-meeting` |
| "look into", "what exists", "prior art", "is this worth it", comparisons, an unfamiliar domain | `/research-desk` |
| uptime, disk, capacity, certs, "weekly check", "how's the homelab" | `/ops-center` |
| build / add / implement a feature, fix a bug in code (not a live outage), refactor, "ship", "deploy this" | `/team` |

### Ambiguous requests
If a request fits two departments, `/company` picks the one that has to run **first** and records the second as a follow-up:

- "Is a coilgun worth building and what would it take" → `/research-desk` first (does it exist, is it worth it), then `/skunkworks` (can it work).
- "The in-game market is crashing the server" → `/war-room` first (restore service), then `/studio` (why the design allowed it).
- "Add a trading system to my mod" → `/studio` first (design and balance), then `/team` (build it).
- "The signup form 500s on empty input" with no users affected right now → `/team fix`, not `/war-room`.

If nothing fits, `/company` says so and handles the request normally. It never forces a department where one doesn't fit.

### Direct calls
Every department can be called directly (`/ops-center`, `/team`, and so on). A direct call skips routing but still reads and updates the shared ledger.

---

## Installation
Two ways to install. Both give you the same departments; they differ in how commands are named.

### A. Personal skills: short commands (`/war-room`, `/team`)
```bash
git clone https://github.com/EmberGuild-Labs/claude-inc.git
```
```bash
cd claude-inc && ./install.sh
```
`install.sh`:
1. Copies each folder in `skills/` to `~/.claude/skills/<name>/`, and the `/team` agents in `agents/` to `~/.claude/agents/`.
2. Creates headquarters at `~/.claude/company/` with `PROTOCOL.md`, `org-chart.md`, `memo-template.md`, and (only if they don't exist yet) an empty `ledger.md` and a `config.md` to fill in. **It never overwrites your ledger or config.**
3. Records what it installed in `~/.claude/company/.installed`, and prints the commands.

If a skill or agent with the same name already exists and Claude Inc didn't install it, `install.sh` stops and lists it. `./install.sh --force` backs those up to `~/.claude/backups/claude-inc-<timestamp>/` and replaces them. `./install.sh --dry-run` shows what would happen.

To uninstall:
```bash
./uninstall.sh            # removes only what install.sh installed; keeps ~/.claude/company/ (ledger, config, memos)
```
```bash
./uninstall.sh --purge    # also removes ~/.claude/company/
```
To update, `git pull` and run `./install.sh` again.

### B. Plugin: one-click install, prefixed commands (`/company:war-room`)
In Claude Code:
```
/plugin marketplace add EmberGuild-Labs/claude-inc
/plugin install company@claude-inc
```
Claude Code namespaces plugin skills and agents, so commands become `/company:company`, `/company:war-room`, `/company:team` and so on, and the agents become `company:engineer` etc. The upside is that nothing can clash with skills or agents you already have. The first department you run creates `~/.claude/company/` from the plugin's `hq/` folder.

Pick one method, not both, or you'll see every department twice.

---

## Configuration
`~/.claude/company/config.md` holds everything specific to you. It's private: install never overwrites it, and departments never copy its values into a project, a commit or a committed memo. A project can add `<project>/.claude/company.config.md` on top (keep it out of git if it holds anything private).

| Section | Used by | What goes there |
|---|---|---|
| Organization | all, /board-meeting | Your name or org, GitHub owner, default repo visibility (private) |
| Paths | all | Whether memos are committed (`commit_memos`, default false) |
| Project rules | all, /team | Short house rules every role follows (e.g. "apps run under a URL path prefix") |
| Security context | /team, /war-room, /ops-center | What's at stake, what must never leak |
| Private docs | all | Paths to your own runbooks; read at runtime, never copied |
| Homelab | /ops-center, /war-room | SSH aliases, URLs to check, optional Proxmox API, extra read-only checks, runbook notes |
| Deploy | /team | A recipe from `skills/team/deploy-recipes/`, or your own steps |
| Thresholds | /ops-center | Cert, disk, RAM and response-time warning levels |
| Board meeting | /board-meeting | Max focus projects, staleness, scoring weights |
| Research | /research-desk | Extra excluded domains |
| Loops | all | Max REVISE loops (default 2) |

**Secrets never go in config.** It names the environment variable, SSH alias or password-manager entry that holds them (`proxmox_token_env: PROXMOX_TOKEN`).

---

## Directory layout

### Repository
```
claude-inc/
├── README.md  LICENSE  install.sh  uninstall.sh
├── .claude-plugin/          plugin.json, marketplace.json
├── hq/                      copied to ~/.claude/company/
│   ├── PROTOCOL.md          the rules every department follows
│   ├── org-chart.md         every role, defined once
│   ├── memo-template.md     standard memo format
│   ├── ledger.md            empty ledger
│   └── config.md            config template
├── agents/                  the /team roles (subagents)
├── skills/
│   ├── company/             SKILL.md (router), routing.md
│   ├── war-room/            SKILL.md, runbook-checks.md, postmortem-template.md
│   ├── skunkworks/          SKILL.md, feasibility-template.md, safety-gates.md
│   ├── studio/              SKILL.md, design-doc-template.md, balance-sheet-template.md
│   ├── board-meeting/       SKILL.md, scoring-rubric.md, minutes-template.md
│   ├── research-desk/       SKILL.md, source-rules.md, brief-template.md
│   ├── ops-center/          SKILL.md, report-template.md, checks/{_lib,uptime,certs,disk,proxmox}.sh
│   └── team/                SKILL.md, templates/{BOARD,STATE}.md, deploy-recipes/
└── examples/csv-export/     an illustrative /team run
```

### Installed
```
~/.claude/
├── skills/{company,war-room,skunkworks,studio,board-meeting,research-desk,ops-center,team}/
├── agents/{product-manager,tech-lead,engineer,...}.md
└── company/                 headquarters: shared state
    ├── PROTOCOL.md  org-chart.md  memo-template.md
    ├── config.md            yours, private
    ├── ledger.md            one entry per project
    └── archive/             company-wide memos (board minutes, ops reports, incidents not tied to a repo)
        └── ops-raw/         raw ops check output (JSON)

<any-project>/
├── .company/                project memos, e.g. 2026-11-08_1423_war-room_incident.md
└── .team/                   /team's working files for the current run
```

---

## Shared infrastructure

### Protocol (`PROTOCOL.md`)
The one file every department reads first. It covers finding headquarters, reading config and the ledger, how inline and subagent roles run, verdicts and loop limits, how gates ask you questions, memo naming and location, end-of-run duties and the safety rules. Departments reference it instead of repeating it, so a rule changes in one place.

### Org chart (`org-chart.md`)
Every role is defined once, with a **Mandate**, what it must **Never** do, its **Inputs**, its **Output** and how it **Runs as**:

- **Inline:** the main session plays the role. Used for roles that need the whole conversation, such as the incident commander.
- **Subagent:** a separate agent that sees only its defined inputs. Used for every role that judges someone else's work (skeptic, safety officer, QA tester, fact-checker, strategist, postmortem author, all of /team's reviewers), so it can't just agree with the producer.

### Project ledger (`ledger.md`)
One entry per project:
```markdown
## coilgun
- **Stage:** idea | research | feasibility | design | building | shipped | paused | killed
- **Repo:** <owner>/coilgun (or none)
- **Folder:** ~/projects/coilgun
- **Owner department:** skunkworks
- **Last touched:** 2026-11-08 14:23
- **Open decisions:** capacitor bank voltage (200 V vs 400 V)
- **Next action:** build single-stage test rig
- **Memo history:**
  - 2026-11-05 10:02 research-desk brief -> .company/2026-11-05_1002_research-desk_brief.md
  - 2026-11-08 14:23 skunkworks feasibility -> .company/2026-11-08_1423_skunkworks_feasibility.md
```
- Departments mark the entry when a run starts (so a crashed session still leaves a trace), **append** to memo history, and **update** stage and next action. They never delete entries.
- Only `/board-meeting` can set `paused` or `killed`, and only after you confirm.
- The first department to touch a project creates its entry.

### Memos (`memo-template.md`)
Every department's final output has the same shape (frontmatter with department, project, date and status, then Summary, Findings, Decisions needed, Decisions made, Handoffs and Appendix), so any department can read any other's output.

### Verdicts and loops
Inside a department, each role ends with `PASS` (next role proceeds), `REVISE` (back to a named earlier role, with reasons) or `STOP` (halt and report to you). At most **two REVISE loops** per phase; after that the department stops and asks you, because more loops usually mean the problem is under-specified.

### Gates
When a department needs your decision, it asks with Claude Code's question dialog: one click to approve, the recommended option first, details in the preview, and "Other" for edits.

---

## Department reference

<a id="war-room"></a>
### /war-room: incident response
**Use it when** something is broken now: a site is down, a service is crashing, a deploy went wrong, a device stopped responding.

| Role | Runs as | Job |
|---|---|---|
| Incident commander | Inline | Owns the incident: severity, hypotheses, resolution call |
| Investigator | Inline | Gathers evidence with read-only commands |
| Fixer | Inline | Proposes the smallest fix with a rollback; applies it only after approval |
| Scribe | Inline | Timestamped log of every observation and action |
| Postmortem author | Subagent | Blameless postmortem from the scribe's log only |

**Workflow:** declare (`SEV1` fully down · `SEV2` degraded · `SEV3` internal) → stabilize with the first-five-minutes checklist (`runbook-checks.md`, plus your config's runbook notes and extra checks) → up to three ranked hypotheses → fix (**every state change needs your approval, even in a SEV1**) → verify (status, health endpoint, logs clean for 5 minutes) → postmortem with action items tagged by owning department.

**Outputs:** `.company/<date>_<time>_war-room_incident.md` (live log), `..._war-room_postmortem.md`, handoffs to `/ops-center` for monitoring gaps. Incidents not tied to one repo go to `~/.claude/company/archive/`.
```
/war-room the status page returns 502 since about 09:40, other sites fine
```

<a id="skunkworks"></a>
### /skunkworks: moonshot R&D lab
**Use it when** you want to know whether an ambitious physical build can work at all, before buying parts or designing enclosures. **Principle:** prove feasibility with the cheapest possible experiment.

| Role | Runs as | Job |
|---|---|---|
| Chief scientist | Inline | Goal as a number with units; constraints |
| Theorist | Inline | First-principles math, units checked, assumptions listed |
| Skeptic | Subagent | Attacks the numbers; recomputes key figures independently |
| Experimentalist | Inline | Smallest single-variable test, test-only parts list |
| Safety officer | Subagent | Hazard review with **veto power** (`safety-gates.md`) |
| Lab manager | Inline | Appends to the lab notebook |

**Workflow:** define → theory → challenge → verdict (`FEASIBLE` · `FEASIBLE WITH CHANGES` · `NOT FEASIBLE AT THIS SCALE` · `UNKNOWN`) → minimum experiment → safety gate (must `PASS`) → notebook.

**Outputs:** `.company/<date>_<time>_skunkworks_feasibility.md`, `.company/lab-notebook.md` (append-only), handoff to `/research-desk` for prior art.
```
/skunkworks multi-stage coilgun, steel ball bearing, target 30 m/s, budget around $150
```

<a id="studio"></a>
### /studio: game studio
**Use it when** designing, balancing or testing systems in a game or mod (Minecraft modloaders, Godot, Unity, KSP mods).

| Role | Runs as | Job |
|---|---|---|
| Creative director | Inline | The vision; settles disputes; ship / revise / cut |
| Game designer | Inline | The mechanic: rules, actions, feedback, progression |
| Systems designer | Inline | The numbers: balance sheet plus a real simulation |
| Programmer | Inline | Implements against the design doc |
| QA tester | Subagent | Exploits, dupes, softlocks, multiplayer abuse |
| Player advocate | Subagent | New-player clarity, fun and confusion |

**Workflow:** pitch → design doc → balance (simulate, e.g. 100 in-game days of an economy, looking for inflation and dead or dominant strategies) → paper playtest by QA and the player advocate *before code* → build (optional; large builds can go to `/team`) → test → ship decision.

**Outputs:** `.company/<date>_<time>_studio_design.md`, `.company/balance/<system>.csv`, the simulation script `<system>_sim.py` and its results `<system>_runs.csv`, `.company/<date>_<time>_studio_qa.md`.
```
/studio a player-run stock exchange: towns issue shares, players trade, dividends come from town trade volume
```

<a id="board-meeting"></a>
### /board-meeting: portfolio review
**Use it when** you need to step back and decide where your time goes. Works well monthly.

| Role | Runs as | Job |
|---|---|---|
| Chair | Inline | Runs the meeting, proposes resolutions, records decisions |
| CEO | Inline | Each project's real state from the ledger and its repo |
| CFO | Inline | Money and time per project |
| Strategist | Subagent | Scores every project on the rubric |
| Devil's advocate | Subagent | Argues against the top and bottom recommendations |

**Workflow:** gather (ledger plus repos under your configured GitHub owner, read-only) → financials → your excitement per project (asked when unknown) → score (Momentum, Finishability, Learning value, Leverage, Excitement, Cost to continue; weights in config) → debate → resolutions: **Focus** (max 3), **Maintain**, **Pause**, **Kill**. **No project changes stage until you approve.** Paused and killed projects get a "state of the project" note so they can be restarted. `--dry-run` writes draft minutes and changes nothing, for scheduled runs.

**Outputs:** `~/.claude/company/archive/<date>_<time>_board-meeting_minutes.md`, an updated ledger after approval.
```
/board-meeting
/board-meeting focus on hardware projects only
```

<a id="research-desk"></a>
### /research-desk: research team
**Use it when** an idea is at "is this worth doing": what exists, what it costs, whether it's a good use of time.

| Role | Runs as | Job |
|---|---|---|
| Editor | Inline | Frames 3-6 questions; decides when the brief is done |
| Literature scout | Inline | Prior art: projects, products, papers, datasheets, repos |
| Feasibility analyst | Inline | Difficulty, cost, time, skills, with citations |
| Fact-checker | Subagent | Checks every claim against its cited source |

**Source rules:** official docs, datasheets, peer-reviewed papers, standards bodies, manufacturers and established publications are preferred. Reddit, Quora, content farms, SEO listicles and AI summary sites are excluded (plus anything in config). Every factual claim needs a link; unsourced claims are marked `UNVERIFIED` or cut.

**Output:** `.company/<date>_<time>_research-desk_brief.md` with a bottom line, what exists, what's novel, cost and difficulty, and `PURSUE` / `MODIFY` / `DROP`.
```
/research-desk near-IR telescope using a modified webcam sensor, what exists and what does it cost
```

<a id="ops-center"></a>
### /ops-center: standing operations
**Use it when** you want routine homelab health checks, as opposed to `/war-room`, which runs only while something is broken. Designed to run weekly.

| Role | Runs as | Job |
|---|---|---|
| SRE | Inline | Runs the checks; status per service |
| Capacity planner | Inline | Days until each resource hits its limit |
| Cost analyst | Inline | Renewals, hosting, power, subscriptions |
| Security watch | Inline | Certs, pending updates, exposed ports, old images |
| On-call lead | Inline | Writes the report, assigns follow-ups |

| Script | Checks | Warns at |
|---|---|---|
| `uptime.sh` | HTTP status and response time for each configured URL | non-2xx, or over 2000 ms |
| `certs.sh` | TLS expiry for each https URL | under 21 days |
| `disk.sh` | Disk per mount (and RAM on Linux) on each SSH host | over 80% (RAM 90%) |
| `proxmox.sh` | Proxmox node and guest status via its API (optional) | stopped guests, RAM over 90% |

The scripts are **read-only**, take targets as arguments (`disk.sh local` checks this machine; `PROXMOX_INSECURE=1` accepts a self-signed Proxmox certificate), print one JSON object per line, work on macOS and Linux, and need only `curl`, `openssl`, `ssh` and `perl` (plus `python3` for Proxmox). SSH uses BatchMode, so it never waits for a password. Your config can add **extra read-only checks** (for example your deploy tool's status command). `/ops-center` never restarts, updates or changes anything: urgent problems go to `/war-room`, routine ones become follow-ups.

**Outputs:** `~/.claude/company/archive/<date>_<time>_ops-center_report.md`, raw JSON in `archive/ops-raw/<date>.json` for other tools such as a status dashboard.
```
/ops-center
/ops-center certs only
```

<a id="team"></a>
### /team: product and engineering
**Use it when** you want software built, fixed or shipped end to end, with planning, independent testing and review. `/team` is the one department with dedicated agents (in `agents/`), and the main session plays the engineering manager: it sizes the work, staffs each phase, runs the board and holds the gates.

| Role | Agent | Does | Writes |
|---|---|---|---|
| Product manager | `product-manager` | Request → spec + numbered acceptance criteria | `.team/SPEC.md` |
| Tech lead | `tech-lead` | Spec → architecture + tasks with file ownership; root cause in fix mode | `.team/PLAN.md` |
| UI designer | `ui-designer` | Design brief, UI tasks, review of rendered screens | `.team/DESIGN.md` |
| Engineer | `engineer` | One task each, several in parallel | code + `.team/LOG.md` |
| QA engineer | `qa-engineer` | Every acceptance criterion, in a real browser for web UI | tests + `.team/QA.md` + `.team/screens/` |
| Senior reviewer | `senior-reviewer` | Read-only code review | manager saves it to `.team/REVIEW.md` |
| Security engineer | `security-engineer` | Read-only security review | manager saves it to `.team/SECURITY.md` |
| Tech writer | `tech-writer` | README and docs | `README.md` |
| Release engineer | `release-engineer` | Deploys with your recipe, verifies live | `.team/RELEASE.md` |

```
/team add a "Download CSV" button to the tasks page
/team --size l build a status page with an admin view
/team --fast add dark mode to the docs site
/team fix the contact form returns 500 when the message is empty
/team --deploy build a link shortener
/team ship
/team resume
```

| Flag | Effect |
|---|---|
| `--size s\|m\|l` | Override the automatic size |
| `--fast` | One gate at most, no UI review, security only if flagged, one fix round |
| `--no-gates` | Run straight through, but still stop for secrets, pushes, deploys and deletes |
| `--deploy` | Add the release phase (its approval gate always applies) |

**Sizing.** Every request is sized first, so a one-line change doesn't get nine agents:

| Size | Typical work | What runs |
|---|---|---|
| **S** | One or two files, no new interface | Manager writes a short spec and plan → one gate → one engineer → QA + review → one fix round |
| **M** | A feature in an existing project | PM → tech lead → **one combined gate** → parallel engineers → full verify → up to two fix rounds |
| **L** | New project, many parts, new UI, anything risky | Separate spec and plan gates, UI design, full verify, up to two fix rounds |

**The process (size L).**
1. **Define:** the product manager writes the spec → **you approve**
2. **Design:** the tech lead writes the plan (plus the UI designer's design brief) → **you approve**
3. **Build:** engineers run in parallel groups; each task owns specific files so they can't collide, and shared files (manifests, lockfiles, registries) go to one task
4. **Verify:** QA, senior review, security review and UI review run in parallel, on separate dev-server ports
5. **Fix loop:** findings go back to engineers; after two rounds, whatever's still open comes to you
6. **Document:** the tech writer updates the README, the manager re-runs the tests itself, and you get a final report (also saved as a memo, with the ledger updated). Commits only when you ask.
7. **Release** (`--deploy` or `/team ship`): the release engineer writes a plan with the exact commands → **you always approve** → it ships and checks the live URL and logs

**Bug-fix mode** (`/team fix <bug>`): QA reproduces the bug as a **failing** regression test → the tech lead finds the root cause → you approve → an engineer makes the test pass with the smallest fix → QA and review confirm nothing else broke.

**Resume.** If a session dies mid-run, `/team resume` reads `.team/STATE.md`, checks it against git and the engineers' log, tells you where things stand and continues. Decisions you already made stay made.

**The team board** (`.team/BOARD.md`). An append-only message board per run. Its header carries the posting protocol and your config's project rules, so every agent gets them by reading the board first. Roles post questions, heads-ups ("I changed the `/api/links` response shape"), handoffs and blockers to a role, `@all`, `@manager` or `@user`; the manager reads it after every phase and brings `@user` questions to you.

**Browser testing.** QA starts the app, opens its own tab, clicks through every user-facing criterion, checks console and network errors, tests mobile and desktop widths, and saves screenshots for the UI designer. It uses whatever browser automation the session has (Claude in Chrome, the Claude desktop app's built-in browser, a Playwright MCP server, or Playwright in your test runner). Without one it falls back to `curl` and says so; it never passes a UI check it hasn't seen.

**Deploying.** The release engineer follows a recipe: one from `skills/team/deploy-recipes/` (static over rsync, Docker Compose over SSH, Fly.io) or your own steps in config's Deploy section. Nothing that changes state runs until you approve the exact command, even with `--no-gates`.

**`.team/` folder.** `BOARD.md`, `STATE.md`, `SPEC.md`, `PLAN.md`, `DESIGN.md`, `LOG.md`, `QA.md`, `REVIEW.md`, `SECURITY.md`, `RELEASE.md`, `screens/`. Each new run archives the last to `.team/archive/<timestamp>/`. It's excluded from git locally. See [`examples/csv-export/`](examples/csv-export/) for a finished run.

---

## Cross-department handoffs
Departments pass work to each other through the **Handoffs** section of their memos. The receiving department is never started automatically: the handoff goes in the ledger's next action and is offered to you at the end of the run.

```
                        ┌──────────────┐
                        │   /company   │  routes requests, checks the ledger
                        └──────┬───────┘
   ┌───────────┬───────────┬───┴─────┬───────────┬────────────┬──────────────┐
   v           v           v         v           v            v              v
/research-  /skunkworks  /studio   /team    /war-room   /ops-center  /board-meeting
 desk

Common handoffs:
  /research-desk -> /skunkworks     idea looks worth it, check the physics
  /research-desk -> /studio         game idea has no strong prior art, design it
  /skunkworks    -> /research-desk  need prior art on a sub-problem
  /studio        -> /team           design is balanced and reviewed, build it
  /war-room      -> /ops-center     add monitoring for the failure that just happened
  /war-room      -> /team           the fix needs a real code change and tests
  /ops-center    -> /war-room       a check found something urgent
  /studio        -> /war-room       a mod system is crashing a live server
  /board-meeting -> any             "focus" projects get their next department run
  any            -> /board-meeting  a project needs a keep/kill decision
```

---

## Output conventions
- **File names:** `YYYY-MM-DD_HHMM_<department>_<type>.md`, 24-hour local time. Example: `2026-11-08_1423_skunkworks_feasibility.md`.
- **Timestamps inside memos:** `YYYY-MM-DD HH:MM`, 24-hour.
- **Location:** project memos in `<project>/.company/`; company-wide memos in `~/.claude/company/archive/`.
- **Git:** `.company/` is **kept local by default** (added to `.git/info/exclude`). Set `commit_memos: true` in config to commit memos with the code; departments then replace private config values with role names before saving.
- **Formatting:** no emojis. Severity and verdict labels are plain uppercase words (`SEV1`, `PASS`, `FEASIBLE`).

---

## Safety rules
These apply in every department and can't be overridden by a department's own instructions.

1. **No state changes without approval.** Reading, diagnosing and drafting run freely. Restarting services, editing server configs, deploying, deleting files, changing DNS and buying anything all need explicit approval for **each** action, even in `/war-room` during a `SEV1`.
2. **Every proposed change comes with a rollback.** If there's no way to undo it, the memo says so in bold before asking.
3. **The skunkworks safety officer has veto power.** It reviews every experiment for stored energy and high voltage, inductive kickback, projectiles, cryogenic and pressurized gases, heat and fire, mains voltage, and battery and chemical hazards. A `STOP` ends the run; the report explains the hazard and what would make it acceptable, which may be "only with a qualified adult or mentor present" or "don't do this."
4. **Independent review stays independent.** Subagent roles get only their defined inputs, never the producer's reasoning.
5. **Project stage decisions are yours.** Departments recommend; only you pause or kill a project.
6. **Secrets are never written anywhere:** not in memos, logs, the ledger, the board or chat.
7. **Your own instructions win.** Your CLAUDE.md, memory and config take precedence over a department's defaults.

---

## Adding a department
1. Add any new roles to `hq/org-chart.md` (reuse existing roles where you can).
2. Create `skills/<name>/SKILL.md` with frontmatter `name` and a `description` that says when to use it (and when not), then: step 0 "read PROTOCOL.md", a roles table, numbered phases with verdict gates, output paths following the conventions above, and allowed handoffs. Reference sibling files as `${CLAUDE_SKILL_DIR}/<file>.md`.
3. Add the templates the department needs to its folder.
4. Add a row to `skills/company/routing.md`.
5. Add a section to this README.
6. Run `./install.sh` again (or bump the plugin version).

---

## Notes and decisions
- **One protocol file, one org chart.** Shared rules and role definitions live once in `hq/`. Departments reference them, so they can't drift apart.
- **Config is private by design.** The repo ships with no personal data. Hosts, domains, runbooks and deploy steps live in `~/.claude/company/config.md`, which install never overwrites and departments never copy into anything committed.
- **Memos stay local by default.** Incident logs and ops notes tend to contain hostnames, so `.company/` isn't committed unless you opt in.
- **Two install methods.** Personal skills give short commands (`/war-room`); the plugin gives one-click install and update at the cost of a prefix (`/company:war-room`). The plugin is named `company` because Claude Code reserves plugin names starting with `claude-` (per its plugin manifest docs); the repository is `claude-inc`.
- **The installer is conservative.** It tracks what it installed, refuses to overwrite anything else without `--force` (and backs it up when forced), and uninstall removes only its own files.
- **Ops checks are generic, read-only scripts.** They take targets as arguments (the skill passes them from config), so they work on any homelab. Anything specific to your setup, such as your deploy tool's status command, goes in config's `extra_checks`.
- **/team keeps its own `.team/` workspace and board** because it runs many agents in parallel; it joins the company at the edges: it reads the protocol and config at the start and writes a memo and ledger update at the end.
- **Handoffs are offered, never automatic**, so one request can't snowball into several departments' worth of work you didn't ask for.
- **Models:** in /team, Opus for judgment-heavy roles (tech lead, reviewers) and Sonnet for building and testing; change `model:` in any agent file. Other departments' subagent roles use a general-purpose agent briefed from the org chart.

---

## Roadmap
**v0.1: core**
- [x] `PROTOCOL.md`, `org-chart.md`, `memo-template.md`, `ledger.md`, `config.md`
- [x] `/company` router with routing table and tie-breaks
- [x] `/war-room`
- [x] `/ops-center` with the four check scripts

**v0.2: build and research**
- [x] `/skunkworks` with safety gates
- [x] `/research-desk` with source rules and fact-checker
- [x] `/studio` with balance-sheet simulation
- [x] `/team` folded in as the product and engineering department

**v0.3: portfolio**
- [x] `/board-meeting` with scoring rubric and `--dry-run`
- [x] Raw ops JSON output for dashboards
- [ ] Documented JSON schema for `ops-raw`
- [ ] One-command setup of the weekly `/ops-center` and monthly `/board-meeting` scheduled tasks (today each department explains how and asks first)

**Later departments**
- [ ] `/hardware-lab`: full build team (EE, ME, firmware, procurement)
- [ ] `/launch`: release, docs and announcement
- [ ] `/red-team`: attack and defend your own tools
- [ ] `/support-desk`: simulated users test the README before release
- [ ] `/procurement`: BOM to real listings with prices
- [ ] `/qa-department`: test architecture and chaos testing
- [ ] `/vc-pitch`: an investor panel grills a new idea

---

## License
MIT. See [LICENSE](LICENSE).
