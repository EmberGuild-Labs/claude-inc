# First-five-minutes checklist

Used by the `investigator`. Every command here is read-only. Run them freely, log each one and a trimmed result, and mark a check `SKIP` (with the reason) when it does not apply to this host.

Replace `<host>`, `<domain>`, `<service>` and `<container>` with values from the report or from config. Do not paste real hostnames into anything that will be committed.

## Before you start
1. Read the config `Homelab` section: `hosts`, `urls`, `runbook_notes`, `extra_checks`.
2. Read each file listed under `Private docs`. Use what they say; do not copy their contents into the incident file.
3. Run each `extra_checks` command exactly as written, but only if it is clearly read-only (status, list, logs, df); skip anything that could change state and note why. Save the raw output in the log.
4. Note the time the problem started, and whether it is all users or some.

## 1. Is the host up?
```
ping -c 3 <host>
ssh <host> 'uptime; who -b'
```
A recent boot time on a host that should not have rebooted points to a power or crash event.

## 2. What does the outside world see?
```
curl -sS -o /dev/null -w '%{http_code} %{time_total}s\n' https://<domain>/
curl -sSI https://<domain>/
```
Compare with a known-good URL on the same host. Note the status code, the time, and the `server` header (it shows which layer answered).

## 3. DNS
```
dig +short <domain>
dig +short <domain> @1.1.1.1
dig +short <domain> @<your-resolver>
dig NS <domain> +short
```
Different answers from different resolvers mean a DNS problem or a cache that has not caught up. A missing answer means the record is gone.

## 4. TLS
```
echo | openssl s_client -connect <domain>:443 -servername <domain> 2>/dev/null | openssl x509 -noout -dates -subject -issuer
```
Check `notAfter`. An expired or mismatched certificate looks like an outage to clients.

## 5. Is the process running?
Systemd:
```
systemctl status <service> --no-pager
systemctl --failed --no-pager
journalctl -u <service> --since '1 hour ago' --no-pager | tail -n 100
```
Docker:
```
docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
docker logs --since 1h --tail 100 <container>
docker inspect --format '{{.State.ExitCode}} {{.State.OOMKilled}} {{.State.FinishedAt}}' <container>
```
Look for exit codes, restart loops and `OOMKilled: true`.

## 6. Is it listening?
```
ss -tlnp
curl -sS -o /dev/null -w '%{http_code}\n' http://127.0.0.1:<port>/
```
Run the `curl` on the host itself. If it works locally but not from outside, the fault is between the app and the client.

## 7. Reverse proxy
Pick what applies (nginx, Caddy, Traefik, Apache):
```
systemctl status nginx --no-pager
sudo nginx -t
tail -n 100 /var/log/nginx/error.log
tail -n 100 /var/log/nginx/access.log
```
`nginx -t` only tests the config; it does not reload. In the error log look for `connect() failed`, `upstream timed out`, and `no live upstreams`. A 502 means the proxy is up and the upstream is not answering. A 504 means it answered too slowly.

## 8. Tunnel (if you use one)
If the site is reached through a tunnel or similar agent (for example a Cloudflare tunnel, WireGuard, or an SSH tunnel):
```
systemctl status <tunnel-service> --no-pager
journalctl -u <tunnel-service> --since '1 hour ago' --no-pager | tail -n 100
```
Look for disconnects, auth errors and "no route" messages. Check the tunnel's own status page or CLI if it has one (read-only subcommands only).

## 9. Disk, memory, load
```
df -h
df -i
free -h
uptime
dmesg --ctime 2>/dev/null | tail -n 30
```
A full disk (or full inodes) breaks logging, databases and uploads in odd ways. Compare against `disk_warn_percent` and `ram_warn_percent` from config.

## 10. What changed in the last 24 hours?
Code and config:
```
git -C <app-dir> log --since '24 hours ago' --format '%h %ad %an %s' --date=format:'%Y-%m-%d %H:%M'
git -C <app-dir> status --short
```
System:
```
journalctl --since '24 hours ago' --no-pager -p warning | tail -n 100
grep -h 'Start-Date\|Commandline' /var/log/apt/history.log 2>/dev/null | tail -n 20
ls -lt /etc | head -n 15
```
On RPM systems use `dnf history list | head -n 10`. Also check deploy history and CI runs for the same window, and ask the user whether they changed anything by hand.

## 11. Write up the evidence
For each check log: the command, the time, the trimmed result, and what it rules in or out. List gaps (checks that could not be run) as well. Then pass the evidence to the commander for hypotheses.

## Notes
- Do not run `restart`, `reload`, `stop`, `kill`, `rm`, package installs, DNS edits or `docker` commands that start, stop or remove anything. Those are fixer actions and need approval.
- If a command needs `sudo` and no passwordless sudo is set up, log the gap instead of asking for a password.
- Never print secrets. If a log or env dump shows a token or password, trim it from the log entry.
