#!/usr/bin/env bash
set -euo pipefail

# Manual sync of pstack (https://github.com/cursor/plugins/tree/main/pstack)
# into vendor/pstack/, adapted for Pi. See "Vendored pstack" in AGENTS.md.
#
# 1. Copies upstream's generated Claude Code tree (harness/pstack/claude-code),
#    which already rewrites Cursor-only links.
# 2. Applies the mechanical Pi adaptation below.
# 3. Keeps docs/harness/pi.md, the fork-owned adapter.
# Nothing from the download is executed: the clone is only copied.
#
# Usage: scripts/sync-pstack.sh [ref]   (default: main)

REPO="$(cd "$(dirname "$0")/.." && pwd)"
REF="${1:-main}"
DEST="$REPO/vendor/pstack"
PI_ADAPTER="docs/harness/pi.md"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Skill names this repo already owns. pstack's copies get a pstack- prefix.
RENAMES=(tdd teach)

git clone --quiet --depth 1 --branch "$REF" --filter=blob:none --sparse \
  https://github.com/cursor/plugins.git "$TMP/plugins"
git -C "$TMP/plugins" sparse-checkout set harness/pstack/claude-code
SRC="$TMP/plugins/harness/pstack/claude-code"
[ -f "$SRC/plugin.json" ] || { echo "error: upstream layout changed, $SRC/plugin.json missing" >&2; exit 1; }

# Keep the fork-owned adapter across the wipe.
[ -f "$DEST/$PI_ADAPTER" ] && cp "$DEST/$PI_ADAPTER" "$TMP/pi.md"

rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$SRC/." "$DEST/"
find "$DEST" -name node_modules -prune -exec rm -rf {} +

if [ -f "$TMP/pi.md" ]; then
  cp "$TMP/pi.md" "$DEST/$PI_ADAPTER"
else
  echo "warning: $PI_ADAPTER missing, write it before using the skills" >&2
fi

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
    s{^($n):(\s+)}{pstack-$1:$2}g;
    s{/pstack:([a-z-]+)}{/skill:$1}g;
    s{`pstack:(poteto-agent|comment-sicko)`}{`$1`}g;
    s{In Claude Code, read \[the Claude Code adapter\]\(((?:\.\./)+)docs/harness/claude-code\.md\) once per session before you follow this skill\. It maps the Cursor names in pstack skills to Claude Code\.}{Read [the Pi adapter]($1docs/harness/pi.md) once per session before you follow this skill. It maps the Cursor names in pstack skills to Pi.}g;
  '

COMMIT="$(git -C "$TMP/plugins" rev-parse HEAD)"
VERSION="$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$DEST/plugin.json" | head -1)"
cat > "$DEST/UPSTREAM" <<EOF
source: https://github.com/cursor/plugins/tree/$COMMIT/harness/pstack/claude-code
commit: $COMMIT
version: $VERSION
EOF

echo "synced pstack $VERSION ($COMMIT) into vendor/pstack"
echo "next: review the diff against the checklist in AGENTS.md (Vendored pstack)"
