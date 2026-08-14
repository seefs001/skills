#!/usr/bin/env python3

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path

CONFIG_PATH = Path.home() / ".config" / "telegram-message" / "env"


def fail(message: str, *, status: int | None = None) -> None:
    response: dict[str, object] = {"ok": False, "error": message}
    if status is not None:
        response["status"] = status
    print(json.dumps(response, ensure_ascii=False))
    raise SystemExit(1)


def redact(message: object, *secrets: str) -> str:
    sanitized = str(message)
    for secret in secrets:
        sanitized = sanitized.replace(secret, "<REDACTED>")
    return sanitized


def read_config() -> dict[str, str]:
    try:
        lines = CONFIG_PATH.read_text(encoding="utf-8").splitlines()
    except FileNotFoundError:
        return {}
    except OSError as error:
        fail(f"could not read {CONFIG_PATH}: {error}")

    config: dict[str, str] = {}
    for line_number, line in enumerate(lines, start=1):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        key, separator, value = line.partition("=")
        if not separator or not key or not value:
            fail(f"invalid configuration at {CONFIG_PATH}:{line_number}")
        config[key] = value
    return config


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Send an HTML message with Telegram Bot API sendMessage."
    )
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--file", type=Path, help="Read the UTF-8 Markdown message from a file.")
    source.add_argument("--stdin", action="store_true", help="Read the Markdown message from stdin.")
    return parser.parse_args()


def read_message(args: argparse.Namespace) -> str:
    try:
        message = (
            args.file.read_text(encoding="utf-8")
            if args.file is not None
            else sys.stdin.read()
        )
    except OSError as error:
        fail(f"could not read message: {error}")

    message = message.strip()
    if not message:
        fail("message is empty")
    if len(message) > 4_096:
        fail("message exceeds Telegram's 4096-character message limit")
    return message


def main() -> None:
    args = parse_args()
    message = read_message(args)
    config = read_config()
    token = os.environ.get("TELEGRAM_BOT_TOKEN") or config.get("TELEGRAM_BOT_TOKEN")
    admin_id = os.environ.get("TELEGRAM_ADMIN_ID") or config.get("TELEGRAM_ADMIN_ID")
    if not token:
        fail(f"TELEGRAM_BOT_TOKEN is not set in the environment or {CONFIG_PATH}")
    if not admin_id:
        fail(f"TELEGRAM_ADMIN_ID is not set in the environment or {CONFIG_PATH}")

    payload = json.dumps(
        {"chat_id": admin_id, "text": message, "parse_mode": "HTML"},
        ensure_ascii=False,
    ).encode("utf-8")
    request = urllib.request.Request(
        f"https://api.telegram.org/bot{token}/sendMessage",
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=20) as response:
            body = response.read()
    except urllib.error.HTTPError as error:
        body = error.read()
        try:
            detail = json.loads(body).get("description", "Telegram rejected the request")
        except (UnicodeDecodeError, json.JSONDecodeError, AttributeError):
            detail = "Telegram rejected the request"
        fail(redact(detail, token, admin_id), status=error.code)
    except urllib.error.URLError as error:
        fail(f"could not reach Telegram: {redact(error.reason, token, admin_id)}")
    except TimeoutError:
        fail("Telegram request timed out")

    try:
        result = json.loads(body)
    except (UnicodeDecodeError, json.JSONDecodeError):
        fail("Telegram returned an invalid JSON response")
    if not isinstance(result, dict):
        fail("Telegram returned an invalid JSON response")
    if result.get("ok") is not True:
        detail = result.get("description", "Telegram rejected the request")
        fail(redact(detail, token, admin_id))

    sent = result.get("result")
    message_id = sent.get("message_id") if isinstance(sent, dict) else None
    print(json.dumps({"ok": True, "message_id": message_id}))


if __name__ == "__main__":
    main()
