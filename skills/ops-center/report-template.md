---
department: ops-center
project: homelab
date: YYYY-MM-DD HH:MM
status: final
---

# Ops report, week of YYYY-MM-DD

## Summary
<Three sentences at most: overall health, the most important warning, the next action.>

## Status
| Service / target | Check | Now | Last report | Trend |
|---|---|---|---|---|
| <site> | uptime | 200, 140 ms | 200, 150 ms | → |
| <site> | cert | 47 days | 54 days | → |
| <host> | disk / | 62% | 58% | ↓ |
| <host> | RAM | 71% | 70% | → |

## Warnings
<Most urgent first. Each: what, where, threshold crossed, and why it matters.>
1. ...

## Capacity
| Host | Resource | Used | Growth / week | Days to warn | Days to full |
|---|---|---|---|---|---|
| <host> | disk / | 62% | +1.5% | 12 | 25 |

<"Not enough history" where there are fewer than two earlier data points.>

## Security watch
- Certificates expiring within the warn window: ...
- Pending package updates per host: ...
- Unexpected listening ports: ...
- Containers on images older than 90 days: ...

## Costs
| Item | Amount | Renews | Notes |
|---|---|---|---|
| <domain> | UNKNOWN | YYYY-MM-DD | |

## Follow-ups
| # | What | Owner | Urgency |
|---|---|---|---|
| 1 | ... | /war-room | URGENT |
| 2 | ... | /team | routine |

## Decisions needed
None.

## Handoffs
- To /<department>: <what and why>

## Appendix
Raw output: `HQ/archive/ops-raw/YYYY-MM-DD.json`. Checks skipped and why: ...
