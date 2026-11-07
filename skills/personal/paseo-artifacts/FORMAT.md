# Paseo Artifacts format

The daemon owns the collection; agents reach it through `register_artifact`, `list_artifacts` and `read_artifact`. This file is the shape of what you send and the layout of a summary.

## An entry

`register_artifact` returns the entry. Fields you set: `title`, `kind`, and either `path` (inside your workspace) or `content` + `fileName`. Optional: `artifactId` (update), `goalId` / `taskIds` (`G-<n>`, `T-<n>`), `messageId`.

Fields the daemon sets: `id`, `workspaceId`, `sourceAgentId`, `sourcePath`, `media` (from the extension), `revision`, `size`, `createdAt`, `updatedAt`.

| Extension                      | Shows as                                                                                             |
| ------------------------------ | ---------------------------------------------------------------------------------------------------- |
| `.md`, `.markdown`             | Markdown, with mermaid fences drawn as diagrams                                                      |
| `.html`, `.htm`                | HTML in Paseo's sandboxed preview; remote resources are blocked, but a web frame can navigate itself |
| png, jpg, jpeg, gif, webp, svg | Image                                                                                                |
| anything else                  | Plain text                                                                                           |

Re-registering the same `path` in the same workspace, or passing `artifactId` of an entry your workspace owns, updates the entry: same id, revision + 1. `read_artifact` returns `{ artifact, encoding, content }` for any entry on the host.

A summary's scope is its `goalId` + `taskIds`. Each workspace keeps its own summary per scope.

## Summary (kind: summary)

Write a Markdown file, then register it with `kind: "summary"`. Summaries list first in the collection. Task state is quoted "at read time"; the Desk stays the truth.

```markdown
# CSV export for the invoices page

State read 2026-01-15 09:29.

## Ask

- "Let finance download this month's invoices as CSV, same columns as the table." (user)
- "Skip PDF for now." (user)

## Plan

- T-12 Add export endpoint: done, 2/2 criteria met
- T-13 Add Export button: started, 1/2 criteria met
- T-14 PDF export: Fog (parked by the user)

## Decisions

- PDF export moved to Fog. (user)
- Dates use ISO 8601. `[inferred]`, confirm.

## Results

- Endpoint returns the 6 table columns. `[verified]` artifact "T-12 verification"
- Button downloads the file on web. `[reported]` T-13 summary; artifact "Export button screenshot"
- Button on iOS. `[missing]`

## Waiting on you

- Confirm the ISO date format.
- T-13 "works on iOS" has no evidence.

<!-- user-notes -->

The user's own text. Copy it unchanged when you refresh the summary.

<!-- /user-notes -->
```

## Evidence tags

- `[verified]`: run or read in this session, and it showed the result. Name the source.
- `[reported]`: an agent or task summary says so; not checked.
- `[inferred]`: a reading of the conversation or code; the user can edit it.
- `[stale]`: the source is older than the change it is meant to prove.
- `[missing]`: no evidence yet.

A stopped session, an agent saying "done" and the user accepting the work are three different facts. Write only the one you have.
