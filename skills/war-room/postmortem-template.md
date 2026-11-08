# Postmortem template

For the `postmortem-author`. Write from the incident log only. Be blameless: describe what the system and the process allowed, not what a person should have done. Use 24-hour time. Do not use emojis. Do not copy private hostnames, domains, paths or secrets from the log; refer to things by role ("the proxy host", "the app container").

If the log does not support a statement, write `UNKNOWN` or leave it out.

The file is saved as a memo (frontmatter and sections in the shape of `memo-template.md`). Put this template's sections under **Findings**.

```markdown
---
department: war-room
project: <project id>
date: YYYY-MM-DD HH:MM
status: final
---

# Postmortem: <short incident title>

## Summary
Three sentences at most: what broke, how it was fixed, the main lesson.

## Findings

### Impact
- Severity: SEV1 | SEV2 | SEV3
- Who and what was affected:
- Start: YYYY-MM-DD HH:MM  Detected: HH:MM  Resolved: HH:MM
- Duration:
- How it was detected (user report, monitoring, other):

### Timeline
| Time | Event | Source (log line) |
|---|---|---|
| HH:MM | | |

### Root cause
One paragraph. The specific technical cause, backed by evidence from the log. If it was not confirmed, say "most likely" and name what would confirm it.

### Contributing factors
- Conditions that made the incident possible or worse (missing alert, no rollback, unclear docs, a risky default).

### What went well
- Things that shortened or limited the incident.

### What went badly
- Things that slowed diagnosis or recovery.

### Where we got lucky
- Things that could have made it worse but did not.

### Action items
| # | Action | Type | Owner department | Priority |
|---|---|---|---|---|
| 1 | | prevent / detect / mitigate | /ops-center, /team, /studio, /research-desk or /board-meeting | P1-P3 |

Each action must be specific and checkable. "Improve monitoring" is not an action; "alert when the app container is not running for 2 minutes" is.

## Decisions needed
List any action items that need the user's approval, or "None."

## Decisions made
Approvals and refusals from the log, one line each with the time.

## Handoffs
- To /<department>: <action item and why>

## Appendix
Verdict from the postmortem author: PASS, or REVISE with reasons if the log was too thin to support a root cause.
```

## Quality bar
- Every timeline row points to a log entry.
- The root cause says why, not just what ("the container ran out of memory because the limit was 128 MB and the new build needs more", not "the container died").
- Every action item has an owning department and a priority.
- Nothing in the text blames a person.
