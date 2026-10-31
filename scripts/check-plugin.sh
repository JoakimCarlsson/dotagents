#!/usr/bin/env bash
# Fail if .claude-plugin/plugin.json does not list exactly the skills in skills/.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
listed=$(python3 -c 'import json;print("\n".join(sorted(s.removeprefix("./skills/") for s in json.load(open(".claude-plugin/plugin.json"))["skills"])))')
actual=$(ls skills | sort)
if [ "$listed" != "$actual" ]; then
  echo "plugin.json skills list is out of sync with skills/:" >&2
  diff <(echo "$listed") <(echo "$actual") >&2 || true
  exit 1
fi
echo "plugin.json lists all $(echo "$actual" | wc -l) skills"
