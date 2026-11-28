#!/usr/bin/env bash
set -euo pipefail

# Links fork-owned global agent instruction files from global-agents/ into
# their local harness locations under $HOME:
#   - ~/.dsh/AGENTS.md            (DSH)
#   - ~/.pi/agent/APPEND_SYSTEM.md (Pi)
#   - ~/.claude/CLAUDE.md         (Claude Code)
#   - ~/.codex/AGENTS.md          (Codex)
#   - ~/.gemini/AGENTS.md         (Antigravity / agy)
#   - ~/AGENTS.md                 (Shared home-root policy)
#
# Existing regular files are backed up with a .bak-YYYYMMDD-HHMMSS suffix
# before being replaced with symlinks.

REPO="$(cd -P "$(dirname "$0")/.." && pwd)"
mode="link"

canonical_file() {
  local target="$1"
  [ -e "$target" ] || return 1
  local dir base
  dir="$(cd -P "$(dirname "$target")" && pwd)"
  base="$(basename "$target")"
  if [ -L "$dir/$base" ]; then
    local link
    link="$(readlink "$dir/$base")"
    case "$link" in
      /*) canonical_file "$link" ;;
      *) canonical_file "$dir/$link" ;;
    esac
  else
    printf '%s/%s\n' "$dir" "$base"
  fi
}

next_backup_path() {
  local base="$1"
  local candidate="$base"
  local n=1
  while [ -e "$candidate" ] || [ -L "$candidate" ]; do
    candidate="${base}-${n}"
    n=$((n + 1))
  done
  printf '%s\n' "$candidate"
}

usage() {
  cat <<'EOF'
Usage: scripts/link-agents.sh [--dry-run | -n | --check | -h | --help]

  (no args)   Create or update global agent instruction symlinks in $HOME.
  --dry-run   Print planned backups and symlinks without modifying $HOME.
  --check     Verify every symlink target points to this repo (read-only).
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run)
      mode="dry-run"
      ;;
    --check)
      mode="check"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

srcs=(
  "$REPO/global-agents/dsh.md"
  "$REPO/global-agents/pi-append-system.md"
  "$REPO/global-agents/claude-code.md"
  "$REPO/global-agents/codex.md"
  "$REPO/global-agents/agy.md"
  "$REPO/global-agents/home.md"
)

dests=(
  "$HOME/.dsh/AGENTS.md"
  "$HOME/.pi/agent/APPEND_SYSTEM.md"
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.codex/AGENTS.md"
  "$HOME/.gemini/AGENTS.md"
  "$HOME/AGENTS.md"
)

for src in "${srcs[@]}"; do
  if [ ! -f "$src" ]; then
    echo "error: missing source file $src" >&2
    exit 1
  fi
done

ts="$(date +%Y%m%d-%H%M%S)"
fail=0

for i in "${!srcs[@]}"; do
  src="${srcs[$i]}"
  dest="${dests[$i]}"
  parent="$(dirname "$dest")"

  if [ -L "$dest" ]; then
    current="$(readlink "$dest")"
    resolved_current="$(canonical_file "$dest" 2>/dev/null || true)"
    if [ "$current" = "$src" ] || [ "$resolved_current" = "$src" ]; then
      echo "ok: $dest -> $current"
      continue
    fi
    case "$mode" in
      check)
        echo "mismatch: $dest -> $current (expected $src)"
        fail=1
        ;;
      dry-run)
        echo "would relink: $dest -> $src (was -> $current)"
        ;;
      link)
        ln -sfn "$src" "$dest"
        echo "relinked: $dest -> $src (was -> $current)"
        ;;
    esac
  elif [ -d "$dest" ]; then
    echo "error: $dest is a directory; refusing to overwrite" >&2
    fail=1
  elif [ -e "$dest" ]; then
    backup="$(next_backup_path "${dest}.bak-${ts}")"
    case "$mode" in
      check)
        echo "unlinked: $dest is a regular file (expected -> $src)"
        fail=1
        ;;
      dry-run)
        echo "would backup: $dest -> $backup"
        echo "would link: $dest -> $src"
        ;;
      link)
        mv "$dest" "$backup"
        if ! ln -s "$src" "$dest"; then
          mv "$backup" "$dest"
          echo "error: failed to link $dest -> $src; restored backup" >&2
          fail=1
          continue
        fi
        echo "backed up: $dest -> $backup"
        echo "linked: $dest -> $src"
        ;;
    esac
  else
    case "$mode" in
      check)
        echo "missing: $dest (expected -> $src)"
        fail=1
        ;;
      dry-run)
        [ -d "$parent" ] || echo "would mkdir: $parent"
        echo "would link: $dest -> $src"
        ;;
      link)
        mkdir -p "$parent"
        ln -s "$src" "$dest"
        echo "linked: $dest -> $src"
        ;;
    esac
  fi
done

exit "$fail"
