# Fork Changelog

This fork tracks [mattpocock/skills](https://github.com/mattpocock/skills) while
keeping Seefs-specific changes separate from the upstream release history.

Use this file for fork-only notes. The upstream package changelog remains in
[CHANGELOG.md](./CHANGELOG.md).

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
