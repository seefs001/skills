# Validating the answer

Use this branch when a `call-kami` invocation contains an answer from GPT Pro or names a file containing one. The word `review` is optional. If the answer is missing, ask the user to paste it or provide its path.

## Inputs

Locate the original call directory and read `DOSSIER.md` before judging the answer. Prefer an explicit path from the user, then the path retained in the conversation. Otherwise resolve the configured platform base directory, list runs newest-first, and match both the dossier question and repository identity; ask when more than one run is plausible. Accept the answer as pasted text or a file.

Before writing `ANSWER.md`, scan the answer for sensitive values. Redact them with typed placeholders held only in the active context. If safe redaction would destroy meaning, keep the answer in context and do not write `ANSWER.md`; report this exception. A later session cannot reconstruct the original redaction map and must treat redacted values as unrecoverable.

If the dossier is unavailable, say that provenance and drift cannot be checked. Ask for it rather than pretending the current workspace reconstructs the original evidence package.

## 1. Check drift

First compare the dossier's repository identity—sanitized remote URL and recorded root/worktree—with the current workspace. If they do not identify the same repository, stop the drift comparison and ask the user to switch to or name the correct workspace.

Then compare the current environment with the dossier's snapshot:

- branch and full commit SHA;
- dirty-file set and relevant diff;
- dependency, runtime, service, tool, and platform versions;
- timestamps for mutable external evidence.

Record every material change. A claim supported by the old snapshot but invalidated by a later change is **Stale**, not hallucinated.

## 2. Extract claims completely

Create one row for every falsifiable factual claim and every load-bearing premise behind a recommendation. Preserve the answer's wording and map any cited evidence IDs. Do not silently drop a claim because it is plausible, repetitive, contradicted, or inconvenient.

Keep non-factual judgments separate; assess their tradeoffs only after their premises receive verdicts. Cross-check recommendations against **Prior attempts and rejected alternatives** in the dossier. A repeated rejected option must explain what new evidence changes the earlier result; otherwise flag it as blocked even when its factual premises are Confirmed.

## 3. Verify locally

Use the dossier and safe fresh local checks. Assign exactly one verdict to every extracted row:

- **Confirmed** — the cited exhibit or a fresh check supports the claim.
- **Contradicted** — evidence directly refutes it; cite the refuting evidence.
- **Unsupported** — neither the dossier nor the current environment supports it, including invented files, APIs, flags, benchmarks, or requirements.
- **Unverifiable** — local evidence cannot decide it; name the missing authority or cheapest safe check.
- **Stale** — it matched the recorded snapshot but no longer matches the current environment.

A redacted value cannot be recovered from the on-disk dossier. Ask the user interactively when that value is essential; otherwise mark the dependent claim Unverifiable.

## 4. Write the validation report

Write `VALIDATION.md` beside the dossier with:

```markdown
# GPT Pro answer validation

## Drift since dossier

<snapshot comparison>

## Claim verdicts

| # | Claim or premise | GPT evidence IDs | Local check/evidence | Verdict | Consequence |
|---|---|---|---|---|---|

## Decisions safe to adopt

<Only decisions whose load-bearing premises are Confirmed>

## Rejected or blocked conclusions

<Contradicted, Unsupported, Unverifiable, and Stale items, with reasons>

## Risks and unresolved questions

<remaining uncertainty>

## Cheapest next validations

<commands, tests, experiments, source checks, or user decisions>

## Optional GPT Pro follow-up

<a self-contained follow-up prompt when the answer needs clarification or new evidence>
```

Report the path and summarize the verdict counts to the user.

## Done when

- The extracted-claim row count equals the verdict row count.
- Every row cites the dossier exhibit or fresh local check that decided it, or names the missing authority.
- Invented locators and unsupported premises are explicit, not silently repaired.
- Drift is separated from incorrectness.
- Decisions safe to adopt rely only on Confirmed premises.
- `VALIDATION.md` sits beside the original dossier; `ANSWER.md` does too unless the report records that safe persistence was impossible.

This branch validates and recommends. It does not implement. Continue only when the user explicitly requests implementation after reading the verdicts.
