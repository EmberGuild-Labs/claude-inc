# Shared helpers for Claude Inc ops checks. Sourced, not run. Read-only by design.
json_str() { printf '"%s"' "$(printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | tr -d '\n\r')"; }
# Portable timeout (macOS has no `timeout`): with_timeout <seconds> <cmd...>
with_timeout() { local s="$1"; shift; perl -e 'alarm shift; exec @ARGV' "$s" "$@"; }
now_iso() { date -u +%Y-%m-%dT%H:%M:%SZ; }
