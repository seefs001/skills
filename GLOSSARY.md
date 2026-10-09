# Matt Pocock Skills

A collection of agent skills (slash commands and behaviors) loaded by Claude Code. Skills are organized into buckets and consumed by per-repo configuration emitted by `/setup-matt-pocock-skills`.

## Language

**Issue tracker**:
The tool that hosts a repo's issues: GitHub Issues, Linear, a local `.scratch/` markdown convention, or similar. Skills like `to-tickets`, `to-spec`, and `triage` read from and write to it.
_Avoid_: backlog manager, backlog backend, issue host

**Issue**:
A single tracked unit of work inside an **Issue tracker**: a bug, task, spec, or slice produced by `to-tickets`.
_Avoid_: ticket (use only when quoting external systems that call them tickets, or for a **Decision ticket**, see below)

**Decision ticket**:
A `wayfinder` unit: a child **Issue** of a `wayfinder:map` holding a *question* whose resolution is a decision, not a slice of a build to execute. The **decision** qualifier is what keeps it distinct from an implementation ticket; `wayfinder` introduces the term, then uses "ticket".

**Triage role**:
A canonical state-machine label applied to an **Issue** during triage (e.g. `needs-triage`, `ready-for-afk`). Each role maps to a real label string in the **Issue tracker** via `docs/agents/triage-labels.md`.

**User-invoked**:
A skill only a person can start, by typing its name. No model and no other skill can start it.
_Avoid_: slash command, manual skill

**Model-invoked**:
A skill the model may start on its own. A person may also start it by typing its name.
_Avoid_: automatic skill, background skill

**User prompt**:
The human-facing sentence of a **user-invoked** skill: the sentence a person fires by typing that skill's name. This is the 用户调用提示词.
_Avoid_: trigger, picker line

**Trigger**:
The model-facing sentence of a **model-invoked** skill. It says when the model should reach for the skill. It is not a **user prompt**.
_Avoid_: user prompt, 用户调用提示词

**Picker line**:
The short Chinese sentence the Paseo skill picker shows for one skill. It restates either that skill's **user prompt** or its **trigger**, and the picker says which.
_Avoid_: description

## Relationships

- An **Issue tracker** holds many **Issues**
- An **Issue** carries one **Triage role** at a time
- A **Decision ticket** is an **Issue** (a child of a `wayfinder:map`)
- A **user-invoked** skill has a **user prompt**
- A **model-invoked** skill has a **trigger**
- A **picker line** restates one of those two sentences, and names which

## Flagged ambiguities

- "backlog" was previously used to mean both the *tool* hosting issues and the *body of work* inside it. Resolved: the tool is the **Issue tracker**; "backlog" is no longer used as a domain term.
- "backlog backend" / "backlog manager". Resolved: collapsed into **Issue tracker**.
- "description" was used for a **user prompt**, a **trigger**, and the **picker line**. Resolved: a **user-invoked** skill's description is a **user prompt**; a **model-invoked** skill's description is a **trigger**; the picker shows a **picker line** marked as one or the other.
