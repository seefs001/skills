# Dossier template

Use this as the assembly reference for an outbound `call-kami` run. Add sections the question earns, but never remove the snapshot, evidence index, exhibits, omissions, or answer contract.

```markdown
# Dossier: <question>

## How to read this dossier

You are receiving a self-contained evidence package. You have no access to the local workspace. Local paths identify provenance only; the material required to reason is included below.

- **Your available capabilities:** <file upload, web access, tools, or none/unknown>
- **Capability boundary:** <what you may verify externally and which source types you must cite>

Evidence is identified as `E1`, `E2`, and so on. Cite those IDs for every factual claim and every premise supporting a recommendation. If the dossier does not support a claim, label it `Unsupported by dossier` rather than filling the gap from assumption.

Give the problem whatever length rigorous analysis requires. Completeness and explicit tradeoffs matter more than brevity.

## Requested decision

- **Question:** <the exact question to answer>
- **Who will act:** <decision owner>
- **What the answer will unblock:** <action or decision>
- **Desired outcome:** <observable outcome>
- **Acceptance criteria:** <what a useful answer must settle>

## Environment snapshot

- **Collected at:** <timestamp and timezone>
- **Repository/working context:** <name and resolved root path>
- **Repository identity:** <sanitized remote URL, or not applicable>
- **Branch and commit:** <branch and full SHA, or not applicable>
- **Dirty state:** <modified/untracked files or not applicable>
- **Comparison base:** <base ref or not applicable>
- **Relevant versions:** <runtime, dependency, service, tool, platform>
- **Drift during collection:** <none, or exact change>

## Context and current state

<The minimum system/domain map needed to understand the evidence. Describe observed current behavior and desired behavior separately.>

## Constraints and invariants

- <What must remain true>
- <Compatibility, security, privacy, process, operational, time, or product constraints>

## Non-goals

- <What this analysis must not expand into>

## Prior attempts and rejected alternatives

1. **<attempt or option>**: <what happened, evidence ID, and why it failed or was rejected>

## Current hypotheses

1. **<hypothesis>**: <Observed/Inferred/Assumed; supporting and contradicting evidence IDs; confidence>

## Open questions and unknowns

1. **<unknown>**: <why it matters and what evidence would resolve it>

## Evidence index

| ID | Kind | Provenance | Why it matters | Inclusion |
|---|---|---|---|---|
| E1 | Observed | `<path:lines>` / `<command>` / `<URL and date>` | <relevance> | Full / excerpt |

## Exhibits

### E1: <descriptive title>

- **Kind:** Observed / Inferred / Assumed
- **Provenance:** <exact path and line range, command and timestamp, URL and access date, or conversation source>
- **Why included:** <the conclusion this can affect>
- **Completeness:** Full source / excerpt; if excerpt, exact omitted ranges and size

<verbatim source material or clearly marked inference>

## Omitted deliberately

| Source | Omitted material | Amount/range | Reason it should not change the answer |
|---|---|---|---|
| <source> | <material> | <size/range> | <reason> |

Write `None` when no material candidate was omitted.

## Required output

Return an exhaustive, structured analysis containing:

1. A direct answer to the requested decision, followed by the complete reasoning.
2. A claim-to-evidence table. Cite one or more evidence IDs for every factual claim and recommendation premise; use `Unsupported by dossier` where no supplied evidence supports it.
3. Assumptions and confidence levels, including which conclusion changes if an assumption is false.
4. The strongest alternative interpretation or recommendation and the evidence that favors it.
5. Options and tradeoffs, including reversibility, compatibility, operational cost, and failure modes where relevant.
6. Risks, edge cases, concurrency or lifecycle concerns, and second-order effects where relevant.
7. Concrete recommendations in dependency order, clearly separating decisions from implementation suggestions.
8. Validation steps or experiments that would confirm or falsify each load-bearing conclusion.
9. Missing evidence that would materially change the answer, why it matters, and the cheapest way to obtain it.

## Analysis rules

- Treat this dossier as the complete local evidence available for this exchange.
- Distinguish supplied facts, your inferences, and your general knowledge.
- Challenge the stated hypotheses and framing; do not merely optimize the proposed solution.
- Do not invent files, APIs, behavior, benchmarks, constraints, or user requirements.
- Quote exact evidence where wording or values carry the conclusion.
- Preserve disputed points instead of forcing false consensus.
```

## Optional type-specific additions

Add only the sections relevant to the question:

- **Architecture/design:** existing boundaries and contracts, dependency graph, candidate seams, migration sequence, compatibility envelope, rollback strategy, and at least two materially different designs.
- **Debugging/root cause:** exact repro, expected vs actual behavior, frequency/timeline, environment, logs, suspect code paths, tested hypotheses, instrumentation, and regression-test seam.
- **Decision/strategy:** options, decision criteria, stakeholders, risk tolerance, reversibility, costs, deadlines, and conditions that trigger reassessment.
- **UI/design:** user and workflow, screenshots/assets, design system, density and hierarchy, required states, responsive behavior, interaction and motion constraints, and multiple distinct directions.
- **Research/report:** audience and decision, source hierarchy, disputed claims, evidence quality, dates, required report structure, and caveats.

## Cover prompt

Write `COVER-PROMPT.md` as a short instruction, not a second summary. Choose the transport variant the user will actually use.

**Attachment:**

```markdown
I have attached `DOSSIER.md`. Read it completely before answering. It is the authoritative evidence package for this question. Follow its Required output and Analysis rules exactly, cite its evidence IDs for factual claims and recommendation premises, and mark anything unsupported by the dossier. Do not optimize for brevity; use whatever length rigorous analysis requires.
```

**Full paste:**

```markdown
The complete dossier follows this instruction. Read it completely before answering. Treat it as the authoritative evidence package for this question. Follow its Required output and Analysis rules exactly, cite its evidence IDs for factual claims and recommendation premises, and mark anything unsupported by the dossier. Do not optimize for brevity; use whatever length rigorous analysis requires.

<PASTE DOSSIER.md IN FULL>
```
