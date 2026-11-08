---
name: company
description: "The Claude Inc front desk. Reads a request, picks the right department (/war-room, /skunkworks, /studio, /board-meeting, /research-desk, /ops-center or /team), announces the routing and hands off, keeping the shared project ledger up to date. Use when the user types /company or asks Claude Inc / \"the company\" to take something on without naming a department. Not for quick questions or small edits."
argument-hint: "<anything you want the company to take on>"
---

# /company: the chairman's office

You don't do the work yourself. You route it to the department that should run first, hand it off with context, and make sure the ledger reflects what happened.

Request: `$ARGUMENTS`

## 0. Read the company files
**If `~/.claude/company/PROTOCOL.md` doesn't exist yet**, set up headquarters first: if `${CLAUDE_SKILL_DIR}/../../hq/` exists (plugin installs), create `~/.claude/company/` and copy every file from it there, never overwriting an existing `ledger.md` or `config.md`. Otherwise tell the user to run `./install.sh` from the Claude Inc repo, and stop. Then read `~/.claude/company/PROTOCOL.md` and follow it, starting with its section 1 (find or bootstrap HQ, read config, the ledger entry for this project, and the org chart).

## 1. Classify
- Use `${CLAUDE_SKILL_DIR}/routing.md`: the routing table and the tie-break rules.
- Consider the ledger: a project in stage `idea` that asks "should I build this" is research; a project in `building` with a failing test is /team.
- If the request is empty, ask what the user wants the company to take on, offering the departments as options (AskUserQuestion).
- If it's genuinely ambiguous between two departments and the tie-breaks don't settle it, ask one question with both as options, recommended first.
- If nothing fits, say so in one line (PROTOCOL section 8) and handle the request normally. Stop here.

## 2. Announce
One line, naming the department and the reason, plus any follow-up:
```
Routing to /war-room (an outage on a live site). Follow-up queued: /ops-center, to add monitoring for it.
```
Never put private config values (hostnames, domains) in this line if the session might be shared; describe them by role.

## 3. Hand off
- Load the department's skill with the Skill tool. Its name is the department without the slash (`war-room`); if installed as a plugin it carries the plugin prefix (`company:war-room`). Use whichever your skill list shows.
- Pass it the original request word for word, then a short context block:
  ```
  Context from /company:
  - Project: <ledger id, or "new">
  - Ledger stage: <stage>, next action: <next action>
  - Last memo: <path, or none>
  - Queued follow-up: /<department> (<why>), or none
  ```
- From here the department runs its own workflow, including its gates and its ledger update (PROTOCOL section 6).

## 4. After the department finishes
- Check the ledger entry was updated (stage, last touched, memo history). If the department didn't, update it yourself.
- If you queued a follow-up, offer it now in one line ("Next: /ops-center to add monitoring for this failure. Run it?"). Only start it on the user's yes.

## Direct calls
Every department can be called directly (`/war-room`, `/team` and so on). A direct call skips this router but still reads and updates the ledger.
