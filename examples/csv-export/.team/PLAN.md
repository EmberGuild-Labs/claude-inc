# Plan: CSV export

## Approach
A pure function builds the CSV with Python's `csv` module (no new dependency); a thin Flask route streams it. The button is a plain link built with `url_for()`, so it works under the path prefix.

## Tasks
- **T1: export function + unit tests.** Owns: `app/export.py`, `tests/test_export.py`. Depends on: none. Covers: AC2, AC3, AC4. Done when: `pytest tests/test_export.py` passes.
- **T2: route + button.** Owns: `app/routes/tasks.py`, `app/routes/__init__.py`, `app/templates/tasks.html`. Depends on: T1 (interface only: `export_tasks(filters) -> str`). Covers: AC1, AC3, AC5. Done when: `curl` on the route under a prefix returns 200 and `text/csv`.

## Shared files
`app/routes/__init__.py` (the route registry) is owned only by T2. The README is updated by the tech writer in Phase 6, not by a task.

## Parallel groups
- G1: T1
- G2: T2 (needs T1's interface, which is fixed in this plan)

## Risks
- Hand-built CSV breaks on commas and quotes → use the `csv` module; QA tests AC4 with nasty titles.

**Needs UI design?** no (one button in the existing style). **Needs security review?** no (read-only, same auth as the page).

Every AC is covered: AC1 T2 · AC2 T1 · AC3 T1+T2 · AC4 T1 · AC5 T2.
