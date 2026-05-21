#!/usr/bin/env python3
"""Normalize Claude's settings.json.tmpl to Claude's canonical format.

Claude Code rewrites ~/.claude/settings.json with alphabetized keys, 2-space
indent, inline empty containers, and ensure_ascii=False. This script enforces
the same shape on the chezmoi source template, so `chezmoi diff` only ever
shows real content changes — not reorderings or whitespace noise.

chezmoi template tokens (`{{ ... }}` blocks) are preserved verbatim, including
the common case of unescaped double quotes inside, e.g.
`"command": "{{ lookPath "node" }}"`.

Exit codes follow the pre-commit convention: 0 if nothing changed, 1 if a
file was rewritten in place.
"""

from __future__ import annotations

import json
import re
import sys
import uuid
from pathlib import Path

# Non-greedy across newlines: each `{{...}}` token, regardless of leading `-`
# or trailing `-`, matches up to the first `}}`. Claude templates do not use
# nested `{{` constructs.
TOKEN_RE = re.compile(r"\{\{.*?\}\}", re.DOTALL)


def _sentinel() -> str:
    # UUID-random prefix makes accidental collision with file content
    # impossible in practice.
    return f"__TPLT_{uuid.uuid4().hex}__"


def format_template(src: str) -> str:
    """Return the canonical form of a Claude template string."""
    tokens: dict[str, str] = {}

    def replace(match: re.Match[str]) -> str:
        s = _sentinel()
        tokens[s] = match.group(0)
        return s

    sanitized = TOKEN_RE.sub(replace, src)
    data = json.loads(sanitized)
    output = json.dumps(data, indent=2, sort_keys=True, ensure_ascii=False)
    # Claude's writer escapes < and > inside string values (HTML-safe JSON).
    # Apply before restoring template tokens — sentinels are pure ASCII and
    # contain neither character.
    output = output.replace("<", "\\u003c").replace(">", "\\u003e")
    for sentinel, original in tokens.items():
        output = output.replace(sentinel, original)
    if not output.endswith("\n"):
        output += "\n"
    return output


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print(
            "usage: format-claude-template.py FILE [FILE...]",
            file=sys.stderr,
        )
        return 2

    rc = 0
    for arg in argv[1:]:
        path = Path(arg)
        src = path.read_text()
        try:
            result = format_template(src)
        except json.JSONDecodeError as e:
            print(f"{path}: JSON parse error after token sanitization: {e}", file=sys.stderr)
            rc = 2
            continue
        if result != src:
            path.write_text(result)
            print(f"reformatted: {path}", file=sys.stderr)
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv))
