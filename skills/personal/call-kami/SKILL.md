---
name: call-kami
description: Assemble a hard question and its evidence into a comprehensive dossier for manual submission to GPT Pro, or validate the answer brought back.
argument-hint: "[question to package, or an external answer to validate]"
disable-model-invocation: true
---

# Call Kami

You assemble the call; the user sends it. Build a comprehensive, evidence-linked dossier for GPT Pro, save it locally, and hand the user the files and cover prompt. Never send the dossier yourself.

## Choose the direction

Make this the first decision:

- If the invocation contains an answer from GPT Pro or names a file containing one, read [VALIDATING-THE-ANSWER.md](VALIDATING-THE-ANSWER.md) and run the inbound workflow. The word `review` is an optional hint, never a required trigger.
- Otherwise run the outbound workflow below. If the question is missing, derive it from the conversation; ask only when the intended decision cannot be recovered.

## The dossier

A dossier is one self-contained Markdown file containing the question, every load-bearing fact available locally, the unresolved uncertainty, and an exact answer contract. GPT Pro cannot read local paths: paths are provenance labels, never substitutes for the source material they name.

The user's GPT Pro message quota is not the constraint. **Completeness outranks brevity.** Do not shorten evidence merely to save tokens or request a concise answer. Context windows remain finite, so spend them on relevant evidence rather than indiscriminate bulk:

- Include a load-bearing source in full.
- For a source too large to carry whole, include the complete load-bearing region and record exactly what was omitted, where, how much, and why it is unlikely to change the answer.
- Exclude generated or irrelevant material, but make every material exclusion visible under **Omitted deliberately**.
- Never silently truncate.

Store each run in a durable platform data directory, resolving the first available option:

1. `$CALL_KAMI_HOME` when configured;
2. macOS: `$HOME/Library/Application Support/call-kami`;
3. Linux/Unix: `${XDG_DATA_HOME:-$HOME/.local/share}/call-kami`;
4. Windows: `%LOCALAPPDATA%\call-kami`.

Create `<timestamp>-<slug>/DOSSIER.md` and `COVER-PROMPT.md`. On the return trip, keep `ANSWER.md` and `VALIDATION.md` beside them. This directory is durable local state and must never be added to the project repository. Always report the resolved absolute directory (never the variable expression) and tell the user that existing runs can be listed newest-first from the resolved base directory.

## Outbound workflow

### 1. Fix the question

State:

- the decision, diagnosis, design, or report GPT Pro must produce;
- who will act on the answer and what it will unblock;
- the desired outcome and acceptance criteria;
- hard constraints, invariants, and non-goals;
- the target model capabilities that matter, such as file upload, web access, or tool access. Never assume access to the local workspace.

Find facts yourself. If decisions or constraints remain that would materially change the answer, ask them in one numbered batch with your recommended answer for each. Leave genuinely unknowable items as explicit assumptions or open questions.

This step is done when no unanswered user decision silently changes the dossier's conclusion space.

### 2. Inventory the evidence

Enumerate every plausible evidence lane before drafting:

- relevant conversation history and prior decisions;
- specifications, ADRs, issues, PRs, and domain documentation;
- code, tests, schemas, configuration, and dependency versions;
- logs, error output, commands, benchmarks, screenshots, and dates;
- git history, current diff, and repository instructions;
- attempts already made, alternatives already rejected, and why they failed.

Give each candidate source one disposition: **full**, **excerpt**, or **omit with reason**. The inventory is done when every conclusion-bearing source you found has a disposition and no lane is silently ignored.

### 3. Collect before compressing

When evidence spans two or more independent lanes, dispatch collectors in parallel so one context does not serially absorb the whole problem. A single narrow lane or one file does not need a subagent. Give every collector a self-contained question and require exact provenance, raw outputs, gaps, and uncertainty.

Capture the repository/environment anchor before collection and re-check it immediately before assembly:

- collection timestamp;
- repository identity: root path plus a sanitized remote URL when available;
- branch and full commit SHA;
- dirty-file list and relevant diff base;
- relevant runtime, dependency, service, or tool versions.

If the anchor changes during collection, record the drift rather than blending two states.

This step is done when every evidence lane has reported or is explicitly listed as unavailable.

### 4. Build the chain of custody

Assign stable evidence IDs (`E1`, `E2`, …). Every factual statement in the dossier must be one of:

- **Observed**: cites an evidence ID plus a path and line range, exact command and output, screenshot, URL, or dated source.
- **Inferred**: cites the observations it rests on and states the reasoning and confidence.
- **Assumed/unknown**: says what is missing and what would resolve it.

Embed the material GPT Pro needs. Do not write “see `path/to/file`” without including the relevant content as an exhibit. Keep verbatim logs, code, and contract wording when exact text affects the reasoning.

This step is done when every factual claim is traceable to evidence or visibly marked as inference/unknown.

### 5. Redact without destroying structure

Replace secrets, credentials, PII, customer data, and sensitive internal identifiers with stable typed placeholders such as `[REDACTED_DB_PASSWORD_1]`. The same value must map to the same placeholder throughout the run so relationships remain understandable.

Hold the value-to-placeholder mapping only in the active context. **Never write the redaction map to disk.** Files may contain a legend explaining each placeholder's role, but never its original value.

This step is done when the dossier contains no recoverable sensitive value and every placeholder remains meaningful enough for reasoning.

### 6. Assemble the dossier

Read [DOSSIER-TEMPLATE.md](DOSSIER-TEMPLATE.md). Tailor the requested output to the actual decision, but keep its evidence discipline:

- require GPT Pro to cite evidence IDs for every factual claim and recommendation premise;
- require `Unsupported by dossier` whenever the supplied evidence does not support a claim;
- ask for assumptions, confidence, strongest alternative interpretation, tradeoffs, risks, missing evidence, and validation steps;
- request whatever length rigor requires, with no arbitrary word cap.

Write `DOSSIER.md`. Use the cover-prompt variants in [DOSSIER-TEMPLATE.md](DOSSIER-TEMPLATE.md) to write `COVER-PROMPT.md` for either attachment or full-paste transport.

### 7. Cold-read and gate

When an independent subagent is available, give it only `DOSSIER.md` and ask it to state the question, constraints, evidence gaps, inaccessible references, and ambiguous instructions. Otherwise perform the same cold read yourself. Repair every material gap before delivery.

Report this gate item-by-item as **Met** or **Not met**, with evidence. Repair every Not met item before delivery. The outbound run is done only when:

- the question says what the answer will change;
- the final environment anchor is recorded;
- every factual claim has provenance or an inference/unknown label;
- every evidence ID is defined and every exhibit explains why it matters;
- two or more independent evidence lanes were collected in parallel, or the report states that only one lane existed or no subagent was available;
- prior attempts and rejected alternatives are present;
- constraints, invariants, and non-goals are present;
- every material omission or truncation is logged;
- local paths are provenance only and required content is embedded;
- the redaction map exists nowhere on disk;
- the answer contract requires evidence-ID citations and unsupported-claim labels;
- `DOSSIER.md` and `COVER-PROMPT.md` exist and their locations are reported.

Tell the user exactly which file to upload and which cover prompt to paste. End with: “Bring the complete answer back by invoking `/call-kami` with the pasted answer or its file path; `review` is optional.”

This run ends at delivery. Do not solve or implement the underlying task unless the user explicitly asks after the returned answer has been validated.
