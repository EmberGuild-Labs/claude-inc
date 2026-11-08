#!/usr/bin/env bash
# uptime.sh URL... : HTTP status and response time per URL, one JSON object per line.
# Env: RESPONSE_WARN_MS (default 2000). Read-only: plain GET requests only.
set -u
. "$(dirname "$0")/_lib.sh"
WARN_MS="${RESPONSE_WARN_MS:-2000}"
[ $# -eq 0 ] && { echo "usage: uptime.sh URL..." >&2; exit 2; }
for url in "$@"; do
  out=$(curl -sS -o /dev/null -L --max-time 15 -w '%{http_code} %{time_total}' "$url" 2>/dev/null) || out="000 0"
  code=${out%% *}; t=${out##* }
  ms=$(awk -v t="$t" 'BEGIN{printf "%d", t*1000}')
  ok=false; case "$code" in 2*) ok=true;; esac
  warn=false; { [ "$ok" = false ] || [ "$ms" -gt "$WARN_MS" ]; } && warn=true
  printf '{"check":"uptime","at":"%s","target":%s,"status":%s,"ms":%s,"ok":%s,"warn":%s}\n' \
    "$(now_iso)" "$(json_str "$url")" "$((10#$code))" "$ms" "$ok" "$warn"
done
