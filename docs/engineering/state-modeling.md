Quickstart:

```bash
npx skills add mattpocock/skills --skill=state-modeling
```

```bash
npx skills update state-modeling
```

[Source](https://github.com/mattpocock/skills/tree/main/skills/engineering/state-modeling)

## What it does

`state-modeling` clarifies lifecycle behavior before implementation: statuses,
workflows, approvals, payments, retries, async jobs, queues, syncing, and
event-driven transitions.

It keeps the state-machine rules in one reference so tests and code are written
against explicit behavior instead of guesses. Other skills call
`/state-modeling`; they do not copy its checklist.

## When to reach for it

Type `/state-modeling`, or the agent reaches for it automatically when a task
fits.

Reach for it when the change depends on what actions are legal in each state:
approvals, payments, retries, async jobs, queues, syncing, lifecycle statuses,
duplicate events, late events, or event-driven workflows.

## The model

The skill pins down states, events, legal and illegal transitions, invariants,
terminal states, side effects, and race or replay behavior.

The reusable checklist lives in the skill's
[STATE-MODEL.md](https://github.com/mattpocock/skills/tree/main/skills/engineering/state-modeling/STATE-MODEL.md)
reference. The point is to make the smallest useful state model for the phase
you are in, then test it through an agreed public seam.

## It's working if

- Invalid transitions are explicit instead of assumed.
- Side effects are attached to transitions, not floating around states.
- Duplicate, late, out-of-order, or concurrent events are handled or ruled out.
- The test seam is agreed before implementation starts.

## Where it fits

`state-modeling` is a model-invoked discipline underneath the main engineering
flow. [grill-with-docs](https://aihero.dev/skills-grill-with-docs) uses it when
the plan contains stateful behavior, [to-spec](https://aihero.dev/skills-to-spec)
summarizes the model into the spec, [to-tickets](https://aihero.dev/skills-to-tickets)
records which transitions a vertical slice covers, [tdd](https://aihero.dev/skills-tdd)
uses it before writing tests for stateful behavior, [implement](https://aihero.dev/skills-implement)
runs it before code for stateful work, and [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs)
uses it after the feedback loop exists when a bug involves a wrong transition.

When you're unsure which skill or flow fits, [ask-matt](https://aihero.dev/skills-ask-matt)
routes you.
