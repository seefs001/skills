#!/usr/bin/env bash
# Says when GitHub has a newer version of this skill. Prints nothing when the installed files are up to date.
# Usage: check-update.sh
# It compares the git hash of each installed file with the hash that GitHub has for that file. It does not download or
# run code.
set -euo pipefail

skill=$(dirname "$0")/..
files=$(gh api 'repos/MeLlamoPablo/skills/git/trees/main:skills/summarize-pr?recursive=1' \
	--jq '.tree[] | select(.type == "blob") | "\(.sha)\t\(.path)"')

while IFS=$'\t' read -r sha path; do
	if [ "$(git hash-object --no-filters "$skill/$path" 2> /dev/null)" != "$sha" ]; then
		echo "summarize-pr has an update."
		exit 0
	fi
done <<< "$files"
