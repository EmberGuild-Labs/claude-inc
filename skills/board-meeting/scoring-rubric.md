# Scoring rubric

Used by the `strategist`. Score every project 1 to 5 on six axes. Use whole numbers. Write one line of evidence per score, taken from the CEO or CFO table. If the evidence is missing, say UNKNOWN and score 3 with the flag ASSUMED. Never score from a project's own README claims.

## Axes and anchors

### Momentum: recent real progress
| Score | Anchor |
|---|---|
| 5 | Commits or memos in the last 14 days, and the work moved the project forward (not just chores). |
| 4 | Last meaningful commit 15 to 30 days ago. |
| 3 | Last commit 31 days to `stale_after_days` ago. |
| 2 | STALE: past `stale_after_days`, up to twice that. |
| 1 | No commits for more than twice `stale_after_days`, or no repo activity at all. |

### Finishability: distance to a usable v1
| Score | Anchor |
|---|---|
| 5 | Works today; a few small tasks from v1. |
| 4 | Core works; one clear milestone left. |
| 3 | Design settled, core partly built. |
| 2 | Core assumption untested, or major unknowns remain. |
| 1 | Idea only, or the goal is not defined in measurable terms. |

### Learning value: new skills it builds
| Score | Anchor |
|---|---|
| 5 | Teaches a skill the user names as a goal and cannot get elsewhere. |
| 4 | Mostly new skills, with some repetition. |
| 3 | A mix of new and familiar work. |
| 2 | Mostly familiar work. |
| 1 | Pure repetition. |

### Leverage: does it unblock or feed other projects
| Score | Anchor |
|---|---|
| 5 | Two or more other projects depend on it or reuse its output. |
| 4 | One project depends on it. |
| 3 | Shares tools or code with others, no hard dependency. |
| 2 | Standalone, but could become a tool for others. |
| 1 | Standalone and nothing else benefits. |

### Excitement: the user's stated interest
Always the user's own answer, never inferred. If unknown, the chair asks (SKILL.md, Phase 3).
| Score | Anchor |
|---|---|
| 5 | The user wants to work on it right now. |
| 4 | Keen, would pick it up soon. |
| 3 | Neutral. |
| 2 | Feels like a chore. |
| 1 | Dreads it, or has lost interest. |

### Cost to continue: scored inversely (5 is cheap, 1 is expensive)
Cost means money still needed plus time to the next milestone, using the CFO table.
| Score | Anchor |
|---|---|
| 5 | No new money; the next milestone fits in a weekend or less. |
| 4 | Small spend (under about 5% of a month's discretionary budget) or a few weekends. |
| 3 | Moderate spend, or about a month of spare time. |
| 2 | Large spend, or several months of spare time. |
| 1 | Cost is unclear and large, or it blocks on money the user does not have. |
If the budget is UNKNOWN, judge by time alone and say so. Recurring costs (hosting, subscriptions) count at their yearly total.

## Formula

```
weighted_sum = w_m*Momentum + w_f*Finishability + w_l*Learning
             + w_lev*Leverage + w_e*Excitement + w_c*CostScore
Priority (0 to 100) = 100 * weighted_sum / (5 * (w_m + w_f + w_l + w_lev + w_e + w_c))
```

Default weights:

| Axis | Weight | Why |
|---|---|---|
| Momentum | 2 | Real progress predicts finishing. |
| Finishability | 2 | Finished projects beat perfect ones. |
| Learning value | 1 | Matters, but is rarely a reason alone. |
| Leverage | 1 | A tiebreaker between similar projects. |
| Excitement | 3 | A project the user will not work on does not ship. |
| Cost to continue | 1 | Cheap projects survive busy months. |

The weights add up to 10, so `Priority = 2 * weighted_sum`. Weights are configurable. If the config's **Board meeting** section has a `weights:` line (for example `weights: momentum=2, finishability=2, learning=1, leverage=1, excitement=3, cost=1`), use it, and show the weights used in the minutes. Missing axes keep their defaults. Weights must be zero or more, and not all zero.

Show the arithmetic for each project, for example:
`2*4 + 2*3 + 1*5 + 1*2 + 3*5 + 1*4 = 40, Priority = 100 * 40 / (5 * 10) = 80`

## From score to recommendation
The score proposes; judgment adjusts; the user decides. Adjustments must be written down with a reason.

| Priority | Starting recommendation |
|---|---|
| 70 to 100 | accelerate (candidate for Focus) |
| 50 to 69 | keep (Maintain, or Focus if capacity allows) |
| 30 to 49 | pause candidate |
| under 30 | kill candidate |

Override rules:
1. **Excitement 1 or 2 caps the project at Maintain or lower.** Do not recommend Focus for a project the user does not want to work on.
2. **A STALE project (Momentum 1 or 2) is never recommended for Focus** unless Excitement is 5 and Finishability is 4 or more.
3. **Leverage 4 or 5 blocks Kill.** Recommend Pause and name the dependent project.
4. **Shipped projects with a running cost** are judged on cost and use, not momentum: Maintain unless the cost outweighs the use.
5. **Never recommend Kill when Excitement is 4 or 5**, even with a low score. Recommend Pause and say why.
6. At most `max_focus_projects` get Focus. If more qualify, take the highest Priority and list the rest as Maintain with "next in line".

## Output format
A table with one row per project: the six scores, the weighted sum, Priority, ASSUMED flags, the recommendation, and one line of reasoning. Then the arithmetic for each project below the table. End with a verdict.
