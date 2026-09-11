#!/usr/bin/env bash
set -eu
REPO="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

mkdir -p "$CLAUDE_HOME"
for entry in skills agents hooks CLAUDE.md settings.json; do
  target="$CLAUDE_HOME/$entry"
  if [ "$(readlink -f "$target")" = "$REPO/$entry" ]; then
    continue
  fi
  ln -s "$REPO/$entry" "$target"
done
