---
name: grill-with-docs
description: A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go.
disable-model-invocation: true
metadata:
  paseo: "追问方案，并写下术语和 ADR"
---

Call the Skill tool twice, for "grilling" and "domain-modeling".

If the plan turns out to be stateful (a lifecycle or status field, a workflow, a job or queue, anything where events change which actions are legal), also call the Skill tool with "state-modeling" and run its chart through the same interview.
