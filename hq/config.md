# Company config
<!--
Your PRIVATE settings for Claude Inc. Lives at ~/.claude/company/config.md (install.sh never overwrites it).
A project can add <project>/.claude/company.config.md on top; keep that out of git if it holds anything private.
Secrets never go here: name the env var (or the password manager entry, or the SSH config alias) that holds them.
Every section is optional. Delete what you don't use.
-->

## Organization
- name: <your name or org>
- github_owner: <github user or org>          # used by /board-meeting to list repos
- default_repo_visibility: private

## Paths
- commit_memos: false                         # true = .company/ is committed with the code (private values get replaced by role names)

## Project rules
<!-- Short rules every department and every /team role must follow. /team copies them into each run's board. -->
- Example: Web apps are served under a URL path prefix, so use relative URLs in JS/CSS and prefix-aware routing on the server.

## Security context
<!-- What is at stake if something goes wrong. Read by the security engineer, /war-room and /ops-center. -->
- Example: Apps are public on the internet and share a server with other services.
- never_reveal: <kinds of details that must not appear in code, docs, memos or commits, e.g. internal hostnames>

## Private docs
<!-- Absolute paths departments may READ at runtime. Their contents are never copied into a project or a committed memo. -->
- <path to your runbook or server notes>

## Homelab
<!-- Used by /ops-center and /war-room. Every check is read-only. -->
- hosts:                                      # SSH aliases from ~/.ssh/config (key auth), checked by disk.sh; "local" = this machine
  - <ssh-alias>
- urls:                                       # checked by uptime.sh (HTTP) and certs.sh (TLS, https only)
  - https://<your-site>
- proxmox_api: none                           # or https://<proxmox-host>:8006/api2/json
- proxmox_token_env: PROXMOX_TOKEN            # env var holding "USER@REALM!TOKENID=SECRET", never the token itself
- proxmox_insecure: false                     # true accepts a self-signed Proxmox certificate
- extra_checks:                               # optional read-only commands, run as-is and saved raw
  - <e.g. a status command for your deploy tool>
- runbook_notes: <one line of anything /war-room should know first, or a Private docs path>

## Deploy
<!-- Used by /team's release engineer. A recipe name from skills/team/deploy-recipes/, or steps inline. -->
recipe: none
<!-- Inline form uses these headings: Read first · Preflight (read-only) · Ship (after approval) · Verify live · Rollback · Hard rules -->

## Thresholds
- cert_warn_days: 21
- disk_warn_percent: 80
- ram_warn_percent: 90
- response_warn_ms: 2000

## Board meeting
- max_focus_projects: 3
- stale_after_days: 45                        # no commits for this long counts as stale
- weights: momentum=2, finishability=2, learning=1, leverage=1, excitement=3, cost=1

## Research
- excluded_domains: reddit.com, quora.com

## Loops
- max_revise_loops: 2
