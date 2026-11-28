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
