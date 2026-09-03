## What it does

`translate` renders text between languages as a professional translator would, judged on the **信达雅** triad in strict priority order: 信 (faithful), then 达 (fluent), then 雅 (elegant). A glossary you supply is binding. Term mappings outrank every other instruction, including the style guide, so `Force Majeure=不可抗力` holds on every occurrence without you repeating it, and a prettier rendering never wins over the bound one.

## When to reach for it

You invoke this by typing `/translate`; the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) won't reach for it on its own. Pass the text plus, optionally, a target language, a text type, a glossary (`术语=译法｜…`), and a style guide. Anything missing is inferred, and you are asked only when the choice would change the output.

Reach for it when a translation has to survive scrutiny (a contract, a paper, a script, marketing copy, casual prose where the voice matters) rather than a quick gist you could get by asking the model directly.

## The 信达雅 ladder

| Rung | What it guarantees |
| --- | --- |
| **信**, zero distortion | Glossary terms render exactly as bound. Culture-loaded items either domesticate ("雨后春笋" becomes "spring up like mushrooms") or transliterate with a gloss ("太极" becomes "Taiji (supreme harmony philosophy)"). |
| **达**, linguistic rebirth | Grammar is rebuilt for the target: Chinese run-on chains become English main/subordinate structure, English complexity splits into Chinese short clause groups. Register follows text type; a contract never says "I'm". |
| **雅**, style transplant | Rhyme, puns, and parallelism get equivalent target-language devices, not literal renderings; formal texts keep their passive voice consistent throughout. |

Spoken registers get their own dials (生活, 媒体, 商务, 网络口语), from dialect-friendly casual prose to Power-Verb business English. Japanese honorific level, right-to-left layout, and German compound decomposition are handled per language.

## Common questions

**The glossary term reads awkwardly in context. Will it bend the term to fit?**
No. 信 outranks 达, and a bound term outranks the style guide, so the term stands and the sentence around it is restructured instead. If the binding itself is wrong, change the glossary; the skill will not quietly do it for you.

**Why is there sometimes no `[译者注]`?**
Because nothing earned one. The note fires only on a judgment call: a culture-loaded term that needed a handling decision, a rhetorical device converted rather than carried, or an alternative rendering worth recording with the reason it lost. A clean technical paragraph produces a translation and nothing else.

**Does it echo the whole source back on long documents?**
No. Short texts ship with the 原文 alongside for side-by-side checking. Past roughly 500 characters the 原文 block is dropped, since you already hold the source, and the run instead builds a working glossary on the first pass and holds it, with the chosen style, to the end.

## It's working if

- Every glossary term appears exactly as bound, every time, even where a freer rendering would read better.
- The output arrives in the fixed `原文 / 译文 / [译者注]` shape, and the 译者注 is present only when a real judgment call was made.
- Register matches the text type without being asked: contractions in chat, none in a contract, です・ます in Japanese business mail.
- A long text is as consistent in its last paragraph as in its first.

## Where it fits

`translate` is a reach-for-it-anytime standalone, outside every build chain. Its nearest neighbour is [wait-what](https://aihero.dev/skills-wait-what), which also re-renders text you cannot use as-is, but within one language and for meaning, where this skill crosses languages for fidelity. When you're unsure which skill fits the moment, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
