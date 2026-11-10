#!/usr/bin/env bash
set -euo pipefail

# Manual sync of pstack (https://github.com/cursor/plugins/tree/main/pstack)
# into vendor/pstack/, adapted for DeepSeek Harness (DSH) and Pi. See
# "Vendored pstack" in AGENTS.md.
#
# 1. Copies upstream's generated Claude Code tree (harness/pstack/claude-code),
#    which already rewrites Cursor-only links.
# 2. Applies the mechanical adaptation below.
# 3. Keeps docs/harness/dsh.md and docs/harness/pi.md, the fork-owned adapters.
# Nothing from the download is executed: the clone is only copied.
#
# Usage: scripts/sync-pstack.sh [ref]
#   No ref: re-sync the commit pinned in vendor/pstack/UPSTREAM (reproducible).
#   ref:    a branch, tag, or commit to upgrade to, e.g. `main`.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$REPO/vendor/pstack"
PINNED="$(sed -n 's/^commit: *//p' "$DEST/UPSTREAM" 2>/dev/null || true)"
REF="${1:-${PINNED:-main}}"
# Fork-owned adapters, one per local harness. Every skill opener links both.
ADAPTERS=(docs/harness/dsh.md docs/harness/pi.md)
# Upstream test corpora the local runtimes never load (about half the tree).
EXCLUDE=(skills/statechart/scripts/test)
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Skill names this repo already owns. pstack's copies get a pstack- prefix.
RENAMES=(tdd teach)

# Fetch works for a branch, tag, or full commit SHA alike.
git init --quiet "$TMP/plugins"
git -C "$TMP/plugins" remote add origin https://github.com/cursor/plugins.git
git -C "$TMP/plugins" sparse-checkout set harness/pstack/claude-code
git -C "$TMP/plugins" fetch --quiet --depth 1 --filter=blob:none origin "$REF"
git -C "$TMP/plugins" checkout --quiet FETCH_HEAD
SRC="$TMP/plugins/harness/pstack/claude-code"
[ -f "$SRC/plugin.json" ] || { echo "error: upstream layout changed, $SRC/plugin.json missing" >&2; exit 1; }

# Keep the fork-owned adapters across the wipe.
mkdir -p "$TMP/adapters"
for a in "${ADAPTERS[@]}"; do
  if [ -f "$DEST/$a" ]; then cp "$DEST/$a" "$TMP/adapters/$(basename "$a")"; fi
done

rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$SRC/." "$DEST/"
find "$DEST" -name node_modules -prune -exec rm -rf {} +
for path in "${EXCLUDE[@]}"; do rm -rf "${DEST:?}/$path"; done

for a in "${ADAPTERS[@]}"; do
  if [ -f "$TMP/adapters/$(basename "$a")" ]; then
    cp "$TMP/adapters/$(basename "$a")" "$DEST/$a"
  else
    echo "warning: $a missing, write it before using the skills" >&2
  fi
done

# Rename skills that collide with this repo.
for n in "${RENAMES[@]}"; do
  if [ -d "$DEST/skills/$n" ]; then
    mv "$DEST/skills/$n" "$DEST/skills/pstack-$n"
    perl -pi -e "s/^name: $n\$/name: pstack-$n/" "$DEST/skills/pstack-$n/SKILL.md"
  fi
done
names_re="$(IFS='|'; echo "${RENAMES[*]}")"

# Mechanical rewrites across every markdown file except the two adapters.
find "$DEST" -name '*.md' -not -path "*/docs/harness/*" -print0 |
  NAMES="$names_re" xargs -0 perl -pi -e '
    BEGIN { $n = $ENV{NAMES} }
    s{(\.\./|skills/)($n)/}{$1pstack-$2/}g;
    s{(?<![\w/-])/($n)\b}{/pstack-$1}g;
    s{\*\*($n)\*\* skill}{**pstack-$1** skill}g;
    s{`($n)`, and the principles}{`pstack-$1`, and the principles}g;
    s{/pstack:([a-z-]+)}{/skill:$1}g;
    s{`pstack:(poteto-agent|comment-sicko)`}{`$1`}g;
    s{In Claude Code, read \[the Claude Code adapter\]\(((?:\.\./)+)docs/harness/claude-code\.md\) once per session before you follow this skill\. It maps the Cursor names in pstack skills to Claude Code\.}{Read your harness adapter once per session before you follow this skill: [DeepSeek Harness]($1docs/harness/dsh.md) or [Pi]($1docs/harness/pi.md). It maps the Cursor names in pstack skills to that harness.}g;
  '

# README's command table starts lines with "<skill>:". Only that file has it.
NAMES="$names_re" perl -pi -e 'BEGIN { $n = $ENV{NAMES} } s{^($n):(\s+)}{pstack-$1:$2}' "$DEST/README.md"

COMMIT="$(git -C "$TMP/plugins" rev-parse HEAD)"
VERSION="$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$DEST/plugin.json" | head -1)"
cat > "$DEST/UPSTREAM" <<EOF
source: https://github.com/cursor/plugins/tree/$COMMIT/harness/pstack/claude-code
commit: $COMMIT
version: $VERSION
EOF

echo "synced pstack $VERSION ($COMMIT) into vendor/pstack"
echo "next: review the diff against the checklist in AGENTS.md (Vendored pstack)"
