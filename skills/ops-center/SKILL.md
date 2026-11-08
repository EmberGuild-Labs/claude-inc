---
name: ops-center
description: "Claude Inc standing operations. Runs read-only homelab health checks (HTTP uptime, TLS certificate expiry, disk and RAM over SSH, optional Proxmox guests, plus any read-only checks in your config), compares them with the last report, projects capacity, and writes a weekly ops report. Use when the user types /ops-center or asks for a routine health, capacity, cert or cost check of their servers. Not for something that is broken right now (that's /war-room)."
argument-hint: "[all | uptime | certs | disk | proxmox | costs]"
---

# /ops-center: standing operations

You are the **on-call lead**. You run the routine checks, compare them with last time, and write a report with clear follow-ups. You never restart, update or change anything: problems that need action go to /war-room (urgent) or become follow-ups (routine).

Request: `$ARGUMENTS` (empty means all checks)

## 0. Read the company files
**If `~/.claude/company/PROTOCOL.md` doesn't exist yet**, set up headquarters first: if `${CLAUDE_SKILL_DIR}/../../hq/` exists (plugin installs), create `~/.claude/company/` and copy every file from it there, never overwriting an existing `ledger.md` or `config.md`. Otherwise tell the user to run `./install.sh` from the Claude Inc repo, and stop. Then read `~/.claude/company/PROTOCOL.md` and follow its section 1. From `config.md` you need **Homelab** (hosts, urls, proxmox_api, proxmox_token_env, extra_checks, runbook_notes), **Thresholds**, **Security context** and **Private docs** (read any that describe server access before you SSH anywhere). If Homelab is empty, say what's missing, offer to help fill it in, and stop.

## Roles
| Role | Runs as | Job |
|---|---|---|
| `sre` | Inline | Runs the checks; status line per service |
| `capacity-planner` | Inline | Days until each resource hits its limit |
| `cost-analyst` | Inline | Renewals, hosting, power, subscriptions |
| `security-watch` | Inline | Cert expiry, pending updates, exposed ports, outdated images |
| `on-call-lead` | Inline | Writes the report, assigns follow-ups |

## Workflow

**1. Run checks** (`sre`). The scripts are in `${CLAUDE_SKILL_DIR}/checks/`. Each prints one JSON object per line and never changes anything. Pass thresholds from config as env vars:
```bash
C="${CLAUDE_SKILL_DIR}/checks"
RESPONSE_WARN_MS=<response_warn_ms> "$C/uptime.sh" <url> <url> ...
CERT_WARN_DAYS=<cert_warn_days>     "$C/certs.sh"  <url> <url> ...
DISK_WARN_PERCENT=<disk_warn_percent> RAM_WARN_PERCENT=<ram_warn_percent> "$C/disk.sh" <ssh-alias> ...
PROXMOX_TOKEN_ENV=<proxmox_token_env> RAM_WARN_PERCENT=<ram_warn_percent> "$C/proxmox.sh" <proxmox_api or none>
```
- `disk.sh` accepts `local` as a host to check this machine. SSH runs in BatchMode (key auth only); a host that needs a password shows as unreachable, so use `extra_checks` for it instead.
- Add `PROXMOX_INSECURE=1` when config sets `proxmox_insecure: true` (a self-signed certificate, common on homelab Proxmox).
- Run only the checks the request asks for (default: all).
- Run each `extra_checks` command exactly as written in config, but **only if it is clearly read-only** (status, list, logs, df). If one looks like it could change state, skip it and say why.
- `security-watch` may also run read-only commands on the configured hosts: pending updates (`apt list --upgradable 2>/dev/null | wc -l`), listening ports (`ss -tlnH`), and container image ages (`docker ps --format '{{.Image}} {{.RunningFor}}'`). Never scan hosts that aren't in config.
- Save all raw output as one JSON array to `HQ/archive/ops-raw/<YYYY-MM-DD>.json`, each item tagged with its check. Create the folder if needed.

**2. Compare.** Load the most recent earlier file in `HQ/archive/ops-raw/` and the last `*_ops-center_report.md`. For each target: better, worse or unchanged. Note what was fixed and what's new.

**3. Project** (`capacity-planner`). For disk and RAM, use every earlier raw file to estimate the growth rate per week and the days until the warn threshold and until 100%. With fewer than two earlier data points, write "not enough history" instead of guessing.

**4. Costs** (`cost-analyst`). From config and earlier reports: upcoming domain renewals (next 60 days), hosting, subscriptions, a rough power estimate if config gives wattage. Unknown prices are `UNKNOWN`, never guessed. Skip this step when the request names other checks only.

**5. Report** (`on-call-lead`). Write the report from `${CLAUDE_SKILL_DIR}/report-template.md`:
- one status line per service, with a trend arrow (`↑` better, `↓` worse, `→` unchanged)
- warnings, most urgent first
- follow-ups, each with an owner department

Anything urgent (a site down, a cert expiring within 3 days, a disk over 95%) goes to the top with a handoff to /war-room, and you tell the user straight away instead of waiting for the end.

## Outputs
- `HQ/archive/<YYYY-MM-DD_HHMM>_ops-center_report.md` (company-wide, never committed to a project)
- `HQ/archive/ops-raw/<YYYY-MM-DD>.json` (raw check output; other tools, such as a status dashboard, can read it)
- Ledger: update an entry with id `homelab` (create it the first time) per PROTOCOL section 6.

## Handoffs
- To /war-room: anything urgent.
- To /team: a monitoring or tooling gap that needs code.
- To /board-meeting: a cost that might mean a project should stop.

## Running it weekly
`/ops-center` is designed to run as a weekly scheduled task. Setting up a schedule changes the user's configuration, so offer it and only create it on their yes (for example with Claude Code's scheduled tasks or the `/schedule` skill, prompt: `/ops-center`).

## Example
```
/ops-center
/ops-center certs only
```
