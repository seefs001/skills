Skills are organized into bucket folders under `skills/`:

- `engineering/`: daily code work
- `productivity/`: daily non-code workflow tools
- `misc/`: kept around but rarely used, not promoted
- `in-progress/`: beta: public on purpose, feedback wanted, not shipped in the plugin
- `deprecated/`: no longer used
- `personal/`: fork-only, tied to Seefs' own setup (Telegram, GPT Pro dossiers); not promoted, linked locally by `scripts/link-skills.sh`

Every skill in `engineering/` or `productivity/` (the **promoted** buckets) must have a reference in the top-level `README.md` and an entry in `.claude-plugin/plugin.json`'s `skills` array (the Claude Code plugin ships exactly the promoted set). Skills in `misc/`, `in-progress/`, `deprecated/`, and `personal/` must not appear in either.

Install commands are copied verbatim from [.agents/install-block.md](./.agents/install-block.md). `.claude-plugin/marketplace.json` is the repo's own marketplace. Every agent except Claude Code installs from it to get automatic updates, and Claude Code uses `claude-plugins-official`. Run `claude plugin validate . --strict` after touching either manifest. [ADR 0002](./.agents/adr/0002-ship-as-a-claude-code-plugin.md) records why.

Each skill entry in the top-level `README.md` must link the skill name to its `SKILL.md`.

Each bucket folder has a `README.md` that lists every skill in the bucket with a one-line description, with the skill name linked to its `SKILL.md`. The promoted buckets' `README.md`s and the top-level `README.md` group entries into **User-invoked** and **Model-invoked**; non-promoted bucket `README.md`s (`misc/`, `in-progress/`, `personal/`) use a flat list.

Skills in `engineering/` and `productivity/` also have a human-facing docs page at `docs/<bucket>/<skill-name>.md` (the docs tree mirrors those two bucket folders under `skills/`). The published URL is `https://aihero.dev/skills-<skill-name>` regardless of bucket: the docs path is repo organisation only. When you add, rename, or change the behaviour of a skill in `engineering/` or `productivity/`, create or re-sync its docs page following [.agents/writing-docs.md](./.agents/writing-docs.md). A finished page carries four sections: **What it does**, **When to reach for it**, **Common questions**, and **It's working if**. `writing-docs.md` holds the template, the section order, and where to hunt for the questions. Skills in the non-promoted buckets (`misc/`, `in-progress/`, `deprecated/`, `personal/`) get **no** docs page. The one exception is a promoted skill removed outright: its page stays, marked archived (see `writing-docs.md`).

Every `SKILL.md` is either user-invoked (`disable-model-invocation: true` plus `policy.allow_implicit_invocation: false` in `agents/openai.yaml`, reachable only by the human) or model-invoked (model- or user-reachable). See [.agents/invocation.md](./.agents/invocation.md).

[`ask-matt`](./skills/engineering/ask-matt/SKILL.md) is the router that maps every user-reachable skill and how they relate. The same trigger that re-syncs a docs page applies to it: whenever you add, rename, remove, or change how a user-reachable skill fits the flows, re-read `ask-matt`'s `SKILL.md` and update it so the map stays accurate: a new skill it never mentions, or a stale one it still routes to, is a router that lies. `personal/` skills are mapped too, labelled `(personal)` so a plugin user knows the route is not shipped to them.

To (re)link every skill outside `deprecated/` and `misc/` into the local harness skill directories (`~/.claude/skills`, `~/.agents/skills`), run `scripts/link-skills.sh`. Each entry is a symlink into this repo, so a `git pull` keeps installed skills current; re-run the script after adding, removing, or renaming a skill.

No em-dashes anywhere in this repo's prose (`SKILL.md` files, docs, `README.md`, `CHANGELOG.md`, ADRs, changesets, code comments). Where a sentence reaches for one, rewrite it instead with a comma, colon, period, parentheses, or a conjunction, whichever the sentence actually wants; never do a blind character substitution.

Every skill that dispatches a subagent says to start it with a fresh context window. Some harnesses (Codex, for one) fork the parent conversation by default, and a fork inherits the parent's context, which is what the subagent was meant to escape.

## Agent skills

### Vendored pstack

`vendor/pstack/` is upstream pstack's Claude Code tree (`cursor/plugins`, `harness/pstack/claude-code`), adapted for Pi. Sync it by hand, in the same session as every `upstream` (mattpocock/skills) sync:

1. Run `scripts/sync-pstack.sh`. It replaces `vendor/pstack/`, keeps `docs/harness/pi.md`, renames colliding skills (`tdd` to `pstack-tdd`, `teach` to `pstack-teach`), rewrites `/pstack:<name>` to `/skill:<name>`, and points every skill at the Pi adapter instead of the Claude Code one.
2. Review `git diff vendor/pstack`. Check that:
   - no skill still opens with "In Claude Code, read the Claude Code adapter" (`rg -l 'In Claude Code, read \[the Claude Code adapter' vendor/pstack/skills` prints nothing; `poteto-help` mentions the adapter in its install notes, which is fine);
   - no new skill name collides with one under `skills/` (compare `ls vendor/pstack/skills` with this repo's skill names). Add any collision to `RENAMES` in the script and re-run;
   - `docs/harness/pi.md` still covers every row of `docs/harness/claude-code.md`. When upstream adds a Cursor name, tool, or field, add the matching Pi row by hand.
3. Edit vendored files by hand only for adaptations the script cannot express, and move each repeatable one into the script so the next sync keeps it.

Vendored skills sit outside the bucket rules above (no README, plugin.json, docs page, or `ask-matt` entry). `scripts/link-skills.sh` links them locally and skips any name this repo already owns.

### Triage labels

Canonical names, unchanged. See `docs/agents/triage-labels.md`. Issues are judged against [`SCOPE.md`](./SCOPE.md).
