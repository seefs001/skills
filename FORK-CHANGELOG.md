# Fork Changelog

This fork tracks [mattpocock/skills](https://github.com/mattpocock/skills) while
keeping Seefs-specific changes separate from the upstream release history.

Use this file for fork-only notes. The upstream package changelog remains in
[CHANGELOG.md](./CHANGELOG.md).

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
