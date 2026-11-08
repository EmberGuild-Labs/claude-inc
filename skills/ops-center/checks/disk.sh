#!/usr/bin/env bash
# disk.sh HOST... : disk use per mount (and RAM on Linux) per host, one JSON object per line.
# HOST is an SSH alias from ~/.ssh/config, or "local" for this machine.
# Env: DISK_WARN_PERCENT (default 80), RAM_WARN_PERCENT (default 90).
# Read-only: runs only `df -P -k` and `free -m`. SSH uses BatchMode, so it never prompts for a password.
set -u
. "$(dirname "$0")/_lib.sh"
DW="${DISK_WARN_PERCENT:-80}"; RW="${RAM_WARN_PERCENT:-90}"
[ $# -eq 0 ] && { echo "usage: disk.sh HOST|local..." >&2; exit 2; }
run() { if [ "$1" = local ]; then sh -c "$2"; else with_timeout 20 ssh -o BatchMode=yes -o ConnectTimeout=5 "$1" "$2"; fi; }
for h in "$@"; do
  if ! dfout=$(run "$h" 'df -P -k' 2>/dev/null); then
    printf '{"check":"disk","at":"%s","host":%s,"error":"unreachable over SSH (BatchMode)","ok":false,"warn":true}\n' "$(now_iso)" "$(json_str "$h")"
    continue
  fi
  printf '%s\n' "$dfout" | awk 'NR>1 && $1 !~ /^(tmpfs|devtmpfs|overlay|udev|map|devfs|none)$/ && $6 !~ /^\/(dev|run|sys|proc|System\/Volumes\/(VM|Preboot|Update|xarts|iSCPreboot|Hardware))/' |
  while read -r fs size used avail pct mnt; do
    p=${pct%\%}; warn=false; [ "$p" -ge "$DW" ] && warn=true
    printf '{"check":"disk","at":"%s","host":%s,"mount":%s,"size_gb":%s,"used_pct":%s,"ok":true,"warn":%s}\n' \
      "$(now_iso)" "$(json_str "$h")" "$(json_str "$mnt")" "$(awk -v k="$size" 'BEGIN{printf "%.1f", k/1048576}')" "$p" "$warn"
  done
  if mem=$(run "$h" 'free -m' 2>/dev/null) && [ -n "$mem" ]; then
    printf '%s\n' "$mem" | awk -v w="$RW" -v h="$h" -v at="$(now_iso)" '/^Mem:/{u=$2-$7; p=int(u*100/$2); printf "{\"check\":\"ram\",\"at\":\"%s\",\"host\":\"%s\",\"total_mb\":%d,\"used_pct\":%d,\"ok\":true,\"warn\":%s}\n", at, h, $2, p, (p>=w?"true":"false")}'
  fi
done
