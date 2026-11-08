# Spec: CSV export on the tasks page

**Goal:** Let users download the tasks they're looking at as a CSV file.

**Users & context:** Anyone using the tasks page; the app runs under a path prefix.

**User stories**
- As a user, I want to download my filtered task list as CSV, so that I can open it in a spreadsheet.

**Acceptance criteria**
- AC1: The tasks page shows a "Download CSV" button.
- AC2: Clicking it downloads `tasks.csv` with a header row: title, status, due, created.
- AC3: The export contains exactly the tasks the current filter shows.
- AC4: Titles with commas, quotes or newlines survive a round trip through a spreadsheet.
- AC5: The button and route work when the app is served under a path prefix.

**Out of scope:** Excel/JSON formats, scheduled exports, exporting other pages.

**Open questions**
1. Include completed tasks? *Default: follow the current filter*, because that's what the user sees.
