---
name: paseo-artifacts
description: "Paseo Artifacts collection: register a plan, notes, diagram, prototype, screenshot, report or result file worth keeping. Use when work in a Paseo workspace produces such a file, or the user asks to keep, save or update one."
---

The **Artifacts collection** holds the in-between products of the work in one Paseo workspace. The user opens it from the Artifacts pill above the composer; an artifact opens in a pane beside the conversation (a sheet on phones), and the goal shows every artifact that serves it. The daemon keeps its own copy, so artifacts outlive the workspace, its worktree and daemon restarts.

Register a file when it is a product a person would open again: a plan, research notes, a diagram, a prototype, a screenshot, a verification report, a result file. Leave out logs, tool output, source files you edited, and files you only read.

1. **Write the file** in your workspace. Pick the type by extension: `.md` (put diagrams in a ```mermaid fence; a bare `.mmd`shows as text),`.html` for a prototype, png/jpg/gif/webp/svg for an image. Anything else shows as plain text.
2. **Call the Paseo `register_artifact` tool** with `path`, `title` and `kind` (`plan`, `notes`, `diagram`, `prototype`, `screenshot`, `report`, `result`, `summary`). For text with no file, pass `content` and `fileName` instead. Pass `messageId` only when you know the real id. The daemon fills in your workspace and agent; `goalId`/`taskIds` default to the Desk task linked to your workspace.
3. **After you change the file, register the same `path` again.** The entry keeps its id and its revision goes up; the collection never shows it twice. To update an entry that has no path, pass its `artifactId` (from `list_artifacts` with no arguments). Only your own workspace's entries can be updated; another workspace's entry is read-only to you.
4. **Mention it in one line** in your reply: title and that it is in Artifacts. Do not paste the content again.

If `register_artifact` is not among your tools, the host has no Artifacts or Paseo tools are off for this provider. Say so and give the file path; do not keep a list of your own instead.

To see an artifact's content, call `read_artifact`; works after its workspace is archived. Removing an entry in the app only hides it from the collection; files stay.

Registering records nothing on the Desk and runs nothing. It never completes, starts or claims a task.
