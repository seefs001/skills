# Routing into pstack

This branch connects the repo's main flow to its locally linked pstack skills. It keeps the cross-family choices here and leaves the full pstack catalogue with [poteto-help](../../../vendor/pstack/skills/poteto-help/SKILL.md). The [poteto-mode skill](../../../vendor/pstack/skills/poteto-mode/SKILL.md) owns playbook selection and steps. Read the source for the selected route before making a recommendation; reading it does not start a workflow.

## Availability and Pi

pstack is vendored under `vendor/pstack/` and linked locally by [link-skills.sh](../../../scripts/link-skills.sh). It is not part of this repo's promoted Claude Code plugin. Resolve these links from this file's real directory; if this installation lacks the vendored tree, check the installed skill directories before calling a skill unavailable. User-invoked skills can be installed without appearing in the model's injected skill list.

In Pi, read the [Pi adapter](../../../vendor/pstack/docs/harness/pi.md) before describing pstack's execution capabilities. Name commands as `/skill:<name>`. In particular:

- The local names are `pstack-tdd` and `pstack-teach`; `tdd` and `teach` still mean this repo's skills.
- The adapter uses the session model, not pstack's per-role model selection. `setup-pstack` is not a prerequisite for choosing a route in Pi.
- Subagents require an explicit request to delegate. Without it, the current agent does the briefs itself; with it, workers run through Paseo with fresh context windows. Do not promise independent multi-model review from a single-agent run.
- Cursor-only steps follow the adapter's skip rules. A route does not authorize Git writes, external writes, global configuration changes, or new tests; apply the user's rules before executing any skill.

## Choose an entry

| The user needs | Recommend |
| --- | --- |
| A concrete task driven by a playbook, with a goal and an observable completion check | [poteto-mode](../../../vendor/pstack/skills/poteto-mode/SKILL.md). It selects the playbook; do not copy its steps into this router or prepend the whole spec-and-issues flow. |
| Help with pstack setup, cost, playbooks, or a run that went wrong | [poteto-help](../../../vendor/pstack/skills/poteto-help/SKILL.md). If the current question is already specific, read its relevant sources and answer now instead of sending the user through another router just to repeat the question. |
| One focused capability rather than a whole execution flow | Use the overlap table below, or consult poteto-help's **Pick a skill** table and read the selected skill. |

The main flow remains the route for an interview, durable domain decisions, and work organised as a spec and issues. When the user explicitly chooses pstack to execute a settled issue or spec, carry that artifact and its acceptance criteria into the prompt. `implement` and `poteto-mode` are alternative drivers for that task, not mandatory consecutive steps.

## Overlap boundaries

These are choices by deliverable, not aliases. Follow each link before describing its behaviour.

| Need | This repo | pstack |
| --- | --- | --- |
| Test-first work | [tdd](../tdd/SKILL.md) is the general red-green discipline at agreed seams. | [pstack-tdd](../../../vendor/pstack/skills/pstack-tdd/SKILL.md) targets a bug with a cheap regression check and falls back to an executable repro when a test is impractical. Neither overrides the user's test policy. |
| Learning | [teach](../../productivity/teach/SKILL.md) maintains a multi-session learning workspace. | [pstack-teach](../../../vendor/pstack/skills/pstack-teach/SKILL.md) explains an existing change or subsystem, combining how it works with why it has that shape. |
| Review | [code-review](../code-review/SKILL.md) checks a diff against standards and its originating spec. | [interrogate](../../../vendor/pstack/skills/interrogate/SKILL.md) tries to break a change or design and keeps only findings demonstrated by a run. [blast-radius](../../../vendor/pstack/skills/blast-radius/SKILL.md) checks consequences outside the diff and proves the facts its safety depends on. |
| Module design | [codebase-design](../codebase-design/SKILL.md) supplies deep-module vocabulary and interface discipline. | [architect](../../../vendor/pstack/skills/architect/SKILL.md) compares design sketches and then implements. Recommend `with checkpoint` when the user wants to approve the design before code changes. |
| Stateful behaviour | [state-modeling](../state-modeling/SKILL.md) defines transitions and invariants within the current flow. | [statechart](../../../vendor/pstack/skills/statechart/SKILL.md) runs a TLA+ model and produces a chart with paths to rule violations. It is not a synonym for drawing a state diagram, and its first run can require tool installation. |
| Reusable evidence from the real app | Existing project verification commands remain the first choice. | [create-verification-skill](../../../vendor/pstack/skills/create-verification-skill/SKILL.md) builds a project-local skill for launching, driving and observing the app when that reusable workflow is missing. |

For the rest of pstack, including `how`, `why`, `recall`, `ketchup`, `arena`, `swarm`, `reflect`, writing skills and `principle-*`, use poteto-help's map rather than maintaining another catalogue here. Playbooks belong to `poteto-mode`; they are not separate slash commands.

## Recommendation

Give one next command, why it fits the requested deliverable, and any permission or runtime limitation that changes what the user will get. When comparing close alternatives, name the decisive difference. Then stop; the user chooses whether to run it.
