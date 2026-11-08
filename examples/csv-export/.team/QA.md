# QA: CSV export

| AC | Result | Evidence |
|---|---|---|
| AC1 | PASS | Browser: button visible at desktop and 390px widths, `screens/ac1-button-mobile.png` |
| AC2 | PASS | `tests/test_export.py::test_header_row` |
| AC3 | PASS | `test_respects_filter`; browser: filtered to "open", file had 7 rows = 7 on screen |
| AC4 | PASS (after Q1 fix) | `test_titles_with_quotes_and_commas` |
| AC5 | PASS | App run under `/demo`; download worked, no 404s in the network log |

**Result:** 5/5 passing after fix round 1. Command: `pytest -q` → 31 passed.

## Bugs
- **Q1 (fixed):** title `Buy "milk", eggs` split into two columns. Repro: create that task, export, open in a spreadsheet. Expected one cell. Cause: hand-built join in app/export.py:20.
