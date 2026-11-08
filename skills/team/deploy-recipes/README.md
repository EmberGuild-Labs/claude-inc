# Deploy recipes
A recipe tells the release engineer how *you* deploy. Point to one from your company config (`~/.claude/company/config.md`) (`recipe: docker-ssh`), or write your own inline in config's **Deploy** section using the same headings. Every recipe has the same six parts: Read first, Preflight, Ship, Verify live, Rollback, Hard rules.

Commands that change anything only run after you approve the exact command (Gate C), whatever the recipe says.

| Recipe | For |
|---|---|
| `static-rsync.md` | Static sites copied to a server you can SSH into |
| `docker-ssh.md` | A Docker Compose app on a server you can SSH into |
| `fly-io.md` | Apps on Fly.io |

Placeholders look like `<host>`. Keep real values in your config (or better, in your SSH config and env vars), never in the project.
