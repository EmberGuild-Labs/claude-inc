#!/usr/bin/env bash
# Claude Inc uninstaller. Removes only what install.sh installed (listed in ~/.claude/company/.installed).
# Usage: ./uninstall.sh [--purge] [--dry-run]
#   (default)  remove the skills and agents, keep ~/.claude/company/ (your ledger, config and memos)
#   --purge    also remove ~/.claude/company/
set -eu
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
HQ="$CLAUDE_DIR/company"
MANIFEST="$HQ/.installed"
PURGE=0; DRY=0
for a in "$@"; do case "$a" in --purge) PURGE=1;; --dry-run) DRY=1;; -h|--help) sed -n '2,5p' "$0"; exit 0;; *) echo "unknown option: $a" >&2; exit 2;; esac; done
do_() { if [ $DRY = 1 ]; then echo "  would: $*"; else "$@"; fi; }
if [ ! -f "$MANIFEST" ]; then echo "No install manifest at $MANIFEST; nothing to remove."; else
  while IFS= read -r p; do
    case "$p" in "$CLAUDE_DIR"/skills/?*|"$CLAUDE_DIR"/agents/?*.md) [ -e "$p" ] && do_ rm -rf "$p" && echo "  removed $p";;
      *) [ -n "$p" ] && echo "  skipped unexpected path: $p";; esac
  done < "$MANIFEST"
  do_ rm -f "$MANIFEST"
fi
if [ $PURGE = 1 ]; then
  case "$HQ" in /|"$HOME"|"$HOME/"|"$CLAUDE_DIR"|"$CLAUDE_DIR/") echo "Refusing to purge $HQ: that is not a Claude Inc headquarters folder." >&2; exit 1;; esac
  [ -f "$HQ/PROTOCOL.md" ] || { echo "Refusing to purge $HQ: no PROTOCOL.md there, so it does not look like Claude Inc headquarters." >&2; exit 1; }
  do_ rm -rf "$HQ"; echo "  removed $HQ"; else echo "Kept $HQ (ledger, config, memos). Use --purge to remove it."; fi
