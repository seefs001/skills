#!/usr/bin/env bash
set -euo pipefail

# NOTE: This is a dev-only script, intended for use by maintainers of this repo.
# It is not a supported installer. Modifications to it, or requests for
# modifications, will not be approved.
#
# Links all skills in the repository into the local skill directories used by
# each agent harness:
#   - ~/.claude/skills: Claude Code
#   - ~/.agents/skills: Codex and other Agent Skills-compatible harnesses
# Each entry is a symlink into this repo. Use `git pull --recurse-submodules`
# to update installed skills, including initialized submodules.

REPO="$(cd -P "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

canonical_existing_path() {
  local target="$1"
  local suffix=""
  while [ ! -e "$target" ] && [ "$target" != "/" ] && [ "$target" != "." ]; do
    suffix="/$(basename "$target")$suffix"
    target="$(dirname "$target")"
  done
  if [ -d "$target" ]; then
    printf '%s%s\n' "$(cd -P "$target" && pwd)" "$suffix"
  else
    local dir
    dir="$(cd -P "$(dirname "$target")" && pwd)"
    printf '%s/%s%s\n' "$dir" "$(basename "$target")" "$suffix"
  fi
}

# Collect the repo's skills once, link into every destination. `deprecated/`
# is retired, and `misc/` is kept around but rarely used and not promoted (see
# each bucket's own README): neither belongs in a daily-driver skill
# directory, so both are skipped here, same as everywhere else non-promoted
# skills are kept out. `in-progress/` IS still linked: it's public on purpose,
# feedback wanted, and this local install is exactly where that feedback loop
# runs.
names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  if [ "${#names[@]}" -gt 0 ] && printf '%s\n' "${names[@]}" | grep -qxF "$name"; then
    echo "skip $src: duplicate repo skill name $name" >&2
    continue
  fi
  names+=("$name")
  srcs+=("$src")
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -not -path '*/misc/*' -print0 | sort -z)

# Link vendored skills after repo-owned skills so local names win.
if [ ! -f "$REPO/vendor/ui-diff/skills/ui-diff/SKILL.md" ]; then
  echo "skip ui-diff: run git submodule update --init -- vendor/ui-diff and re-run this script" >&2
fi
for src in "$REPO/vendor/pstack/skills"/* "$REPO/vendor/mellamopablo/skills"/* "$REPO/vendor/ui-diff/skills"/*; do
  [ -f "$src/SKILL.md" ] || continue
  name="$(basename "$src")"
  if [ "${#names[@]}" -gt 0 ] && printf '%s\n' "${names[@]}" | grep -qxF "$name"; then
    echo "skip $src: name already linked"
    continue
  fi
  names+=("$name")
  srcs+=("$src")
done

for DEST in "${DESTS[@]}"; do
  # If $DEST or an ancestor resolves into this repo, we'd end up writing the
  # per-skill symlinks back into the repo's own tree. Detect and bail out.
  resolved="$(canonical_existing_path "$DEST")"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      echo "error: $DEST resolves into this repo ($resolved)." >&2
      echo "Remove the symlink into this repo and re-run; the script will recreate it as a real dir." >&2
      exit 1
      ;;
  esac

  mkdir -p "$DEST"

  # Prune broken symlinks in $DEST that still point into this repo (e.g. removed or renamed skills).
  for entry in "$DEST"/*; do
    [ -L "$entry" ] || continue
    [ -e "$entry" ] && continue
    link_target="$(readlink "$entry")"
    case "$link_target" in
      "$REPO"/*)
        rm "$entry"
        echo "pruned stale link $(basename "$entry") -> $link_target ($DEST)"
        ;;
    esac
  done

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -rf "$target"
    fi

    ln -sfn "$src" "$target"
    echo "linked $name -> $src ($DEST)"
  done
done
