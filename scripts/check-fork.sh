#!/usr/bin/env bash
set -uo pipefail

# Fork invariants from CLAUDE.md (also linked as AGENTS.md). Run after every
# upstream merge and pstack sync. Read-only; exits non-zero on any failure.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
fail=0
err() { echo "FAIL: $*"; fail=1; }

promoted=$(find skills/engineering skills/productivity -name SKILL.md | xargs -n1 dirname | sort)
manifest=$(node -e '
  const fs = require("node:fs");
  const pkg = JSON.parse(fs.readFileSync(".claude-plugin/plugin.json", "utf8"));
  if (!Array.isArray(pkg.skills)) process.exit(2);
  for (const entry of pkg.skills) {
    console.log(String(entry).replace(/^\.\//, ""));
  }
' | sort) || err "failed to parse .claude-plugin/plugin.json"

# 1. plugin.json ships exactly the promoted set.
while read -r d; do [ -n "$d" ] && err "promoted $d missing from plugin.json"; done < <(comm -23 <(echo "$promoted") <(echo "$manifest"))
while read -r d; do [ -n "$d" ] && err "plugin.json lists non-promoted $d"; done < <(comm -13 <(echo "$promoted") <(echo "$manifest"))

# 2. Promoted skills appear in the top-level README; non-promoted skills do not; every bucket README lists its skills.
for d in $promoted; do grep -qF "](./$d/SKILL.md)" README.md || err "README.md missing $d"; done
while IFS= read -r s; do
  [ -n "$s" ] || continue
  d=$(dirname "$s")
  grep -qF "](./$d/SKILL.md)" README.md && err "README.md lists non-promoted $d"
done < <(find skills/in-progress skills/misc skills/deprecated skills/personal -name SKILL.md 2>/dev/null | sort)
for bucket in skills/*/; do
  [ "$(basename "$bucket")" = deprecated ] && continue
  for s in "$bucket"*/SKILL.md; do
    [ -f "$s" ] || continue
    n=$(basename "$(dirname "$s")")
    grep -qF "](./$n/SKILL.md)" "$bucket/README.md" || err "${bucket}README.md missing $n"
  done
done

# 3. Promoted skills have a docs page; non-promoted skills do not (unless archived).
for d in $promoted; do
  b=$(basename "$(dirname "$d")"); n=$(basename "$d")
  [ -f "docs/$b/$n.md" ] || err "docs/$b/$n.md missing"
done
while IFS= read -r doc; do
  [ -n "$doc" ] || continue
  b=$(basename "$(dirname "$doc")")
  n=$(basename "$doc" .md)
  if [ ! -f "skills/$b/$n/SKILL.md" ]; then
    head -n 1 "$doc" | grep -q 'Archived' || err "orphan unarchived docs page $doc"
  fi
done < <(find docs/engineering docs/productivity -maxdepth 2 -name '*.md' 2>/dev/null | sort)

# 4. ask-matt names every promoted and personal skill (upstream leaves in-progress/ unmapped).
for s in $(find skills/engineering skills/productivity skills/personal -name SKILL.md); do
  n=$(basename "$(dirname "$s")")
  [ "$n" = ask-matt ] && continue
  grep -qF "/$n\`" skills/engineering/ask-matt/SKILL.md || err "ask-matt does not route to /$n"
done

# 5. Relative links in fork-owned markdown resolve (strictly read-only, no /tmp files).
while IFS= read -r f; do
  dir=$(dirname "$f")
  while IFS= read -r link; do
    [ -n "$link" ] || continue
    case "$link" in http*|/*) continue ;; esac
    [ -e "$dir/$link" ] || err "$f links missing $link"
  done < <(awk '/^ *```/{c=!c; next} !c' "$f" | sed -E 's/`[^`]*`//g' | grep -oE '\]\(\.{0,2}[^):#]*\.md' | sed 's/^](//')
done < <(find skills global-agents README.md CLAUDE.md FORK-CHANGELOG.md -name '*.md' -not -path '*/deprecated/*')

# 6. No em-dashes in fork prose (vendor/ and the upstream CHANGELOG are exempt).
EM=$(printf '\342\200\224')
em_hits=$(rg -l "$EM" --glob '!vendor/**' --glob '!CHANGELOG.md' --glob '!.scratch/**' --glob '!node_modules/**' . || true)
while IFS= read -r f; do [ -n "$f" ] && err "em-dash in $f"; done <<< "$em_hits"

# 7. Vendored pstack: no name collisions, no leftover Claude Code adapter openers, no corrupted /pstack: docs.
if [ -d vendor/pstack/skills ]; then
  own=$(find skills -name SKILL.md -not -path '*/deprecated/*' | xargs -n1 dirname | xargs -n1 basename | sort)
  for n in $(comm -12 <(echo "$own") <(ls vendor/pstack/skills | sort)); do err "pstack skill $n collides with this repo; add it to RENAMES"; done
  cc_hits=$(rg -l 'In Claude Code, read \[the Claude Code adapter' vendor/pstack/skills || true)
  while IFS= read -r f; do [ -n "$f" ] && err "unadapted Claude Code opener in $f"; done <<< "$cc_hits"
  prefix_hits=$(rg -l 'pstack:` prefix, such as `/skill:|so `/poteto-mode` is `/skill:' vendor/pstack || true)
  while IFS= read -r f; do [ -n "$f" ] && err "corrupted Claude Code /pstack: example in $f"; done <<< "$prefix_hits"
  for a in dsh pi; do [ -f "vendor/pstack/docs/harness/$a.md" ] || err "vendor/pstack/docs/harness/$a.md missing"; done
  for s in vendor/pstack/skills/*/SKILL.md; do
    grep -q 'harness adapter' "$s" || continue
    grep -q 'docs/harness/dsh\.md' "$s" || err "$s opener does not link the DSH adapter"
    grep -q 'docs/harness/pi\.md' "$s" || err "$s opener does not link the Pi adapter"
  done
fi

# 8. Vendored MeLlamoPablo/skills: no name collisions, no upstream AGENTS.md, UPSTREAM present, adapted update hint.
if [ -d vendor/mellamopablo/skills ]; then
  own=$(find skills -name SKILL.md -not -path '*/deprecated/*' | xargs -n1 dirname | xargs -n1 basename | sort)
  pstack_names=""
  [ -d vendor/pstack/skills ] && pstack_names=$(ls vendor/pstack/skills | sort)
  existing=$(printf '%s\n%s\n' "$own" "$pstack_names" | sed '/^$/d' | sort -u)
  for n in $(comm -12 <(echo "$existing") <(ls vendor/mellamopablo/skills | sort)); do
    err "mellamopablo skill $n collides with an existing skill"
  done
  [ -e vendor/mellamopablo/AGENTS.md ] && err "vendor/mellamopablo/AGENTS.md should be excluded by sync-mellamopablo.sh"
  [ -f vendor/mellamopablo/UPSTREAM ] || err "vendor/mellamopablo/UPSTREAM missing"
  mp_hits=$(rg -l 'npx skills update( [a-z0-9-]+)? -g' vendor/mellamopablo || true)
  while IFS= read -r f; do [ -n "$f" ] && err "unadapted npx skills update hint in $f"; done <<< "$mp_hits"
fi

# 9. Vendored ui-diff: no name collisions against repo or other vendored skills.
if [ -d vendor/ui-diff/skills ]; then
  own=$(find skills -name SKILL.md -not -path '*/deprecated/*' | xargs -n1 dirname | xargs -n1 basename | sort)
  pstack_names=""
  mp_names=""
  [ -d vendor/pstack/skills ] && pstack_names=$(ls vendor/pstack/skills | sort)
  [ -d vendor/mellamopablo/skills ] && mp_names=$(ls vendor/mellamopablo/skills | sort)
  existing=$(printf '%s\n%s\n%s\n' "$own" "$pstack_names" "$mp_names" | sed '/^$/d' | sort -u)
  ui_diff_names=$(find vendor/ui-diff/skills -maxdepth 2 -name SKILL.md | xargs -n1 dirname | xargs -n1 basename | sort)
  for n in $(comm -12 <(echo "$existing") <(echo "$ui_diff_names")); do
    err "ui-diff skill $n collides with an existing skill"
  done
fi

# 10. All repo SKILL.md frontmatter parses cleanly (upstream check-frontmatter.mjs).
if [ -f scripts/check-frontmatter.mjs ]; then
  if ! fm_out=$(node scripts/check-frontmatter.mjs 2>&1); then
    echo "$fm_out"
    err "frontmatter check failed"
  fi
fi

# 11. Global agent instruction files: link targets exist, no auto-discovered filenames, no local /Users/ paths, shared policy blocks match.
if [ -f scripts/link-agents.sh ]; then
  while read -r rel; do
    [ -n "$rel" ] || continue
    [ -f "$rel" ] || err "scripts/link-agents.sh references missing $rel"
  done < <(sed -n 's|.*"\$REPO/\(global-agents/[^"]*\)".*|\1|p' scripts/link-agents.sh)
fi
if [ -d global-agents ]; then
  while IFS= read -r hit; do
    [ -n "$hit" ] && err "$hit risks auto-discovery inside this repo; use a harness-specific filename"
  done < <(find global-agents -maxdepth 1 \( -iname 'AGENTS.md' -o -iname 'CLAUDE.md' -o -iname 'GEMINI.md' \))
  abs_hits=$(rg -l '/Users/[A-Za-z0-9._-]+/' global-agents || true)
  while IFS= read -r f; do [ -n "$f" ] && err "hardcoded local user path in $f"; done <<< "$abs_hits"
  base_astrlink=$(awk '/^<!-- astrlink-debug:begin -->/,/^<!-- astrlink-debug:end -->/' global-agents/dsh.md)
  for gf in global-agents/pi-append-system.md global-agents/claude-code.md global-agents/codex.md global-agents/agy.md global-agents/home.md; do
    [ -f "$gf" ] || continue
    cur_astrlink=$(awk '/^<!-- astrlink-debug:begin -->/,/^<!-- astrlink-debug:end -->/' "$gf")
    [ "$cur_astrlink" = "$base_astrlink" ] || err "AstrLink block drifted in $gf compared to global-agents/dsh.md"
  done
fi

[ "$fail" = 0 ] && echo "fork invariants ok"
exit "$fail"
