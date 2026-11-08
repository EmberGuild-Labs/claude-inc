# Team board: {{TITLE}}
Started {{DATE}} · Mode: {{MODE}} · Size: {{SIZE}}

## How to use this board (every role, every time)
This is how the team talks to each other: questions, heads-ups, handoffs, blockers. Other agents may be working at the same time.
- **On start:** read this whole file. Act on anything addressed to your role, or to `@all`. Follow the **Project rules** below.
- **While you work:** post when a teammate needs to know something: an interface you defined, a gotcha you hit, a question for another role, a decision you made inside your scope. Re-read the board before you finish, in case someone replied or raised something that affects you.
- **Append only**, with Bash: `cat >> .team/BOARD.md <<'EOF'` … `EOF`. Never Edit, Write or rewrite this file, because parallel posts would get lost. This is the one file every role may append to, read-only roles included.
- **Post format:**
  ```
  ### <role>(<task id, if any>) → @<role|all|manager|user> · <question|heads-up|handoff|blocker|answer|done>
  <one to five lines, with file:line refs where useful>
  ```
- Use `@manager` for decisions outside your scope and `@user` for anything only the user can decide. The manager relays those.
- Keep posts short and factual. Your full report goes in your own doc, not here.
- Never paste secrets, tokens, passwords or private infrastructure details into the board.

## Project rules
{{PROJECT_RULES}}

## Posts

### manager → @all · heads-up
{{REQUEST}}
