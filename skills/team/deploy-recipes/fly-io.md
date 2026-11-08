# Recipe: Fly.io

### Read first
- `fly.toml` in the project.

### Preflight (read-only)
- `fly auth whoami`
- `fly status -a <app>`
- `fly releases -a <app> --image` (note the current image for rollback)

### Ship (after approval)
- `fly deploy -a <app>`

### Verify live
- `fly status -a <app>`
- `fly logs -a <app> --no-tail`
- `curl -sS -o /dev/null -w '%{http_code}' <url>` plus key routes.

### Rollback
- `fly deploy -a <app> --image <previous_image>`

### Hard rules
- Never run `fly apps destroy`, `fly scale count 0` or secret changes unless that exact command was approved.
