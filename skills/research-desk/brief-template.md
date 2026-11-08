# Research brief template

Used by the `editor`. The brief is saved as a memo in the shape of `memo-template.md`. The sections below go under **Findings**. Keep it short enough to read in five minutes. Every factual claim has a numbered reference. No emojis.

```markdown
---
department: research-desk
project: <project id>
date: YYYY-MM-DD HH:MM
status: final
---

# Research brief: <idea in a few words>

## Summary
Three sentences at most: the question, the answer, the next action.

## Findings

### Research questions
1. <Specific question>
2. ...
(3-6 questions. Say which assumptions you made when framing them.)

### Bottom line
Two to four sentences. What the research shows, and the recommendation in one word: PURSUE, MODIFY or DROP.

### What exists
For each close match: what it is, who makes it, what it does, how it differs from the idea, and a reference. A table works well.

| Item | What it is | Status and date | Differs from the idea by | Ref |
|---|---|---|---|---|

If nothing close exists, say so, list the searches that came back empty, and explain why that might be (no demand, too hard, too new).

### What is novel about the idea
What would be new, and whether the novelty matters. Separate "nobody has done this" from "nobody has a reason to".

### Cost and difficulty
| Item | Figure | Basis | Ref |
|---|---|---|---|
| Money (parts, tools, hosting) | | quote, price page or ESTIMATE | |
| Time | | | |
| Skills needed | | | |
| Main risks | | | |

Mark derived figures `ESTIMATE` and show the arithmetic below the table. Mark unsourced figures `UNVERIFIED`.

### Recommendation
PURSUE, MODIFY or DROP. Then:
- Why, in three bullets at most.
- If MODIFY: the specific change that would make it worth doing.
- If PURSUE: the first small step.
- What would change the recommendation.

### Open questions
Things the research could not settle, and the cheapest way to find out.

### References
1. Title, publisher or author, date, URL

## Decisions needed
Options with a recommendation, or "None."

## Decisions made
Gate answers from this run, one line each with the time.

## Handoffs
- To /<department>: <what and why>

## Appendix

### Editor
Questions, assumptions, final verdict.

### Literature scout
Queries run, including those that found nothing. Sources considered and rejected, with the reason. Verdict.

### Feasibility analyst
Working for each estimate. Verdict.

### Fact-checker
Result per claim: SUPPORTED, UNSUPPORTED or UNVERIFIED, and what was changed in response. Verdict.
```

## Checks before saving
- Every claim in Bottom line and Recommendation traces to a reference or is marked `ESTIMATE` or `UNVERIFIED`.
- No excluded source is cited.
- The recommendation follows from the findings; it does not introduce new facts.
- Prices carry the date they were seen.
- The handoffs match the recommendation (a DROP has none, or only `/board-meeting`).
