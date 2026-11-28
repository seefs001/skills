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

STAGING="$(dirname "$DEST")/.mellamopablo.staging.$$"
trap 'rm -rf "$TMP" "$STAGING"' EXIT
mkdir -p "$STAGING"
cp -R "$SRC/." "$STAGING/"
find "$STAGING" -name node_modules -prune -exec rm -rf {} +
for path in "${EXCLUDE[@]}"; do rm -rf "${STAGING:?}/$path"; done

# Point vendored skill update hints and README at this fork's sync script instead of global npx skills update.
find "$STAGING/skills" -name 'SKILL.md' -print0 |
  xargs -0 perl -pi -e 's{`npx skills update [a-z0-9-]+ -g`}{`scripts/sync-mellamopablo.sh main` (in the skills repo)}g;'
if [ -f "$STAGING/README.md" ]; then
  perl -pi -e '
    s{^npx skills add MeLlamoPablo/skills -g$}{scripts/link-skills.sh};
    s{^npx skills update -g$}{scripts/sync-mellamopablo.sh main};
  ' "$STAGING/README.md"
fi

# Patch summarize-pr's update probe so fork-rewritten SKILL.md does not cause
# permanent false-positive update notices. Compare upstream tree SHAs instead.
CHECK_UPDATE="$STAGING/skills/summarize-pr/scripts/check-update.sh"
if [ -f "$CHECK_UPDATE" ]; then
  cat > "$CHECK_UPDATE" <<'EOF'
#!/usr/bin/env bash
# Says when GitHub has a newer version of this skill. Prints nothing when the installed files are up to date.
# Usage: check-update.sh
# In this fork, SKILL.md is adapted locally, so compare upstream tree SHAs
# against vendor/mellamopablo/UPSTREAM instead of hashing local files.
set -euo pipefail

skill=$(dirname "$0")/..
upstream_file="$skill/../../UPSTREAM"

if [ -f "$upstream_file" ]; then
	pinned_tree=$(sed -n 's/^summarize-pr-tree: *//p' "$upstream_file" 2>/dev/null || true)
	pinned_commit=$(sed -n 's/^commit: *//p' "$upstream_file" 2>/dev/null || true)
	latest_tree=$(gh api 'repos/MeLlamoPablo/skills/git/trees/main:skills/summarize-pr' --jq '.sha')
	if [ -z "$pinned_tree" ] && [ -n "$pinned_commit" ]; then
		pinned_tree=$(gh api "repos/MeLlamoPablo/skills/git/trees/${pinned_commit}:skills/summarize-pr" --jq '.sha')
	fi
	if [ -n "$pinned_tree" ] && [ "$latest_tree" != "$pinned_tree" ]; then
		echo "summarize-pr has an update."
	fi
	exit 0
fi

files=$(gh api 'repos/MeLlamoPablo/skills/git/trees/main:skills/summarize-pr?recursive=1' \
	--jq '.tree[] | select(.type == "blob") | "\(.sha)\t\(.path)"')

while IFS=$'\t' read -r sha path; do
	if [ "$(git hash-object --no-filters "$skill/$path" 2> /dev/null)" != "$sha" ]; then
		echo "summarize-pr has an update."
		exit 0
	fi
done <<< "$files"
EOF
  chmod +x "$CHECK_UPDATE"
fi

COMMIT="$(git -C "$TMP/repo" rev-parse HEAD)"
SUMMARIZE_PR_TREE="$(git -C "$TMP/repo" rev-parse HEAD:skills/summarize-pr 2>/dev/null || true)"
{
  echo "source: https://github.com/MeLlamoPablo/skills/tree/$COMMIT"
  echo "commit: $COMMIT"
  [ -n "$SUMMARIZE_PR_TREE" ] && echo "summarize-pr-tree: $SUMMARIZE_PR_TREE"
} > "$STAGING/UPSTREAM"

rm -rf "$DEST"
mv "$STAGING" "$DEST"

echo "synced MeLlamoPablo/skills ($COMMIT) into vendor/mellamopablo"
echo "next: review the diff against the checklist in AGENTS.md (Vendored MeLlamoPablo/skills)"
