---
name: telegram-message
description: Send a message to Seefs through Telegram. Use whenever the user asks to send, notify, forward, or post something on Telegram.
---

# Telegram Message

Send exactly what the user asks to send. The request is the gate; the subject and difficulty do not matter.

## Send

1. Compose one concise HTML message from the user's requested content. Preserve facts, paths, URLs, code, and requested wording. Redact credentials and secrets other than content the user explicitly asks to transmit. Use only Telegram-supported tags: `<b>`, `<i>`, `<u>`, `<s>`, `<tg-spoiler>`, `<a>`, `<code>`, `<pre><code class="language-*">`, `<blockquote>`, and `<blockquote expandable>`. Escape literal `&`, `<`, and `>`.
2. Write it to a temporary UTF-8 file.
3. Run:

```bash
python3 <skill-directory>/scripts/send.py --file <message-file>
```

The sender reads exactly two variables:

- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_ADMIN_ID`

Environment values take precedence. Otherwise it reads them from
`~/.config/telegram-message/env`, which keeps the utility available across
agent sessions.

It calls Telegram Bot API `sendMessage` with HTML formatting.

4. Check the result. Success requires exit code `0` and `"ok": true`. Report success with the returned `message_id`; otherwise report the sanitized error.

## Completion criterion

Done when Telegram accepts exactly one message containing the requested content.
