---
name: paseo-artifact
description: "Write or refresh the summary Artifact for a Paseo goal or workspace: ask, plan, decisions, results and evidence, from the conversation, the Desk and the Artifacts collection."
disable-model-invocation: true
---

The **summary Artifact** is one entry of `kind: summary` in the Artifacts collection. It gathers what was asked, what was decided, what came out and what proves it. The Desk (Goals, Tasks, Decisions) stays the only record of state; the summary quotes it "at read time".

Run this only because the user asked for it now. It writes one file and registers it. It does not create, claim, start, complete or edit Goals and Tasks, and it does not merge, deploy or publish.

The layout and evidence tags are in the paseo-artifacts skill's `FORMAT.md`. Load it first: call the Skill tool with "paseo-artifacts" where the harness has one; otherwise read that skill's `SKILL.md` and `FORMAT.md` from wherever skills are installed. Loading it is for the format; register nothing until step 6.

1. **Fix the scope.** Use what the user named (`G-<n>`, `T-<n>`, or "this workspace"). With nothing named: the goal this agent owns, else the task linked to this workspace, else this workspace. The scope is the pair `goalId` + `taskIds` you will register with. Done when you can state it in one line.
2. **Read current state.** Call `list_goals` and `list_board_tasks` for the scope. Record each task's state, stage, criteria met and summary, and the time you read them.
3. **Find the evidence.** Call `list_artifacts` (with `goalId` for a goal scope). A listing is only a pointer: call `read_artifact` on every entry you cite and judge it from its content. An entry older than the change it proves is `[stale]`. Summaries from other workspaces are evidence too: read them and cite them by title.
4. **Find this workspace's summary for this scope.** Call `list_artifacts` with no arguments (your workspace only) and pick the `kind: "summary"` entry whose `goalId` and resolved task IDs match your scope; compare task IDs as a set. If there is one, `read_artifact` it and copy its `<!-- user-notes -->` ... `<!-- /user-notes -->` block exactly. A summary from another workspace or another scope is never the one you update.
5. **Write the summary** as a Markdown file in your workspace in the FORMAT.md layout, with the user-notes block from step 4 (an empty one if there was none). Give each scope a separate file path: registering an existing path would replace that entry even without `artifactId`. Quote the user's own words for the Ask. Every result line carries exactly one evidence tag and names its source artifact or record. Draft missing details from the conversation; reserve "Waiting on you" for material scope, direction or authorization questions instead of asking the user to fill in Desk records.
6. **Register it** with `register_artifact`, `kind: "summary"`, and the scope's `goalId` and `taskIds`. Pass the `artifactId` from step 4 only when step 4 found one; otherwise this creates a new summary owned by your workspace.
7. **Reply** in a few lines: what changed since the last revision and the "Waiting on you" items. The user opens it from the Artifacts pill or the goal.

If `register_artifact`, `list_artifacts` or `read_artifact` is missing, say which tool is missing, give the file path, and stop there.
