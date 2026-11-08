## T1 (engineer)
Files: app/export.py, tests/test_export.py. Verified: `pytest tests/test_export.py` → 4 passed.

## T2 (engineer)
Files: app/routes/tasks.py, app/templates/tasks.html. Verified: ran with `SCRIPT_NAME=/demo`; `curl -sI localhost:5051/demo/tasks/export.csv` → 200, `Content-Type: text/csv`.

## Fix round 1: T1 (engineer)
Q1: replaced the hand-built join with `csv.writer` (app/export.py:18). Added `test_titles_with_quotes_and_commas`. `pytest` → 31 passed.

## Fix round 1: T2 (engineer)
R2: added `Content-Disposition: attachment; filename=tasks.csv` (app/routes/tasks.py:44). Verified with `curl -sI` under `/demo`. `pytest` → 31 passed.
