#!/usr/bin/env bash
# proxmox.sh API_URL : node and guest (LXC/VM) status via the Proxmox API, one JSON object per line.
# API_URL like https://<host>:8006/api2/json. Skips cleanly if API_URL is empty or "none".
# Env: PROXMOX_TOKEN_ENV (default PROXMOX_TOKEN) names the env var holding "USER@REALM!TOKENID=SECRET".
#      RAM_WARN_PERCENT (default 90). PROXMOX_INSECURE=1 accepts a self-signed certificate.
# Read-only: a single GET of /cluster/resources. The token is never printed.
set -u
. "$(dirname "$0")/_lib.sh"
API="${1:-none}"
if [ "$API" = none ] || [ -z "$API" ]; then echo '{"check":"proxmox","skipped":"no proxmox_api configured","ok":true,"warn":false}'; exit 0; fi
var="${PROXMOX_TOKEN_ENV:-PROXMOX_TOKEN}"; tok="$(printenv "$var" || true)"
if [ -z "$tok" ]; then printf '{"check":"proxmox","error":"env var %s is not set","ok":false,"warn":true}\n' "$var"; exit 0; fi
k=""; [ "${PROXMOX_INSECURE:-0}" = 1 ] && k="-k"
# The header goes in through a curl config on stdin, so the token never appears in the process list.
body=$(printf 'header = "Authorization: PVEAPIToken=%s"\n' "$tok" | curl -sS $k --max-time 15 -K - "${API%/}/cluster/resources" 2>/dev/null) || {
  echo '{"check":"proxmox","error":"API unreachable","ok":false,"warn":true}'; exit 0; }
printf '%s' "$body" | RW="${RAM_WARN_PERCENT:-90}" AT="$(now_iso)" python3 -c '
import json, os, sys
rw = int(os.environ["RW"]); at = os.environ["AT"]
try: data = json.load(sys.stdin)["data"]
except Exception: print(json.dumps({"check":"proxmox","error":"unexpected API response","ok":False,"warn":True})); sys.exit()
for r in data:
    if r.get("type") not in ("node","lxc","qemu"): continue
    mem = 100*r["mem"]//r["maxmem"] if r.get("maxmem") else None
    running = r.get("status") in ("online","running")
    print(json.dumps({"check":"proxmox","at":at,"type":r["type"],"name":r.get("name") or r.get("node"),
      "status":r.get("status"),"mem_pct":mem,"ok":running,
      "warn":(not running) or (mem is not None and mem>=rw)}))'
