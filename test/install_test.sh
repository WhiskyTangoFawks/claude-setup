#!/usr/bin/env bash
set -u
REPO="$(cd "$(dirname "$0")/.." && pwd)"
failures=0

fail() { echo "FAIL: $1"; failures=$((failures + 1)); }
pass() { echo "ok:   $1"; }

run_install() { CLAUDE_HOME="$1" "$REPO/install.sh"; }

test_fresh_install_links_every_managed_entry() {
  local home; home="$(mktemp -d)"
  run_install "$home/.claude" >/dev/null 2>&1 || { fail "install exited non-zero on fresh home"; return; }
  for entry in skills agents hooks CLAUDE.md settings.json; do
    if [ "$(readlink -f "$home/.claude/$entry")" != "$(readlink -f "$REPO/$entry")" ]; then
      fail "fresh install: $entry is not a symlink to the repo"; return
    fi
  done
  pass "fresh install links every managed entry"
}

test_second_install_is_a_noop() {
  local home; home="$(mktemp -d)"
  run_install "$home/.claude" >/dev/null 2>&1
  run_install "$home/.claude" >/dev/null 2>&1 || { fail "second install exited non-zero"; return; }
  if [ "$(readlink -f "$home/.claude/skills")" != "$(readlink -f "$REPO/skills")" ]; then
    fail "second install broke the skills link"; return
  fi
  pass "second install is a no-op"
}

test_existing_file_in_the_way_is_left_untouched_and_install_fails() {
  local home; home="$(mktemp -d)"
  mkdir -p "$home/.claude"
  echo "local instructions" > "$home/.claude/CLAUDE.md"
  if run_install "$home/.claude" >/dev/null 2>&1; then
    fail "install exited zero with an unmanaged CLAUDE.md in the way"; return
  fi
  if [ -L "$home/.claude/CLAUDE.md" ] || [ "$(cat "$home/.claude/CLAUDE.md")" != "local instructions" ]; then
    fail "install replaced the unmanaged CLAUDE.md"; return
  fi
  pass "existing file in the way is left untouched and install fails"
}

test_fresh_install_links_every_managed_entry
test_second_install_is_a_noop
test_existing_file_in_the_way_is_left_untouched_and_install_fails

echo
[ "$failures" -eq 0 ] && echo "all passed" || { echo "$failures failed"; exit 1; }
