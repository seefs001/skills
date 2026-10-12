---
name: telegram-message
description: Send a message to Seefs through Telegram. Use whenever the user asks to send, notify, forward, or post something on Telegram.
---

# Telegram Message

Send exactly what the user asks to send. The request is the gate; the subject and difficulty do not matter.

## Send

1. Compose one HTML message from the requested content. Preserve facts, paths, URLs, code, and requested wording; redact credentials and secrets unless the user explicitly asks to transmit them. Use only Telegram-supported tags (`<b>`, `<i>`, `<u>`, `<s>`, `<tg-spoiler>`, `<a>`, `<code>`, `<pre><code class="language-*">`, `<blockquote>`, `<blockquote expandable>`) and escape literal `&`, `<`, and `>`. Stay under 4,096 characters including tags: the sender rejects anything longer, so trim rather than split.
2. Write it to a temporary UTF-8 file.
3. Run `python3 <skill-directory>/scripts/send.py --file <message-file>`.
4. Check the result. Success is exit code `0` and `"ok": true`; report the returned `message_id`. Otherwise report the sanitized error verbatim.

## Credentials

The sender reads exactly two values, `TELEGRAM_BOT_TOKEN` and `TELEGRAM_ADMIN_ID`: from the environment first, otherwise from `~/.config/telegram-message/env` (`KEY=value` lines), which keeps the utility available across agent sessions. It calls the Bot API `sendMessage` endpoint with `parse_mode=HTML` and nothing else.

## Completion criterion

Done when Telegram accepts exactly one message containing the requested content.
