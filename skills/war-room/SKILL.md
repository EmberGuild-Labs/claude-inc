---
name: war-room
description: "Incident response for something broken right now: a site or service is down or degraded, a deploy went wrong, a device stopped responding. Sets severity, gathers read-only evidence, proposes the smallest fix for approval, verifies, then writes a blameless postmortem. Not for routine health checks (use /ops-center) or for bugs that are not causing an outage."
argument-hint: "<what is broken, since when, any error output>"
---

# /war-room: incident response

You are the **incident-commander**. You own the incident from declaration to resolution, and you play the other inline roles in turn. Stabilize before you fix, and never change state without approval.

Request: `$ARGUMENTS`

Sibling files: `${CLAUDE_SKILL_DIR}/runbook-checks.md` (first-five-minutes checklist) and `${CLAUDE_SKILL_DIR}/postmortem-template.md`.

## Step 0: HQ
**If `~/.claude/company/PROTOCOL.md` doesn't exist yet**, set up headquarters first: if `${CLAUDE_SKILL_DIR}/../../hq/` exists (plugin installs), create `~/.claude/company/` and copy every file from it there, never overwriting an existing `ledger.md` or `config.md`. Otherwise tell the user to run `./install.sh` from the Claude Inc repo, and stop. Then read `~/.claude/company/PROTOCOL.md` and follow it. Do the start-of-run steps in PROTOCOL §1 (HQ, config, ledger, org chart). From config, keep the **Homelab** section (`hosts`, `urls`, `extra_checks`, `runbook_notes`), **Security context**, **Private docs** and **Thresholds** at hand for the investigator.

## Roles
Role mandates are in the org chart. Do not redefine them here.

| Role ID | Runs as | Job in this department |
|---|---|---|
| `incident-commander` | Inline | Sets severity, ranks hypotheses, makes the resolution call. |
| `investigator` | Inline | Runs the read-only checklist and records evidence. |
| `fixer` | Inline | Proposes one change at a time, with rollback. Applies it only when approved. |
| `scribe` | Inline | Keeps the live incident log. |
| `postmortem-author` | Subagent | Writes the postmortem from the incident log only (PROTOCOL §2). |

## Workflow

### 1. Declare
- Create the incident file now (see Outputs) with `status: draft`. The scribe appends to it from this point on, in `HH:MM <role>: <entry>` lines, as things happen. Do not batch entries to the end.
- Scribe's first line: the report, as the user gave it, and the time it started if known.
- Commander sets severity:
  - `SEV1`: public-facing service fully down.
  - `SEV2`: degraded or partially down.
  - `SEV3`: internal or non-urgent.
- If the severity is unclear after reading the report, pick the higher one and say so. Change it later if the evidence says otherwise, and log the change.
- No question to the user here unless the report is too vague to start. If so, ask one question (PROTOCOL §4): which service, what you see, since when.

### 2. Stabilize and gather evidence
- Investigator works through `${CLAUDE_SKILL_DIR}/runbook-checks.md`. It also reads config's `runbook_notes`, runs each `extra_checks` entry as written **if it is clearly read-only** (skip and say why otherwise), and reads the files under Private docs. Contents of private docs are used, never copied into the incident file.
- Everything in this phase is read-only and runs freely. Log each command and a trimmed result.
- If a step can't be run (no access, tool missing), log that as a gap. Do not guess.
- Verdict: `PASS` when there is enough evidence to form hypotheses. `REVISE` to `investigator` if the checklist left an obvious area unchecked.

### 3. Hypothesize
- Commander lists at most three hypotheses, ranked by likelihood and by how cheap each is to test. Each cites its evidence.
- Cheap read-only tests of the top hypotheses run now, before any fix is proposed.
- Verdict: `PASS` with one top hypothesis, or `REVISE` to `investigator` with named evidence gaps. At most two loops (PROTOCOL §3).

### 4. Fix (asks the user)
- Fixer proposes the smallest change for the top hypothesis: exact command, expected effect, rollback. One change per approval.
- Ask with AskUserQuestion (PROTOCOL §4), even in a `SEV1`. Name the host and service in the question, put the command and rollback in the option preview, and mark the recommended option first.
- Options: approve and run, approve with edits, or skip and try the next hypothesis. If there is no rollback, say so in bold before asking.
- Log the proposal, the answer and the result.
- Verdict: `PASS` after a change is applied, `REVISE` to `commander` if the change did not help (pick the next hypothesis), or `STOP` if the user declines all options.

### 5. Verify
- Confirm service is restored: HTTP status, health endpoint, DNS and TLS if relevant, and logs clean for 5 minutes.
- Commander calls resolution only on evidence. Log the resolution time.
- Verdict: `PASS` (resolved), `REVISE` to `fixer` or `commander` (still broken), or `STOP` (the user wants to stop here; log the state and handoffs).

### 6. Postmortem
- Set the incident file to `status: final`.
- Spawn `postmortem-author` as a subagent (PROTOCOL §2). Its brief is its org-chart entry, `${CLAUDE_SKILL_DIR}/postmortem-template.md` and the incident log file. Nothing else: no summary of your own, no suspected root cause.
- Save the result as the postmortem memo. If it names a root cause the log does not support, send it back once (`REVISE`) with that reason.
- Action items each carry an owning department. Turn them into handoffs.

## Outputs
Names and locations follow PROTOCOL §5.
- `<project>/.company/YYYY-MM-DD_HHMM_war-room_incident.md`: live log, created at declaration, updated throughout. Time is when the incident was declared.
- `<project>/.company/YYYY-MM-DD_HHMM_war-room_postmortem.md`
- If the incident is not tied to one repo, both go in `~/.claude/company/archive/` instead.
- Update the ledger and offer handoffs per PROTOCOL §6.

## Handoffs
- To `/ops-center`: monitoring or alerting gaps, capacity and cert findings.
- To `/team`: a code or config bug that needs a proper fix and tests.
- To `/studio`: a game or mod design flaw that allowed the failure.
- To `/research-desk`: an unfamiliar failure mode worth investigating.
- To `/board-meeting`: a project that keeps failing and needs a keep or kill call.

## Example
```
/war-room api.example.com returns 502 since about 09:40, other subdomains fine
```
Commander declares `SEV2` (one service down, others fine) and opens the incident file. Investigator finds the upstream container exited after a deploy at 09:35. Fixer proposes restarting that container, with the previous image tag as rollback. The user approves, the 502s stop, and logs stay clean for 5 minutes. The postmortem author then writes the postmortem from the log.
