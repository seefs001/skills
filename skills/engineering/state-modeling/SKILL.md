---
name: state-modeling
description: Statechart modeling before implementation. Use when work involves lifecycle/status fields; workflows, approvals, payments, or retries; async jobs, queues, syncing, or event-driven transitions; duplicate/late/out-of-order/concurrent events; invalid transitions; or when another skill needs state-model discipline.
---

# State Modeling

Build a **statechart** before changing stateful behavior: every in-scope event gets a legal transition and an explicit invalid-transition behavior, and only then does implementation start, through the agreed public seam.

This is a discipline run inside whichever skill is driving (grilling, spec, tickets, TDD, diagnosis), not a session of its own. The chart lives in the conversation and travels in the driving skill's artifact: the spec's State Model section, a ticket's transitions, a test matrix. It writes no file of its own.

## Process

1. **Name the subject and seam.** The domain object or process whose state changes, where that state is stored or derived, and the public seam where behavior will be tested or observed. Done when one state-bearing subject and one seam are written down, or the missing decision has been asked as a single focused question.

2. **Draft the minimum statechart.** Read [STATE-MODEL.md](./STATE-MODEL.md) and capture only what the current phase needs: states, events, legal transitions, invalid transitions, invariants, terminal states, side effects, race/replay behavior. Done when every in-scope event has a legal behavior and an invalid behavior from each relevant state.

3. **Stress the edges.** Terminal states, duplicate events, late or out-of-order events, concurrent events, and side effects that succeed or fail out of step with persistence. Done when each edge is handled or explicitly ruled out for this work.

4. **Choose the next move.**
   - Chart clear: implement or test through the agreed seam.
   - Product rules missing: ask the user one question at a time.
   - Chart still hard to reason about: call the Skill tool with "prototype" for a throwaway logic prototype, then return here.

Do not write stateful implementation until the chart can be tested through the agreed public seam.
