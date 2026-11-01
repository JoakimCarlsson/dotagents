#!/usr/bin/env bash
# SessionStart hook for Claude Code: injects the AGENTS.md files between the session's
# working directory and the repository root into context. Codex sets PLUGIN_ROOT and
# already loads AGENTS.md itself, so the hook does nothing there.
set -uo pipefail

MAX_BYTES=65536

# Print the physical working directory the session started in.
# Arguments: the JSON hook input on stdin.
# Output: the resolved directory, or nothing when it does not exist.
# Exit status: 0 when a directory was printed, 1 otherwise.
session_dir() {
  local input cwd
  input=$(cat)
  cwd=$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
  [ -z "$cwd" ] && cwd=$PWD
  (cd "$cwd" 2>/dev/null && pwd -P)
}

# Print the directory the upward walk must not leave.
# Arguments: $1 the physical session directory.
# Output: the git toplevel when it contains the session directory, else the session directory.
stop_dir() {
  local dir=$1 top
  top=$(cd "$dir" && git rev-parse --show-toplevel 2>/dev/null)
  top=$(cd "$top" 2>/dev/null && pwd -P)
  case "$dir/" in
    "$top"/*) printf '%s\n' "$top" ;;
    *) printf '%s\n' "$dir" ;;
  esac
}

# Test whether a file may be injected.
# Arguments: $1 the candidate file, $2 the directory the file must stay inside.
# Exit status: 0 when it is a regular file whose resolved path is inside that directory.
safe_file() {
  local real
  [ -f "$1" ] || return 1
  real=$(realpath -- "$1" 2>/dev/null) || return 1
  case "$real" in
    "$2"/*) return 0 ;;
    *) return 1 ;;
  esac
}

# Print the AGENTS.md files from the session directory up to the stop directory.
# Arguments: $1 the session directory, $2 the stop directory.
# Output: one path per line, nearest directory first.
collect_files() {
  local dir=$1 stop=$2 name parent
  while :; do
    for name in "$dir/AGENTS.md" "$dir/.claude/AGENTS.md"; do
      safe_file "$name" "$stop" && printf '%s\n' "$name"
    done
    [ "$dir" = "$stop" ] && break
    parent=$(dirname "$dir")
    [ "$parent" = "$dir" ] && break
    dir=$parent
  done
}

# Print one file as project instructions, capped at MAX_BYTES.
# Arguments: $1 the file.
emit_file() {
  printf 'Contents of %s (project instructions, checked into the codebase):\n\n' "$1"
  head -c "$MAX_BYTES" "$1"
  printf '\n\n'
}

# Run the hook.
# Arguments: the JSON hook input on stdin.
# Output: the instructions to add to the session context.
main() {
  local cwd stop f
  [ -n "${PLUGIN_ROOT:-}" ] && exit 0
  cwd=$(session_dir) || exit 0
  stop=$(stop_dir "$cwd")
  while IFS= read -r f; do
    emit_file "$f"
  done < <(collect_files "$cwd" "$stop")
}

main
