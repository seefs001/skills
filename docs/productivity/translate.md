Quickstart:

```bash
npx skills add mattpocock/skills --skill=translate
```

```bash
npx skills update translate
```

[Source](https://github.com/mattpocock/skills/tree/main/skills/productivity/translate)

## What it does

`translate` renders text between languages as a cross-cultural professional translator, judged on the **信达雅** triad — 信 (faithful), 达 (fluent), 雅 (elegant), in that priority order. A glossary you supply is binding: term mappings outrank every other instruction, including the style guide, so "Force Majeure = 不可抗力" holds on every occurrence without you repeating it.

## When to reach for it

You invoke this by typing `/translate` — the agent won't reach for it on its own. Pass the text plus, optionally, a target language, text type, glossary (`术语=译法｜…`), and style guide.

Reach for it whenever a translation has to survive scrutiny — contracts, papers, scripts, marketing copy, or casual prose where the voice matters — rather than a quick gist.

## The 信达雅 ladder

- **信 — zero distortion.** Glossary terms render exactly as bound. Culture-loaded items either domesticate ("雨后春笋" → "spring up like mushrooms") or transliterate with a gloss ("太极" → "Taiji (supreme harmony philosophy)").
- **达 — linguistic rebirth.** Grammar is restructured for the target: Chinese run-on chains become English main/subordinate structure; English complexity splits into Chinese short clause groups. Register follows text type — a contract never says "I'm".
- **雅 — style transplant.** Rhyme, puns, and parallelism get equivalent target-language devices, not literal renderings; formal texts keep passive voice consistent.

Spoken registers get their own dials — 生活/媒体/商务/网络口语 — from dialect-friendly casual prose to Power-Verb business English. Honorific levels (Japanese です・ます), RTL layout, and long-compound decomposition (German) are handled per language.

## It's working if

- Every glossary term appears exactly as bound, every time.
- The output ships in the fixed `原文 / 译文 / [译者注]` format, and the 译者注 appears only when a real judgment call was made — a cultural item handled, a rhetorical device converted, or an alternative rendering rejected with a reason.
- Long texts (500+ characters) stay terminologically and stylistically consistent to the end.

## Where it fits

`translate` is a reach-for-it-anytime standalone — it sits outside the build chains entirely. When you're unsure which skill fits the moment, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
