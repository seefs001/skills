## What it does

`state-modeling` pins down a lifecycle before any code touches it: the states, the events and commands that move between them, which transitions are legal, what every illegal attempt does, the invariants, the terminal states, the side effects, and what happens when events arrive twice, late, out of order, or at the same time.

It refuses to let stateful code start until that chart exists and can be tested through an agreed public seam. The skill itself writes nothing to disk: the chart lives in the conversation and travels in whatever the driving skill produces, the spec's State Model section, a ticket's transitions, a test matrix. Where a product rule is genuinely missing it asks one question rather than inventing a transition to keep moving.

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

## The minimum chart

The leading word is **minimum**. The skill asks for the smallest chart the current phase needs and nothing more: at grilling time that may be a paragraph, at ticket time one transition with its invalid attempts, at TDD time a test matrix. A full transition table for a two-state toggle is ceremony; a bare enum for a payment flow is a bug waiting for a duplicate webhook.

Whatever the size, four things are never skipped:

- **Invalid transitions are explicit.** Every event has a defined behavior from every relevant state, even where that behavior is "ignore" or "idempotent no-op". Grouping states that behave the same is fine; leaving them implicit is not.
- **Side effects hang off transitions, not states.** A notification fires on `Submitted → Approved`, not "while Approved", and the chart says whether it fires before or after persistence and what happens if either half fails.
- **Terminal states handle replay.** A cancelled job that receives a late completion event has a defined answer.
- **Races are decided, not discovered.** Duplicate, late, out-of-order, and concurrent events are each handled or explicitly ruled out, with the idempotency key, ordering source, or lock named where one is needed.

The checklist behind this lives in the skill's [STATE-MODEL.md](https://github.com/seefs001/skills/blob/main/skills/engineering/state-modeling/STATE-MODEL.md), read on demand rather than up front. It offers four formats (a state capsule, a transition table, a Mermaid diagram, a test matrix) so the chart can be as light as the phase allows.

## Common questions

**Isn't this `domain-modeling`?**
It is the neighbour, not the same thing. `domain-modeling` settles what a word *means* and writes it into `CONTEXT.md`; this skill settles what is *allowed to happen* to the thing that word names, and writes nothing. The two are usually wanted together on stateful work: you cannot chart transitions between states nobody has agreed the names of, and a state name that survives the chart is glossary material.

**It ran on work that had no state machine in it.**
The trigger is any field or process where an event changes which actions are legal, and that is broader than an explicit `status` column: a retry counter, a "synced" flag, an approval bit. If the chart came out as two states and one transition, that is the skill finding a small machine, not a false positive. If there was nothing to chart, the skill is told to keep the chart minimal, not to manufacture one; say so and move on.

**Where does the chart go afterwards?**
Nowhere of its own. [to-spec](https://aihero.dev/skills-to-spec) carries it as the spec's State Model section, [to-tickets](https://aihero.dev/skills-to-tickets) records the transitions each ticket covers, and [tdd](https://aihero.dev/skills-tdd) turns it into a test matrix at the seam. A decision in it that is hard to reverse can still earn an ADR through `domain-modeling`, on that skill's usual three-part bar.

## It's working if

- Someone can say what a duplicate event does in every terminal state without opening the code.
- A side effect is always stated with the transition that fires it, and with what happens if persistence fails.
- The chart gets *smaller* as the phase gets earlier: a paragraph at grilling, a table at ticketing, a matrix at TDD.
- Tests drive the machine through its public seam; none reaches in to assert on an internal state variable.
- When a product rule is missing you get one question, not a chart with an invented transition in it.

## Where it fits

`state-modeling` is a **model-invoked reference** and, with [domain-modeling](https://aihero.dev/skills-domain-modeling) and [codebase-design](https://aihero.dev/skills-codebase-design), the vocabulary layer underneath the engineering flow rather than a step in it. [grill-with-docs](https://aihero.dev/skills-grill-with-docs) pulls it into the interview when the plan is stateful, [to-spec](https://aihero.dev/skills-to-spec) summarises the chart into the spec, [to-tickets](https://aihero.dev/skills-to-tickets) slices by transition, [implement](https://aihero.dev/skills-implement) and [tdd](https://aihero.dev/skills-tdd) check for a chart before the first test, and [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) reaches for it once a wrong transition has a repro. When you're unsure which skill or flow fits, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
