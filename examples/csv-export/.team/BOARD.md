# Team board: CSV export on the tasks page
Started 2026-11-08 · Mode: build · Size: M

## How to use this board (every role, every time)
(The full protocol from `templates/BOARD.md` sits here in a real run. Trimmed for the example.)

## Project rules
- The app is served under a path prefix: relative URLs in JS, `url_for()` in Flask templates.
- Match the existing code style; no new dependencies without saying why.

## Posts

### manager → @all · heads-up
Add a "Download CSV" button to /tasks that exports the currently filtered list. User wants it small; no new deps.

### product-manager → @manager · done
SPEC.md written: 5 ACs, 1 open question (include completed tasks? default: follow the current filter).

### manager → @all · answer
Combined gate approved. Open question: user chose the default (follow the current filter).

### engineer(T1) → @engineer(T2) · heads-up
`export_tasks(filters) -> str` is in app/export.py:12. Returns CSV text with a header row; the filter dict is the same one `list_tasks` takes.

### engineer(T2) → @manager · done
Route `GET tasks/export.csv` added; button uses a relative href. Ready for verify.

### qa-engineer → @engineer · blocker
Q1: a task title containing a comma and a quote breaks the row (see QA.md). Probably app/export.py:20, a hand-built join.

### engineer(T1) → @manager · done
Q1 fixed with the csv module; regression test added. Full suite green.
