# Global Agent Instructions

Fork-only global instruction files for Seefs' local agent harnesses. These files live outside `skills/` and are not shipped in the Claude Code plugin.

Files here are named by harness instead of `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md`, so harnesses working inside this repository do not auto-discover them as project rules.

## Symlink map

| Repo file | Global symlink target | Harness |
| :--- | :--- | :--- |
| [dsh.md](./dsh.md) | `~/.dsh/AGENTS.md` | DeepSeek Harness (DSH) |
| [pi-append-system.md](./pi-append-system.md) | `~/.pi/agent/APPEND_SYSTEM.md` | Pi (appended to system prompt, immune to compaction) |
| [claude-code.md](./claude-code.md) | `~/.claude/CLAUDE.md` | Claude Code |
| [codex.md](./codex.md) | `~/.codex/AGENTS.md` | Codex |
| [agy.md](./agy.md) | `~/.gemini/AGENTS.md` | Antigravity (`agy` CLI, App, and IDE) |
| [home.md](./home.md) | `~/AGENTS.md` | Shared home-root policy (referenced by `vendor/pstack`'s Pi adapter and walked up by Pi) |

## Usage

Preview changes without modifying `$HOME`:

```bash
scripts/link-agents.sh --dry-run
```

Create or update symlinks (existing regular files are backed up with a `.bak-YYYYMMDD-HHMMSS` suffix before replacement):

```bash
scripts/link-agents.sh
```

Verify current symlink status:

```bash
scripts/link-agents.sh --check
```

## Notes

- All five harness files stay aligned with the same core `# 全局协作规则` baseline while keeping harness-specific differences for parallel tool calls, subagent delegation, file/search tools, and Nowledge Mem access.
- `home.md` stays compact (`## 验证授权` and the AstrLink block) because Pi walks parent directories up to `~/AGENTS.md` alongside `~/.pi/agent/APPEND_SYSTEM.md`.
- Each file keeps the `<!-- astrlink-debug:begin -->` block with `~` instead of a hardcoded home path. When AstrLink updates or removes its debugging tools, it may rewrite symlink targets with an absolute path; review `git diff global-agents/` after AstrLink changes.
