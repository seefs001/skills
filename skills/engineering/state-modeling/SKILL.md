---
name: state-modeling
description: Clarify state machines and lifecycle behavior before implementation. Use when work involves statuses, lifecycle states, workflows, approvals, payments, retries, async jobs, queues, syncing, event-driven transitions, duplicate events, invalid transitions, or when another skill needs state-model discipline.
---

# State Modeling

Clarify stateful behavior before implementation.

Use this skill when behavior depends on the current state of a domain object,
workflow, async job, payment, approval, sync process, queue item, retry cycle,
or any process where events change what actions are legal.

Read [STATE-MODEL.md](./STATE-MODEL.md) and produce the smallest state model
artifact needed for the current phase.

Do not implement stateful behavior until the model is clear enough to test
through an agreed public seam.

If the model is hard to reason about on paper, run the `/prototype` skill's
logic branch before continuing.
