# pstack in Pi

pstack skills use Cursor names. In Pi, read this file once per session, then map each Cursor name in a skill with the tables below. `<pstack>` means the folder that holds `skills/` and `docs/` (in this repo, `vendor/pstack/`). If a Cursor field has no row, drop it and say so. Never pass a field or value the tool schema rejects.

This file is local to this fork. Upstream ships only `claude-code.md`; keep this one in step with it on every sync.

## Tools

| Cursor | Pi |
| --- | --- |
| `Task`, a subagent | Follow the user's subagent rules (`~/AGENTS.md`). Without an explicit request to delegate, do the subagent's work yourself, one brief at a time, and say so in one line. With the request, start each worker through Paseo (the `paseo` skill) with a fresh context window and paste the brief in. |
| `AskQuestion` | Ask in plain text in your reply, with numbered options when the skill gives choices. |
| Open a todolist | Keep the list in your reply and update it at each phase. |
| Run another pstack skill (`/name` or "the **name** skill") | `read` `<pstack>/skills/<name>/SKILL.md` and follow it. When you tell the user to type it, write `/skill:<name>`. |
| `Grep`, `Glob`, `Read`, `Edit`, `Write`, `Bash` | `bash` with `rg` and `find`, `read`, `edit`, `write`, `bash`. Batch independent calls with `codemode`. |

## Subagent fields

These apply only when a worker runs through Paseo. When you do the work yourself, drop them all.

| Cursor | Pi (Paseo worker) |
| --- | --- |
| `subagent_type: generalPurpose`, `poteto-agent`, `comment-sicko` | A Paseo agent. For `poteto-agent` and `comment-sicko`, paste `<pstack>/agents/<name>.md` into the brief. |
| `readonly: true` | The brief says "do not edit files". Check `git status` afterward. |
| `readonly: false` | Omit. |
| `environment: "cloud"` | A Paseo worktree. Name the branch or commit the worker checks out. |
| `environment: "local"`, `run_in_background` | Omit. |
| `cloud_base_branch: <b>` | Tell the worker to check out `<b>` first. |
| `resume` | Start a new agent and paste the earlier result into its brief. |
| `file_attachments` | List the paths in the brief. |

## Models

Pi runs every step on the session model. Drop every `model` slug, effort suffix, and `-fast`. Skip reading `pstack-models.mdc` or `pstack-models.md`. When a skill picks a model for a role, say once that the session model is used.

## setup-pstack

Pi has no per-role model routing, so the model rule has nothing to configure. Skip its detect, defaults, and write steps with one line: `Skipped in Pi: model rule. Pi runs on the session model.` Run any remaining steps as written.

## Paths

| Cursor | Pi |
| --- | --- |
| `.cursor/skills/`, `~/.cursor/skills/` | `.agents/skills/`, `~/.agents/skills/` |
| `~/.cursor/plugins/`, `.cursor-plugin/plugin.json` | This repo's `vendor/pstack/`, linked by `scripts/link-skills.sh`. |
| `.cursor/rules/*.mdc`, always-applied rules | `AGENTS.md` in the project, or `~/AGENTS.md` for global rules. Pi never reads `.mdc` files. |
| `https://github.com/cursor/plugins/blob/main/pstack/<path>` | `<pstack>/<path>` when that file exists. Read the local copy and never fetch it. Give the user the URL when they need a link. |
| Transcripts in `~/.cursor/projects/<slug>/agent-transcripts/` | Pi session files under `~/.pi/agent/sessions/`. Pick the folder for this workspace and read only that one. Prior sessions from other tools are also searchable with `nmem`. |

## Renamed skills

This fork already owns `tdd` and `teach`, so pstack's copies are `pstack-tdd` and `pstack-teach`. When a pstack skill says `/tdd`, `/teach`, or "the **tdd** skill", use the `pstack-` name.

## Cursor-only features

Pi has no Cursor Automations, Bugbot, Cursor cloud agents, or built-in PR tool. When a step needs one, put one line in your reply, `Skipped in Pi: <step>. <reason>.`, then go on to the next step. Do not stop, ask, or retry. When a later step needs what the skipped step made, such as a URL or a key, leave a placeholder and name it in the line.

| Cursor | Pi |
| --- | --- |
| Cursor Automations: routines, `update_state` calls, `api2.cursor.sh/automations` webhooks, routine wakes, `SendToUser` secret requests | Skip with the line. |
| Bugbot | Bugbot comments on a GitHub PR are ordinary review threads, so triage them with `gh`. Skip a step that starts, waits for, or configures Bugbot when the PR has no Bugbot check or comment. |
| Cursor cloud agents | Skip a step that needs the cloud agent itself, such as its dashboard status. |
| A built-in PR tool | Use the forge command the step gives, such as `gh pr create`. That is not a skip, so write no line. Opening a PR still needs the user's confirmation. |
