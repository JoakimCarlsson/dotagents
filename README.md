# dotagents

My skills for coding agents: tickets, implementing, reviewing, committing and pull requests, plus design interviews, architecture review, research and retros. Works with Claude Code, Codex, Copilot and others.

## Installation

A plugin updates itself. `npx skills` copies editable files into your project, and you update them by hand. Pick one per agent, because installing both gives you every skill twice.

### Claude Code

```sh
claude plugin marketplace add JoakimCarlsson/dotagents
claude plugin install dotagents@dotagents
```

Skills are namespaced by the plugin, for example `/dotagents:commit`.

### Codex

```sh
codex plugin marketplace add JoakimCarlsson/dotagents
codex plugin add dotagents@dotagents
```

Codex reads the same `.claude-plugin/` manifests.

### GitHub Copilot (CLI and VS Code)

```sh
copilot plugin marketplace add JoakimCarlsson/dotagents
copilot plugin install dotagents@dotagents
```

To keep it updated, add this once to `~/.copilot/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "dotagents": { "source": { "source": "github", "repo": "JoakimCarlsson/dotagents" }, "autoUpdate": true }
  }
}
```

In VS Code, run `Chat: Install Plugin From Source` and enter `https://github.com/JoakimCarlsson/dotagents`.

### Gemini CLI (manual updates)

```sh
gemini skills install https://github.com/JoakimCarlsson/dotagents.git --path skills
```

Re-run it to update.

### Any other agent, or editable files (manual updates)

```sh
npx skills@latest add JoakimCarlsson/dotagents -a <agent>  # cursor, opencode, windsurf, amp; omit -a to choose
```

Update with `npx skills@latest update`, and re-run `add` to pick up new skills.

## Global instructions

Plugins can't carry instructions, so `instructions/AGENTS.md` is installed separately. The script symlinks it to `~/.claude/CLAUDE.md` (Claude Code reads that name, not `AGENTS.md`), `~/.codex/AGENTS.md` and `~/.grok/AGENTS.md`, for each of those tools whose config folder exists. An existing file is backed up first.

```sh
git clone https://github.com/JoakimCarlsson/dotagents.git && dotagents/scripts/install.sh
# or: curl -fsSL https://raw.githubusercontent.com/JoakimCarlsson/dotagents/main/scripts/install.sh | sh
```

Use `--agent claude|codex|grok` for one tool. `git pull` updates the linked file.

## Skills

| Skill | What it does |
| --- | --- |
| `code-review` | Review a change against the ticket, the repo rules and for bugs, and report a verdict without editing code |
| `commit` | Commit the session's changes on the current branch, without pushing |
| `write-ticket` | Create and edit tickets and labels so an agent or a human can implement them |
| `implement` | Create a branch for a ticket and implement it |
| `pr` | Open a pull request to the default branch |
| `plan-interview` | Interview you about a plan until it is settled, recording terms in `GLOSSARY.md` and decisions in `docs/adr/` |
| `refactor-scan` | Find structural friction, propose ranked refactors toward deeper modules, then work through the one you pick |
| `resolve-merge-conflicts` | Finish a stopped merge, rebase or cherry-pick by working out what each side meant, keeping both, verifying and continuing |
| `investigate` | Look something up in primary sources and write cited findings to a Markdown file |
| `agent-retro` | Look back at a session and propose changes to the agent's environment |

Invoke with `/skill-name` in Claude Code, or `$skill-name` in Codex. GitHub workflows use the authenticated `gh` CLI, and GitLab uses `glab`.

## Layout

| Path | What it is |
| --- | --- |
| `skills/` | One copy of every skill, shared by all agents |
| `.claude-plugin/` | Plugin and marketplace manifests, read by Claude Code, Codex and Copilot |
| `instructions/AGENTS.md` | My global instructions, shared by every agent |
| `hooks/` | Claude Code session hook that injects the project's `AGENTS.md` (Claude Code reads only `CLAUDE.md`), shipped with the plugin |
| `scripts/install.sh` | Symlinks the instructions into each agent's config folder |
| `scripts/check-plugin.sh` | Checks `plugin.json` lists every skill in `skills/` |

## Versioning

The version lives in `.claude-plugin/plugin.json` only. Bump it, then commit and push: installed plugins update when it changes. Run `scripts/check-plugin.sh` after adding or removing a skill, because `plugin.json` lists skills explicitly.
