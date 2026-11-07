## What it does

`state-modeling` pins down a lifecycle before any code touches it: the states and events in scope, which transitions are legal, what an illegal attempt does, and the invariants the change could break.

It keeps the chart as small as the change. A status toggle gets a sentence; a payment flow gets a table. Stateful code waits until that chart can be tested through an agreed public seam. The skill itself writes nothing to disk: the chart lives in the conversation and travels in whatever the driving skill produces, the spec's State Model section, a ticket's transitions, a test matrix. Where a product rule is genuinely missing it asks one question rather than inventing a transition to keep moving.

## When to reach for it

Type `/state-modeling`, or the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) reaches for it automatically when a task fits. In practice it is pulled in far more often than it is typed: the build-chain skills call it themselves the moment the work turns out to be stateful.

Reach for it when the question is *what is allowed to happen next*: a status field, an approval or payment flow, a retry, an async job or queue, a sync, anything where an event changes which actions are legal. Several skills sit close to it:

| The problem | The skill |
| --- | --- |
| Which transitions are legal, and what an illegal one does | `state-modeling` |
| The *words* of the domain: "cancelled" means two things in two files | [domain-modeling](https://aihero.dev/skills-domain-modeling) |
| The *shape* of the module that will hold the machine: where its seam goes, how small its interface can be | [codebase-design](https://aihero.dev/skills-codebase-design) |
| The chart is drawn but nobody can tell whether it feels right | [prototype](https://aihero.dev/skills-prototype), which turns it into a clickable page |
| A transition is misbehaving and you do not know why | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs), which calls this skill once it has a repro |
| Correctness depends on how concurrent, retried, or late events interleave | pstack's optional `statechart`, which model-checks a TLA+ spec (see below) |

## The minimum chart

The leading word is **minimum**. The skill asks for the smallest chart the current phase needs and nothing more: at grilling time that may be a paragraph, at ticket time one transition with its invalid attempts, at TDD time a test matrix. A full transition table for a two-state toggle is ceremony; a bare enum for a payment flow is a bug waiting for a duplicate webhook.

Whatever the size, the chart covers what the change touches:

- **Invalid transitions are explicit.** Each in-scope event has a defined behavior from each state the change touches, even where that behavior is "ignore" or "idempotent no-op". States that behave the same are grouped.
- **Side effects hang off transitions, not states.** A notification fires on `Submitted → Approved`, not "while Approved", and when an external call is involved the chart says whether it fires before or after persistence.
- **Only reachable risks are charted.** Duplicate, late, or concurrent events get an answer when they can reach the behavior the change touches, and stay out of the chart when they cannot.

The reference behind this lives in the skill's [STATE-MODEL.md](https://github.com/seefs001/skills/blob/main/skills/engineering/state-modeling/STATE-MODEL.md), read on demand rather than up front. It offers four formats (a short note, a transition table, a Mermaid diagram, a test matrix) so the chart can be as light as the change allows.

## When a chart is not enough

Some bugs live in the ordering of events: two writers race, a retry lands after a cancel, a callback arrives late. Checking those interleavings by hand is easy to get wrong, because a missed ordering looks just like a safe one. For that case the skill recommends pstack's [statechart](https://github.com/seefs001/skills/blob/main/vendor/pstack/skills/statechart/SKILL.md), which writes a TLA+ model, checks it with TLC, and reports the shortest path to each broken rule. The agent recommends it; you decide whether to run it, because it is user-invoked and its first run may need to install TLC and Java, which still follows your usual approval for installs.

`statechart` is optional. It comes from the locally vendored pstack, not from the Claude Code plugin, so a plugin install does not have it. A clean model check covers only the modeled behavior within its bounds, and a bug path found in a model of code counts only once it is replayed against the real code.

## Common questions

**Should I use pstack's `statechart` instead?**
For most stateful changes, no: a short chart settles them and adds no tooling. `statechart` is the escalation when correctness depends on event interleavings or a state bug will not reproduce. It checks the model and generates its chart, which is more than drawing a diagram, so it costs a TLA+ spec and possibly a tool install.

**Isn't this `domain-modeling`?**
It is the neighbour, not the same thing. `domain-modeling` settles what a word *means* and writes it into `GLOSSARY.md`; this skill settles what is *allowed to happen* to the thing that word names, and writes nothing. The two are usually wanted together on stateful work: you cannot chart transitions between states nobody has agreed the names of, and a state name that survives the chart is glossary material.

**It ran on work that had no state machine in it.**
The trigger is any field or process where an event changes which actions are legal, and that is broader than an explicit `status` column: a retry counter, a "synced" flag, an approval bit. If the chart came out as two states and one transition, that is the skill finding a small machine, not a false positive. If there was nothing to chart, the skill is told to keep the chart minimal, not to manufacture one; say so and move on.

**Where does the chart go afterwards?**
Nowhere of its own. [to-spec](https://aihero.dev/skills-to-spec) carries it as the spec's State Model section, [to-tickets](https://aihero.dev/skills-to-tickets) records the transitions each ticket covers, and [tdd](https://aihero.dev/skills-tdd) turns it into a test matrix at the seam. A decision in it that is hard to reverse can still earn an ADR through `domain-modeling`, on that skill's usual three-part bar.

## It's working if

- Someone can say what a duplicate event does without opening the code, whenever one can reach the behavior the change touches.
- A side effect is always stated with the transition that fires it.
- The chart gets *smaller* as the phase gets earlier: a paragraph at grilling, a table at ticketing, a matrix at TDD.
- Tests drive the machine through its public seam; none reaches in to assert on an internal state variable.
- When a product rule is missing you get one question, not a chart with an invented transition in it.

## Where it fits

`state-modeling` is a **model-invoked reference** and, with [domain-modeling](https://aihero.dev/skills-domain-modeling) and [codebase-design](https://aihero.dev/skills-codebase-design), the vocabulary layer underneath the engineering flow rather than a step in it. [grill-with-docs](https://aihero.dev/skills-grill-with-docs) pulls it into the interview when the plan is stateful, [to-spec](https://aihero.dev/skills-to-spec) summarises the chart into the spec, [to-tickets](https://aihero.dev/skills-to-tickets) slices by transition, [implement](https://aihero.dev/skills-implement) and [tdd](https://aihero.dev/skills-tdd) check for a chart before the first test, and [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) reaches for it once a wrong transition has a repro. When you're unsure which skill or flow fits, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
