---
name: state-modeling
description: "Statechart modeling before adding or changing a lifecycle, workflow, or event-driven transition. Use when designing new states, events, or transitions, or when another skill asks for state-model discipline. Skip for fixes inside an existing transition."
---

# State Modeling

Build the **minimum statechart** the change needs before changing stateful behavior: the subject, its public seam, the in-scope states and events, what each legal and invalid transition does, and the invariants that must hold. Size it to the change: a two-state toggle gets a sentence, a payment flow gets a table.

This is a discipline run inside whichever skill is driving (grilling, spec, tickets, TDD, diagnosis), not a session of its own. The chart lives in the conversation and travels in the driving skill's artifact: the spec's State Model section, a ticket's transitions, a test matrix. It writes no file of its own.

## Process

1. **Name the subject and seam.** The domain object or process whose state changes, where that state is stored or derived, and the public seam where behavior will be tested or observed. Done when one state-bearing subject and one seam are written down, or the missing decision has been asked as a single focused question.
2. **Draft the minimum statechart.** Read [STATE-MODEL.md](./STATE-MODEL.md) and pick the lightest format that answers the change. Done when every in-scope event has a legal behavior, or a stated invalid behavior, from each state this change touches, and the invariants it could break are written down.
3. **Check the risks this change touches.** Only the edges the change can actually reach: a terminal state it adds, a retry or callback that reaches the changed behavior, a side effect it moves relative to persistence. Done when each such edge is handled or ruled out; edges the change cannot reach stay out of the chart.
4. **Choose the next move.**
   - Chart clear: implement or test through the agreed seam.
   - Product rules missing: ask the user one question at a time. Take rules from the conversation, code, spec, issue, or ADRs; never invent a transition to keep moving.
   - Chart still hard to reason about: call the Skill tool with "prototype" for a throwaway logic prototype, then return here.
   - Interleavings decide correctness (concurrent writers, retries, late or out-of-order callbacks) or a state bug resists reproduction: recommend the model check below.

Do not write stateful implementation until the chart can be tested through the agreed public seam.

## Model check

pstack's `statechart` writes a TLA+ model, checks it with TLC, and reports the shortest path to each state that breaks a rule. It checks the model and generates its chart from it, so it is more than drawing a diagram, and it earns its cost only when a hand-written chart cannot settle whether some ordering of events breaks an invariant.

It is user-invoked and optional: it ships with pstack, not with this skill, and its first run may need to install TLC and Java over the network when they are missing. Choosing it does not authorize that install: tool installs still follow the user's permission and approval rules. So recommend it and let the user choose: tell the user to run `/statechart` (`/skill:statechart` in Pi; DeepSeek Harness takes `/statechart` as written), naming the invariants and event orderings worth checking. If the skill is not installed, say so and continue with the hand-written chart.

When the user runs it, read its report with two limits in mind:

- A clean run covers only the modeled behavior within its bounds. It is not proof that the code is correct.
- A model of code is trusted only after each reported bug path is replayed against the real code, as that skill's hand-off requires. Replay with existing checks or an executable repro; adding new tests still follows the user's test policy.
