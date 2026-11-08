#!/usr/bin/env bash
# Claude Inc installer: copies the departments to ~/.claude/skills/, the /team agents to
# ~/.claude/agents/, and creates the headquarters at ~/.claude/company/.
# Usage: ./install.sh [--dry-run] [--force]
#   --dry-run  show what would happen, change nothing
#   --force    replace existing skills/agents that Claude Inc didn't install (they're backed up first)
set -eu
ROOT="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
HQ="$CLAUDE_DIR/company"
MANIFEST="$HQ/.installed"
DRY=0; FORCE=0
for a in "$@"; do case "$a" in --dry-run) DRY=1;; --force) FORCE=1;; -h|--help) sed -n '2,6p' "$0"; exit 0;; *) echo "unknown option: $a" >&2; exit 2;; esac; done
do_() { if [ $DRY = 1 ]; then echo "  would: $*"; else "$@"; fi; }
owned() { [ -f "$MANIFEST" ] && grep -qxF "$1" "$MANIFEST"; }
STAMP="$(date +%Y%m%d-%H%M%S)"; BACKUP="$CLAUDE_DIR/backups/claude-inc-$STAMP"

# 1. Find conflicts: things that exist but weren't installed by Claude Inc.
conflicts=""
for d in "$ROOT"/skills/*/; do n=$(basename "$d"); t="$CLAUDE_DIR/skills/$n"; [ -e "$t" ] && ! owned "$t" && conflicts="$conflicts $t"; done
for f in "$ROOT"/agents/*.md; do t="$CLAUDE_DIR/agents/$(basename "$f")"; [ -e "$t" ] && ! owned "$t" && conflicts="$conflicts $t"; done
if [ -n "$conflicts" ]; then
  echo "These already exist and weren't installed by Claude Inc:"; for c in $conflicts; do echo "  $c"; done
  if [ $FORCE = 0 ]; then echo "Re-run with --force to back them up to $BACKUP and replace them."; exit 1; fi
  for c in $conflicts; do rel="${c#$CLAUDE_DIR/}"; do_ mkdir -p "$BACKUP/$(dirname "$rel")"; do_ cp -R "$c" "$BACKUP/$rel"; done
  [ $DRY = 0 ] && echo "Backed up to $BACKUP"
fi

# 2. Skills and agents.
do_ mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents" "$HQ/archive"
new_manifest=""
for d in "$ROOT"/skills/*/; do
  n=$(basename "$d"); t="$CLAUDE_DIR/skills/$n"
  do_ rm -rf "$t"; do_ cp -R "${d%/}" "$t"; new_manifest="$new_manifest$t
"; done
for f in "$ROOT"/agents/*.md; do
  t="$CLAUDE_DIR/agents/$(basename "$f")"; do_ cp "$f" "$t"; new_manifest="$new_manifest$t
"; done

# 3. Headquarters. Product files are refreshed; your ledger and config are never overwritten.
for f in PROTOCOL.md org-chart.md memo-template.md; do do_ cp "$ROOT/hq/$f" "$HQ/$f"; done
for f in ledger.md config.md; do
  if [ -e "$HQ/$f" ]; then echo "  kept your $HQ/$f"; else do_ cp "$ROOT/hq/$f" "$HQ/$f"; fi
done
if [ $DRY = 0 ]; then printf '%s' "$new_manifest" > "$MANIFEST"; fi

echo
echo "Claude Inc installed. Start a new Claude Code session, then:"
for d in "$ROOT"/skills/*/; do echo "  /$(basename "$d")"; done
[ -e "$HQ/config.md" ] && echo "Edit $HQ/config.md to describe your setup (it's private and never overwritten)."
[ $DRY = 1 ] && echo "(dry run: nothing was changed)"
exit 0
