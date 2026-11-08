# Senior review: CSV export

- **R1 (Should fix, fixed):** app/export.py:20 builds rows with `",".join`, which breaks on commas and quotes (same as Q1). Use `csv.writer`.
- **R2 (Should fix, fixed):** app/routes/tasks.py:44 doesn't set `Content-Disposition`, so some browsers display the CSV instead of downloading it. Add `attachment; filename=tasks.csv`.
- **R3 (Nit, open):** a dated filename (`tasks-2026-11-08.csv`) would be friendlier.

**Verdict:** Approve with fixes. Blocker 0 · Should fix 2 · Nit 1.
