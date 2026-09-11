#!/usr/bin/env python3
"""PreToolUse hook: a subagent's working directory is pinned at launch, so EnterWorktree
would prompt the user and, if denied, strand the agent. Block it and say what to do instead."""
import json
import sys

event = json.load(sys.stdin)
if event.get("tool_name") != "EnterWorktree":
    sys.exit(0)
if "/subagents/" not in event.get("transcript_path", ""):
    sys.exit(0)
print(
    "EnterWorktree is blocked for subagents: your working directory is already your worktree "
    f"({event.get('cwd', 'unknown')}). Run every command there with absolute paths or "
    "`git -C <that path>`; do not cd and do not call EnterWorktree again.",
    file=sys.stderr,
)
sys.exit(2)
