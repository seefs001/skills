---
name: state-modeling
description: Statechart modeling before implementation. Use when work involves lifecycle/status fields; workflows, approvals, payments, or retries; async jobs, queues, syncing, or event-driven transitions; duplicate/late/out-of-order/concurrent events; invalid transitions; or when another skill needs state-model discipline.
---

# State Modeling

Build a statechart before changing stateful behavior.

## Process

1. **Name the subject and seam.** Identify the domain object or process whose
   state changes, the existing state sources, and the public seam where behavior
   will be tested or observed. Completion: one state-bearing subject and one
   seam are written down, or the missing decision is asked as a single focused
   question.

2. **Draft the minimum statechart.** Read [STATE-MODEL.md](./STATE-MODEL.md)
   and capture only the states, events, legal transitions, invalid transitions,
   invariants, terminal states, side effects, and race/replay behavior needed
   for the current phase. Completion: every in-scope event has legal behavior
   and invalid behavior; every relevant transition is explicit.

3. **Stress the edges.** Check terminal states, duplicate events, late or
   out-of-order events, concurrent events, and side-effect failure ordering.
   Completion: each edge is handled or explicitly ruled out for this work.

4. **Choose the next move.** If the statechart is clear, implement or test
   through the agreed seam. If product rules are missing, ask one question at a
   time using the `/grilling` discipline. If the chart is still hard to reason
   about, run the `/prototype` skill's logic branch before continuing.

Implement stateful behavior only after the statechart can be tested through the
agreed public seam.
