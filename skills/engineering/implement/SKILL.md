---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the work is stateful (a lifecycle or status field, a workflow, a job or queue, anything where events change which actions are legal) and the spec or ticket does not already carry its state model, call the Skill tool with "state-modeling" before the first test or line of implementation.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Commit your work to the current branch.
