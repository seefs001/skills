## What it does

`ask-matt` is the router over the skills in this repo. You describe the situation you are in (an idea you cannot start, a pile of incoming bug reports, a [session](https://www.aihero.dev/ai-coding-dictionary/session) that has run long), and it names the skill or the sequence of skills that fits, plus where the human decisions in that sequence sit.

It recommends and stops. It reads the relevant skill files to check its advice, but does not grill, write a [spec](https://www.aihero.dev/ai-coding-dictionary/spec) or run the skill it just named. What you get back is the next thing to type. The map covers this fork's skills and its locally linked pstack branch, not every skill you happen to have installed.

## When to reach for it

You invoke this by typing `/ask-matt` (`/skill:ask-matt` in Pi); the agent won't reach for it on its own.

| Your situation | What the router gives back |
| --- | --- |
| An idea, and no idea where to start | The head of the main flow, and whether the build is small enough to skip the spec |
| Bugs and requests arriving from other people | The [triage](https://aihero.dev/skills-triage) on-ramp, and why [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) you generated yourself don't belong on it |
| Two skills that look interchangeable | The line between them, and it is usually one concrete test rather than a matter of taste. [grill-me](https://aihero.dev/skills-grill-me) or [grill-with-docs](https://aihero.dev/skills-grill-with-docs) turns on whether you are in a working directory; [grill-with-docs](https://aihero.dev/skills-grill-with-docs) or [wayfinder](https://aihero.dev/skills-wayfinder) turns on whether the effort fits one session |
| A long session and a decision about the [context](https://www.aihero.dev/ai-coding-dictionary/context) | The ordered tree over the five options at a phase boundary |
| A skill you have already picked | Nothing useful. Invoke that skill directly. |

## Prerequisites

The router names skills; it does not install them. Everything it points at has to be installed for the recommendation to be actionable. It knows the promoted skills, explicitly mapped personal and experimental skills, and this fork's locally linked pstack skills. The promoted Claude Code plugin does not include pstack.

The tracker-dependent routes (triage, `to-spec`, `to-tickets`, `implement`) assume [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) has already configured an issue tracker in the repo. The router recommends them even before that has happened.

## Flows, not skills

The skill's leading word is **flow**, a path *through* the skills rather than a single skill. When you name your situation, the router places you at a step on a flow. That is a different answer from "here is the skill that matches your keywords". There are five kinds of route, and the skill itself describes them in full:

- **The main flow**, idea to ship. Grill, spec, tickets, implement (one ticket at a time, or the whole task graph in parallel with [implement-spec](https://aihero.dev/skills-implement-spec)), review, then [retro](https://aihero.dev/skills-retro), which feeds what the build taught back into the agent's environment. It has two branches. One is a prototype detour, for when a question needs runnable code to settle it. The other is the spec-and-tickets split, which is only worth its cost when the build spans more than one session.
- **On-ramps**, for a situation that generates work and then merges onto the main flow: incoming bug reports, something broken, or an effort too foggy and too large to hold in one session.
- **Codebase health**, upkeep rather than feature work. [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) surveys the code for deepening opportunities, and each one it finds re-enters the main flow as an idea.
- **Standalones**, which sit off every flow and which you use on their own: the prototype, the questionnaire, the research run. The experimental [chief-of-staff](https://github.com/seefs001/skills/blob/main/skills/in-progress/chief-of-staff/SKILL.md) coordinates subagents toward a long-running goal, prefers an existing shared wiki and takes larger work through spec, tickets and implementation. The experimental [software-factory](https://github.com/seefs001/skills/blob/main/skills/in-progress/software-factory/SKILL.md) supplies shared language, task examples and service surveys for designing an agent-driven factory alongside a grilling session. Neither experimental skill is shipped in the plugin.
- **A vocabulary layer underneath**, the three references the other skills pull in when the words rather than the process are the problem.

## Choosing between the two flows

`ask-matt` chooses between this repo's flow and pstack, while [poteto-help](https://github.com/seefs001/skills/blob/main/vendor/pstack/skills/poteto-help/SKILL.md) keeps the detailed pstack map. There is one place to ask without copying the whole pstack catalogue into the router.

| What you want next | Route |
| --- | --- |
| Clarify an idea, preserve domain decisions, or work through a spec and issues | The main flow above |
| Give a concrete task to a playbook that selects its own steps and verification | [poteto-mode](https://github.com/seefs001/skills/blob/main/vendor/pstack/skills/poteto-mode/SKILL.md) |
| Understand an existing change or subsystem | `pstack-teach`, rather than the multi-session learning workspace that `teach` creates |
| Pin down a lifecycle or check event interleavings | `state-modeling` for an ordinary lifecycle; when concurrent, retried, or late events decide correctness, run pstack's `statechart` explicitly to model-check it |
| Check standards and spec coverage | `code-review`; use pstack's `interrogate` for demonstrated failures, or `blast-radius` for consequences outside the diff |

The router keeps the flow you already chose unless the requested deliverable calls for a different one. A settled spec can feed pstack, but `implement` and `poteto-mode` are alternative drivers, not two required phases of the same build.

pstack recommendations use the local names `pstack-tdd` and `pstack-teach`, typed as `/<name>` in DeepSeek Harness and `/skill:<name>` in Pi. Each harness has an adapter that defines its limits: the [DeepSeek Harness adapter](https://github.com/seefs001/skills/blob/main/vendor/pstack/docs/harness/dsh.md) and the [Pi adapter](https://github.com/seefs001/skills/blob/main/vendor/pstack/docs/harness/pi.md). In both, [subagents](https://www.aihero.dev/ai-coding-dictionary/subagent) need an explicit delegation request and Cursor-only steps may be skipped. DeepSeek Harness can route each subagent to its own [model](https://www.aihero.dev/ai-coding-dictionary/model); Pi runs everything on the session's model. Choosing pstack does not grant permission to commit, publish or add tests.

## The phase boundary

The skill's other key idea is the **phase boundary**. A phase is a chunk of work inside a session (the [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling), the implementation, the QA), and the boundary between two of them is the only place the question "what do I do with this context?" belongs. Mid-phase there is nothing to decide: continue, or split what is left into subagents.

| Option | Take it when |
| --- | --- |
| **Continue** | The next phase wants this one verbatim, or you have [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone) left. It is the only move that keeps the session as a [primary source](https://www.aihero.dev/ai-coding-dictionary/primary-source), so rule it out first |
| **`/clear`** | Everything behind you is disposable. The cheapest option, and you cannot undo it if you were wrong |
| **[handoff](https://aihero.dev/skills-handoff)** | Something has to travel: a new [harness](https://www.aihero.dev/ai-coding-dictionary/harness), a new directory, a colleague, a side task forked mid-phase |
| **Subagent** | The task is scoped tightly enough to run with you [away from the keyboard](https://www.aihero.dev/ai-coding-dictionary/afk) |
| **`/compact`** | None of the above. It is the default, and the tree often ends here |

People often get two of these wrong, which is why the router gives the order and not only the list. `/handoff` looks like the general way to move between context windows, but it is not. All it gives you is portability. `/compact` is the last option in the tree, not the first, because each of the four options above it is cheaper or more precise.

## Common questions

**Isn't there just a list of the skills in the right order?**

People keep asking for one in the README. This skill is that list. A static table would say `wayfinder → to-spec → to-tickets → implement → code-review → retro` and be wrong for most situations. The important parts are the branches: is there a codebase, does the build span sessions, can talking settle this question. The cost is that the router is maintained by hand, so it lags behind the repo. `/grilling` shipped long before the router named it.

**It told me half the skills aren't installed.**

User-invoked skills can be installed without appearing in the skill list injected into the agent's context. In one reported session, the router treated that list as exhaustive, declared the whole spec-and-tickets flow absent and rerouted to bare `/grilling` and `/tdd`. For promoted skills, check the installed plugin and `.claude-plugin/plugin.json`. For locally linked pstack skills, check the installed skill directories and the vendored tree instead; the promoted manifest does not list them. The pstack branch tells the agent to check those locations before reporting a missing skill.

**It described a skill's behaviour, and the skill doesn't do that.**

This is also a real bug, and also not fixed. The router answers from its own one-line summary of each skill rather than from the skill. One detailed report tracked three instances in a single session, including a recommendation to skip [to-spec](https://aihero.dev/skills-to-spec) based only on the summary "turn the thread into a spec". The router never opened `to-spec/SKILL.md`. In every case it verified only after the user pushed back, and never on its own initiative. Skipping `to-spec` there cost a real seam check, and the tickets that came out undercounted the work. When the router states something about another skill that you will act on, ask it to open that `SKILL.md` first. The same applies to questions the map does not cover at all, such as whether to use [plan mode](https://www.aihero.dev/ai-coding-dictionary/agent-mode): that answer is the model's inference, not something written down here.

**Why is it prose instead of a numbered checklist?**

It is a fair complaint. An open issue argues that most of the routing is deterministic and that the narrative makes it hard to scan. Nothing stops you asking for the compressed form: "just give me the sequence" gets you the sequence. The prose carries the conditional part: the branches, where a human decision is expected, and where to clear or compact between steps. A flat checklist drops exactly that.

**Can it route over every skill I install?**

No. Three separate proposals have asked for a router that reads your local `skills/` directory and recommends from whatever is installed. `ask-matt` is a map maintained by hand. This fork explicitly includes personal entries such as `telegram-message` and a pstack branch that consults pstack's own map. Other installed skill collections remain outside its scope.

**It told me to edit a SKILL.md.**

That advice is often correct, but the edit rarely lasts. Someone asked it how to make [implement](https://aihero.dev/skills-implement) close tickets, was told to add a line to the skill, and saw the problem at once. `npx skills update` overwrites the file, and the plugin install is read-only. Put standing behaviour in your own `CLAUDE.md` or `AGENTS.md`, or say it in the invocation. Changes you make in the prompt survive updates. People point the flow at Linear instead of GitHub this way, or ask it which open tickets could run in parallel.

**It named a skill I don't have, or missed one I do.**

Check the changelog for a rename before assuming it is gone. `writing-great-skills` became [writing-for-agents](https://aihero.dev/skills-writing-for-agents) with no alias, `to-prd` became [to-spec](https://aihero.dev/skills-to-spec), and `pathfinder` became [wayfinder](https://aihero.dev/skills-wayfinder). Four skills were retired outright into the skills that absorbed them: `ubiquitous-language`, `design-an-interface`, `qa` and `request-refactor-plan`. If it misses a skill you have, that is the router's own lag, described above.

## It's working if

- It ends by naming what to type and stops there, instead of starting the work itself.
- The route it gives back mentions where to clear or compact context and where you are expected to review, not just a list of skill names.
- Where two skills are close, it says which one and why the other is wrong for you, including `teach` versus `pstack-teach` and `tdd` versus `pstack-tdd`.
- A pstack recommendation distinguishes what runs in your harness from upstream features it cannot provide.
- Any claim it makes about another skill's behaviour shows up in the trace as it reading that skill's `SKILL.md`.
- You recognise your own situation in what it hands back, rather than the nearest generic scenario.

## Where it fits

`ask-matt` is a **standalone router** that sits over the whole set. It is never a step in a chain. It points into every chain, and the other docs pages link back to it so none of them has to redraw the graph. From here you most often land on [grill-with-docs](https://aihero.dev/skills-grill-with-docs), the head of the main flow, or [triage](https://aihero.dev/skills-triage), the on-ramp for work that arrived rather than work you started.

It is a [secondary source](https://www.aihero.dev/ai-coding-dictionary/secondary-source) over the skills it describes. Where the router and a `SKILL.md` disagree, the `SKILL.md` is right.
