# Fork Changelog

This fork tracks [mattpocock/skills](https://github.com/mattpocock/skills) while
keeping Seefs-specific changes separate from the upstream release history.

Use this file for fork-only notes. The upstream package changelog remains in
[CHANGELOG.md](./CHANGELOG.md).

## 2026-11-13

### Upstream sync

- Merged `upstream/main` at `5863806`: the software-factory vocabulary distinguishes tasks from CI jobs and workflows, and Explore tasks leave evidence on the ticket without pushing.
- Synced pstack from `cursor/plugins` main at `a5539b15a3d56e04992565aafee2b37051329ce3`. This is a metadata-only sync: the vendored content is unchanged and the version remains `0.15.36`.
- Existing `ask-matt` routing, docs, README summaries, and DSH/Pi adapters still apply because pstack's entry points, behaviour, and harness contract did not change. No skill links changed.
- Kept the fork's quoted `software-factory` description: its colon needs quoting for valid YAML. This parser fix remains suitable for upstream; no additional fork edits to upstream-owned files were needed.

## 2026-11-10

### pstack adapted for DeepSeek Harness

- Added the fork-owned `vendor/pstack/docs/harness/dsh.md` adapter: `Task` maps to `subagent` (fresh context, explicit delegation only), `AskQuestion` to `ask_user_question`, todolists to `todo_write`, `/loop` to `create_goal`, `resume` to `send_message`, and cloud workers to a git worktree passed as `cwd`. Per-role models map through `list_subagent_models`, so `setup-pstack` writes `~/.dsh/pstack-models.md` in DSH.
- Every pstack skill opener now links both the DSH and Pi adapters. `scripts/sync-pstack.sh` keeps both adapters across a sync and writes the new opener; `scripts/check-fork.sh` fails when an adapter or an opener link is missing.
- `ask-matt` (`SKILL.md`, `PSTACK.md`, docs page) and `state-modeling` name the DSH command syntax `/<name>` next to Pi's `/skill:<name>`.

## 2026-11-07

### Fork maintenance

- Restored upstream's descriptions for `tdd`, `diagnosing-bugs`, `code-review`, `codebase-design`, `domain-modeling`, `research` and `wizard`. The 2026-10-12 entry wrongly said these were unchanged: commit `86a9af5` had narrowed them, which dropped triggers such as "reports something broken" and "fix bugs test-first".
- Added `scripts/check-fork.sh`: plugin manifest, README and docs coverage, `ask-matt` routes for promoted and personal skills, relative links, em-dashes, and pstack name collisions.
- `CLAUDE.md` gains an "Upstream sync" procedure (merge, rerere, pstack sync, check, changelog) and drops the stale GPT Pro note from `personal/`.
- `.scratch/` is ignored.

### Paseo skills moved to `personal/`

- `paseo-artifacts` and `paseo-artifact` moved from `in-progress/` to `personal/`: they need Paseo, and the in-progress install command pointed at upstream, which lacks them.
- `paseo-artifact` renamed to `paseo-summary`, matching its `kind: summary` and no longer one letter away from `paseo-artifacts`. Fixed the broken inline code in `paseo-artifacts` step 1.

### `state-modeling`

- Charts are sized to the change: the reference drops the full checklist and completion list, and the risks step covers only edges the change can reach.
- Added guards (`[amount <= limit]`) to transitions and `[*]` terminal markers to the Mermaid example.
- Recommends pstack's user-invoked `statechart` model check when event interleavings decide correctness, without authorizing tool installs.

### `telegram-message`

- The length check counts UTF-16 code units, as Telegram does, so emoji-heavy messages no longer pass locally and fail remotely.

## 2026-11-06

### `ask-matt` routes into pstack

- Added a flow choice table and `ask-matt/PSTACK.md`, which maps entry points, overlaps (`tdd`/`pstack-tdd`, `teach`/`pstack-teach`, review, design, state) and Pi runtime limits, and defers the full catalogue to `poteto-help`.

## 2026-11-04

### Vendored pstack for Pi

- Added `vendor/pstack/` from `cursor/plugins` (`harness/pstack/claude-code`) with a Pi adapter, and `scripts/sync-pstack.sh`, which renames colliding skills and rewrites commands. `link-skills.sh` links the vendored skills.
- The sync defaults to the commit pinned in `vendor/pstack/UPSTREAM` and drops the `statechart` test corpora the runtime never loads (2026-11-07).

### Added Paseo artifact skills

- Added `paseo-artifacts` (model-invoked, registers files in the Artifacts collection) and `paseo-artifact` (user-invoked, writes a goal's summary Artifact).

## 2026-10-12

### Removed the Paseo picker field

- Removed `metadata.paseo` from every `SKILL.md`, dropping empty `metadata` blocks and preserving other metadata.
- Removed the picker-line requirement from `CLAUDE.md` (also linked as `AGENTS.md`) and the picker-line vocabulary from `GLOSSARY.md`.
- Skill behavior is unchanged by this removal. (Correction, 2026-11-07: commit `86a9af5` also narrowed seven skill descriptions; see that entry.)

## 2026-10-09

### Removed `call-kami`

- Deleted `skills/personal/call-kami/`. `ask-matt` and `skills/personal/README.md` no longer route to it.
- Existing dossiers under `~/Library/Application Support/call-kami` were left in place.

### Removed `translate`

- Deleted `skills/productivity/translate/`. Removed it from `ask-matt`, both READMEs, and `.claude-plugin/plugin.json`.
- Left `docs/productivity/translate.md` in place and marked it archived. No replacement.

## 2026-09-29

### Paseo picker line

- Added `metadata.paseo` to each skill's `SKILL.md` for a short Chinese picker line. This field was removed on 2026-10-12.

## 2026-09-03

### Align the fork with upstream conventions

- Every hook into `state-modeling` (`grill-with-docs`, `to-spec`, `to-tickets`,
  `implement`, `tdd`, `diagnosing-bugs`) now uses the Skill tool convention from
  `.agents/invocation.md`, skips the call when the spec or context already
  carries the chart, and shares one short trigger phrase instead of six copies
  of the full list. `tdd` gets its seam section back in one piece.
- `state-modeling` says where its chart lives (the driving skill's artifact,
  never a file of its own) and hands "does this feel right?" to `prototype`;
  its reference drops the stale PRD wording. The `to-spec` and `to-tickets`
  template sections read as omit-when-not-stateful placeholders.
- Docs pages for `state-modeling` and `translate` follow
  `.agents/writing-docs.md`: no install block or source link, common questions,
  dictionary links, fork URLs for repo links. The `implement`, `tdd`,
  `grill-with-docs`, and `diagnosing-bugs` pages now mention the hook.
- `ask-matt` maps `call-kami` and labels both personal skills as personal.
- Em-dashes removed from every fork-owned file; `translate` drops the `原文`
  echo past its long-text threshold.
- `telegram-message`: `send.py` runs on the macOS system Python 3.9
  (`from __future__ import annotations`, `socket.timeout`), accepts `export`
  and quoted lines in its env file, and the skill states the 4,096-character
  limit. `CLAUDE.md`/`AGENTS.md` document the `personal/` bucket.

## 2026-08-12

### Added `telegram-message`

- Added a model-invoked personal utility that sends any user-requested message
  to Seefs through Telegram. The explicit request is its only trigger.
- Bundled a dependency-free Python sender for Telegram Bot API
  `sendMessage` with HTML formatting; credentials stay in `TELEGRAM_BOT_TOKEN` and
  `TELEGRAM_ADMIN_ID`.
- Added the private messaging utility to `ask-matt`.

## 2026-08-10

### Split review from `implement`

- Removed the single forced `/code-review` step from `implement`; the rest of
  the implementation prompt is unchanged.
- Kept `code-review` as a separate, optional phase after the implementation
  commit, preferably run in a fresh session against the branch point.

## 2026-07-30

### Added `call-kami`

- Imported the locally installed `deep-think-brief` as
  `skills/personal/call-kami/`, the maintained source of truth for this
  user-invoked, local-only skill.
- Reworked the outbound artifact into a durable, comprehensive GPT Pro dossier
  with environment snapshots, evidence IDs, provenance, explicit omissions,
  stable redaction, and a separate cover prompt for manual upload.
- Added a return workflow that checks GPT Pro's claims against the dossier and
  current local evidence before any recommendation is used.

## 2026-07-26

### Added `translate`

- Added a user-invoked productivity skill at `skills/productivity/translate/`
  for 信达雅-standard translation with glossary binding, register control, and
  translator's notes.
- Worked examples live in `skills/productivity/translate/EXAMPLES.md` behind a
  context pointer.
- Wired the promoted-skill surfaces: plugin manifest entry, top-level README
  entry, productivity README entry, `/ask-matt` Standalone entry, and the
  human-facing docs page.

## 2026-07-06

### Added `state-modeling`

- Added a model-invoked engineering skill at
  `skills/engineering/state-modeling/` for clarifying lifecycle, status, and
  workflow behavior before implementation.
- Kept the reusable state-machine checklist in
  `skills/engineering/state-modeling/STATE-MODEL.md`; other skills call
  `/state-modeling` instead of copying the checklist.
- Wired `/state-modeling` into `/implement`, `/tdd`, `/to-spec`, `/to-tickets`,
  `/grill-with-docs`, `/diagnosing-bugs`, and `/ask-matt`.
- Added the promoted-skill surfaces: plugin manifest entry, top-level README
  entry, engineering README entry, and human-facing docs page.
- Left deprecated, misc, personal, and in-progress skills unchanged.
