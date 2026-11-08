# Recipe: static site over SSH + rsync

### Read first
- The project's build docs (README) for the build command and output folder.

### Preflight (read-only)
- `ssh <host> 'test -d <remote_dir> && df -h <remote_dir>'`
- Build locally (`<build_cmd>`) and confirm `<out_dir>` exists and links are relative if the site lives under a path.
- `rsync -avzn --delete <out_dir>/ <host>:<remote_dir>/` (dry run: list what would change)

### Ship (after approval)
- `ssh <host> 'cp -a <remote_dir> <remote_dir>.bak-$(date +%Y%m%d%H%M)'`
- `rsync -avz --delete <out_dir>/ <host>:<remote_dir>/`

### Verify live
- `curl -sS -o /dev/null -w '%{http_code}' <url>` plus key pages and one asset.

### Rollback
- `ssh <host> 'rsync -a --delete <remote_dir>.bak-<stamp>/ <remote_dir>/'`

### Hard rules
- Never point `--delete` at a directory other than this site's.
