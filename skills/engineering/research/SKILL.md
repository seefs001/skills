---
name: research
description: Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent.
---

Spin up a **background agent** to do the research, so you keep working while it reads. Start it with a fresh context window. Use the harness's background mode so the harness tells you when the agent finishes; do not poll it in a loop.

Its job:

1. Investigate the question against **primary sources** (official docs, source code, specs, first-party APIs), not a secondary write-up of them. Follow every claim back to the source that owns it.
2. Write the findings to a single Markdown file, citing each claim's source.
3. Save it where the repo already keeps such notes; match the existing convention, and if there is none, put it somewhere sensible and say where.

Tell the agent it is already the subagent: it does the reading itself and must not invoke `/research` or spawn another agent.

## While it runs

As soon as the agent starts, tell the user three things in one short message: the question as you scoped it, where the file will land, and that they can check on it, add to it, redirect it, or cancel it. Then go back to the conversation.

Handle each request by kind:

- **Check on it**: report what the agent has produced so far, from its output or the partial file. Do not interrupt it to ask.
- **Add to it** (the scope stays, the user wants one more thing): queue the addition. Send it to the agent after its current step if the harness supports follow-up messages, or run it as a second pass on the same file when the first pass finishes.
- **Redirect it** (the scope changes, for example from "all Chinese sources" to "only Chinese posts on X"): stop the agent now. Keep any partial file, and start a new agent with the new scope. Tell the new agent which partial findings still hold, so it does not re-read them.
- **Cancel it**: stop the agent, keep the partial file, and tell the user its path.

When you are unsure whether a request adds or redirects, ask: would the work already done still answer the new request? If yes, add. If no, redirect.

## When it finishes

When the harness tells you the agent is done, report back without waiting to be asked: the file path, the answer in two or three sentences, and any question the sources could not settle. If the agent failed or stopped early, say so and say what the partial file covers.

The agent never needs approval, because it only reads sources and writes one notes file. If the question turns out to need an action the user must approve (a purchase, a sign-up, a message to someone), the agent stops and reports it; you ask the user.
