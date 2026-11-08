# Recipe: Docker Compose over SSH

### Read first
- The project's `compose.yaml` / `docker-compose.yml` and README.

### Preflight (read-only)
- `ssh <host> 'docker compose -f <remote_dir>/compose.yaml ps'`
- `ssh <host> 'df -h / && free -m'`
- Confirm the commit to ship is pushed: `git status -sb`, `git log -1 --oneline`.

### Ship (after approval)
- `ssh <host> 'cd <remote_dir> && git rev-parse --short HEAD > .previous-release && git pull --ff-only && docker compose up -d --build'`

### Verify live
- `ssh <host> 'cd <remote_dir> && docker compose ps && docker compose logs --since 5m --tail 100'`
- `curl -sS -o /dev/null -w '%{http_code}' <url>` plus key routes.

### Rollback
- `ssh <host> 'cd <remote_dir> && git reset --hard $(cat .previous-release) && docker compose up -d --build'` (stays on the branch, so the next deploy's `git pull --ff-only` still works)

### Hard rules
- Only run compose commands inside `<remote_dir>`. Never `docker system prune` or touch other stacks on the host.
