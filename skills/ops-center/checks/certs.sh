#!/usr/bin/env bash
# certs.sh URL_or_HOST[:PORT]... : TLS certificate expiry, one JSON object per line.
# Env: CERT_WARN_DAYS (default 21). Read-only: opens a TLS handshake and reads the certificate.
set -u
. "$(dirname "$0")/_lib.sh"
WARN_DAYS="${CERT_WARN_DAYS:-21}"
[ $# -eq 0 ] && { echo "usage: certs.sh URL_or_HOST..." >&2; exit 2; }
to_epoch() { date -j -f "%b %d %T %Y %Z" "$1" +%s 2>/dev/null || date -d "$1" +%s 2>/dev/null; }
for arg in "$@"; do
  case "$arg" in http://*) continue;; esac          # no TLS to check
  hp=${arg#https://}; hp=${hp%%/*}
  host=${hp%%:*}; port=443; [ "$hp" != "$host" ] && port=${hp##*:}
  end=$(with_timeout 10 openssl s_client -servername "$host" -connect "$host:$port" </dev/null 2>/dev/null \
        | openssl x509 -noout -enddate 2>/dev/null | sed 's/^notAfter=//')
  if [ -z "$end" ]; then
    printf '{"check":"certs","at":"%s","target":%s,"error":"no certificate (unreachable or no TLS)","ok":false,"warn":true}\n' "$(now_iso)" "$(json_str "$host:$port")"
    continue
  fi
  exp=$(to_epoch "$end"); days=$(( (exp - $(date +%s)) / 86400 ))
  ok=true; [ "$days" -lt 0 ] && ok=false
  warn=false; [ "$days" -lt "$WARN_DAYS" ] && warn=true
  printf '{"check":"certs","at":"%s","target":%s,"expires":%s,"days_left":%s,"ok":%s,"warn":%s}\n' \
    "$(now_iso)" "$(json_str "$host:$port")" "$(json_str "$end")" "$days" "$ok" "$warn"
done
