# Fork Changelog

This fork tracks [mattpocock/skills](https://github.com/mattpocock/skills) while
keeping Seefs-specific changes separate from the upstream release history.

Use this file for fork-only notes. The upstream package changelog remains in
[CHANGELOG.md](./CHANGELOG.md).

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
- Wired `/state-modeling` into `/implement`, `/tdd`, `/to-prd`, `/to-issues`,
  `/grill-with-docs`, `/diagnosing-bugs`, and `/ask-matt`.
- Added the promoted-skill surfaces: plugin manifest entry, top-level README
  entry, engineering README entry, and human-facing docs page.
- Left deprecated, misc, personal, and in-progress skills unchanged.
