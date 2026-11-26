#!/usr/bin/env bash
set -euo pipefail

# Manual sync of MeLlamoPablo/skills (https://github.com/MeLlamoPablo/skills)
# into vendor/mellamopablo/. See "Vendored MeLlamoPablo/skills" in AGENTS.md.
#
# 1. Fetches the pinned commit (or requested ref) from GitHub without executing
#    anything from the download.
# 2. Copies the repo tree into vendor/mellamopablo/, dropping .git, node_modules,
#    and upstream's repo-owner AGENTS.md.
# 3. Rewrites global `npx skills update` hints to this fork's sync script.
# 4. Writes vendor/mellamopablo/UPSTREAM with the source URL and commit SHA.
#
# Usage: scripts/sync-mellamopablo.sh [ref]
#   No ref: re-sync the commit pinned in vendor/mellamopablo/UPSTREAM (reproducible).
#   ref:    a branch, tag, or commit to upgrade to, e.g. `main`.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$REPO/vendor/mellamopablo"
PINNED="$(sed -n 's/^commit: *//p' "$DEST/UPSTREAM" 2>/dev/null || true)"
REF="${1:-${PINNED:-main}}"
# Upstream AGENTS.md tells agents to auto-commit and push in that repo.
EXCLUDE=(.git AGENTS.md)
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Fetch works for a branch, tag, or full commit SHA alike.
git init --quiet "$TMP/repo"
git -C "$TMP/repo" remote add origin https://github.com/MeLlamoPablo/skills.git
git -C "$TMP/repo" fetch --quiet --depth 1 origin "$REF"
git -C "$TMP/repo" checkout --quiet FETCH_HEAD
SRC="$TMP/repo"
[ -d "$SRC/skills" ] || { echo "error: upstream layout changed, $SRC/skills missing" >&2; exit 1; }

rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$SRC/." "$DEST/"
find "$DEST" -name node_modules -prune -exec rm -rf {} +
for path in "${EXCLUDE[@]}"; do rm -rf "${DEST:?}/$path"; done

# Point vendored skill update hints at this fork's sync script instead of global npx skills update.
find "$DEST/skills" -name 'SKILL.md' -print0 |
  xargs -0 perl -pi -e 's{`npx skills update [a-z0-9-]+ -g`}{`scripts/sync-mellamopablo.sh main` (in the skills repo)}g;'

COMMIT="$(git -C "$TMP/repo" rev-parse HEAD)"
cat > "$DEST/UPSTREAM" <<EOF
source: https://github.com/MeLlamoPablo/skills/tree/$COMMIT
commit: $COMMIT
EOF

echo "synced MeLlamoPablo/skills ($COMMIT) into vendor/mellamopablo"
echo "next: review the diff against the checklist in AGENTS.md (Vendored MeLlamoPablo/skills)"
