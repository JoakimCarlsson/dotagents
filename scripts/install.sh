#!/bin/sh
# Install the global instructions. Skills come from the plugin marketplace.
#   curl -fsSL https://raw.githubusercontent.com/JoakimCarlsson/dotagents/main/scripts/install.sh | sh
# With no --agent, links the file for every tool whose config dir exists in $HOME.
set -eu

usage() {
  cat <<USAGE
Usage: install.sh [--agent claude|codex|grok]

Symlinks instructions/AGENTS.md to ~/.claude/CLAUDE.md, ~/.codex/AGENTS.md or
~/.grok/AGENTS.md. Without --agent, does it for each of ~/.claude ~/.codex ~/.grok
that exists. Piped from curl, the script keeps a clone in \$DOTAGENTS_DIR
(default ~/.local/share/dotagents); re-running it updates the clone.
USAGE
  exit "${1:-0}"
}

agent=""
while [ $# -gt 0 ]; do
  case $1 in
    --agent) agent=${2:-}; shift 2 ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1" >&2; usage 1 ;;
  esac
done

repo=""
if [ -f "$0" ]; then
  d=$(cd "$(dirname "$0")/.." && pwd)
  [ -f "$d/instructions/AGENTS.md" ] && repo=$d
fi
if [ -z "$repo" ]; then
  repo=${DOTAGENTS_DIR:-$HOME/.local/share/dotagents}
  if [ -d "$repo/.git" ]; then
    git -C "$repo" pull -q --ff-only
  else
    git clone -q "${DOTAGENTS_REPO:-https://github.com/JoakimCarlsson/dotagents.git}" "$repo"
  fi
fi

stamp=$(date +%Y%m%d%H%M%S)
install_agent() {
  case $1 in
    claude) home=$HOME/.claude; file=CLAUDE.md ;;
    codex)  home=$HOME/.codex;  file=AGENTS.md ;;
    grok)   home=$HOME/.grok;   file=AGENTS.md ;;
    *) echo "--agent must be claude, codex or grok" >&2; usage 1 ;;
  esac
  mkdir -p "$home"
  target=$home/$file
  if [ -L "$target" ]; then rm "$target"
  elif [ -e "$target" ]; then mv "$target" "$target.bak-$stamp"; echo "Backed up $target"
  fi
  ln -s "$repo/instructions/AGENTS.md" "$target"
  echo "Linked $target"
}

if [ -n "$agent" ]; then
  install_agent "$agent"
else
  found=0
  for a in claude codex grok; do
    if [ -d "$HOME/.$a" ]; then install_agent "$a"; found=1; fi
  done
  [ "$found" = 1 ] || { echo "No ~/.claude, ~/.codex or ~/.grok found. Pass --agent claude|codex|grok." >&2; exit 1; }
fi
