#!/usr/bin/env bash
set -uo pipefail

# Fork invariants from CLAUDE.md (also linked as AGENTS.md). Run after every
# upstream merge and pstack sync. Read-only; exits non-zero on any failure.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
fail=0
err() { echo "FAIL: $*"; fail=1; }

promoted=$(find skills/engineering skills/productivity -name SKILL.md | xargs -n1 dirname | sort)
manifest=$(sed -n 's/^ *"\.\/\(skills\/[^"]*\)",\{0,1\}$/\1/p' .claude-plugin/plugin.json | sort)

# 1. plugin.json ships exactly the promoted set.
while read -r d; do [ -n "$d" ] && err "promoted $d missing from plugin.json"; done < <(comm -23 <(echo "$promoted") <(echo "$manifest"))
while read -r d; do [ -n "$d" ] && err "plugin.json lists non-promoted $d"; done < <(comm -13 <(echo "$promoted") <(echo "$manifest"))

# 2. Promoted skills appear in the top-level README; every bucket README lists its skills.
for d in $promoted; do grep -qF "](./$d/SKILL.md)" README.md || err "README.md missing $d"; done
for bucket in skills/*/; do
  [ "$(basename "$bucket")" = deprecated ] && continue
  for s in "$bucket"*/SKILL.md; do
    [ -f "$s" ] || continue
    n=$(basename "$(dirname "$s")")
    grep -qF "](./$n/SKILL.md)" "$bucket/README.md" || err "${bucket}README.md missing $n"
  done
done

# 3. Promoted skills have a docs page.
for d in $promoted; do
  b=$(basename "$(dirname "$d")"); n=$(basename "$d")
  [ -f "docs/$b/$n.md" ] || err "docs/$b/$n.md missing"
done

# 4. ask-matt names every promoted and personal skill (upstream leaves in-progress/ unmapped).
for s in $(find skills/engineering skills/productivity skills/personal -name SKILL.md); do
  n=$(basename "$(dirname "$s")")
  [ "$n" = ask-matt ] && continue
  grep -qF "/$n\`" skills/engineering/ask-matt/SKILL.md || err "ask-matt does not route to /$n"
done

# 5. Relative links in fork-owned markdown resolve.
while IFS= read -r f; do
  dir=$(dirname "$f")
  awk '/^ *```/{c=!c; next} !c' "$f" | sed -E 's/`[^`]*`//g' | grep -oE '\]\(\.{0,2}[^):#]*\.md' | sed 's/^](//' | while read -r link; do
    case "$link" in http*|/*) continue ;; esac
    [ -e "$dir/$link" ] || echo "FAIL: $f links missing $link"
  done
done < <(find skills README.md CLAUDE.md FORK-CHANGELOG.md -name '*.md' -not -path '*/deprecated/*') | tee /tmp/check-fork-links.$$
[ -s /tmp/check-fork-links.$$ ] && fail=1; rm -f /tmp/check-fork-links.$$

# 6. No em-dashes in fork prose (vendor/ and the upstream CHANGELOG are exempt).
EM=$(printf '\342\200\224')
if rg -l "$EM" --glob '!vendor/**' --glob '!CHANGELOG.md' --glob '!.scratch/**' --glob '!node_modules/**' . >/tmp/check-fork-em.$$; then
  while read -r f; do err "em-dash in $f"; done </tmp/check-fork-em.$$
fi
rm -f /tmp/check-fork-em.$$

# 7. Vendored pstack: no name collisions, no leftover Claude Code adapter openers.
if [ -d vendor/pstack/skills ]; then
  own=$(find skills -name SKILL.md -not -path '*/deprecated/*' | xargs -n1 dirname | xargs -n1 basename | sort)
  for n in $(comm -12 <(echo "$own") <(ls vendor/pstack/skills | sort)); do err "pstack skill $n collides with this repo; add it to RENAMES"; done
  rg -l 'In Claude Code, read \[the Claude Code adapter' vendor/pstack/skills >/tmp/check-fork-cc.$$ &&
    while read -r f; do err "unadapted Claude Code opener in $f"; done </tmp/check-fork-cc.$$
  rm -f /tmp/check-fork-cc.$$
  for a in dsh pi; do [ -f "vendor/pstack/docs/harness/$a.md" ] || err "vendor/pstack/docs/harness/$a.md missing"; done
  for s in vendor/pstack/skills/*/SKILL.md; do
    grep -q 'harness adapter' "$s" || continue
    grep -q 'docs/harness/dsh\.md' "$s" || err "$s opener does not link the DSH adapter"
    grep -q 'docs/harness/pi\.md' "$s" || err "$s opener does not link the Pi adapter"
  done
fi

[ "$fail" = 0 ] && echo "fork invariants ok"
exit "$fail"
