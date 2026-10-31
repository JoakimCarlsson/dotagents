# dotagents

My skills for coding agents: commit, write tickets, implement a ticket and open a pull request. Works with Claude Code, Codex, Copilot and others.

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

## Skills

| Skill | What it does |
| --- | --- |
| `commit` | Commit the session's changes on the current branch, without pushing |
| `write-ticket` | Create and edit tickets and labels so an agent or a human can implement them |
| `implement` | Create a branch for a ticket and implement it |
| `pr` | Open a pull request to the default branch |

Invoke with `/skill-name` in Claude Code, or `$skill-name` in Codex. GitHub workflows use the authenticated `gh` CLI, and GitLab uses `glab`.

## Layout

| Path | What it is |
| --- | --- |
| `skills/` | One copy of every skill, shared by all agents |
| `.claude-plugin/` | Plugin and marketplace manifests, read by Claude Code, Codex and Copilot |
| `scripts/check-plugin.sh` | Checks `plugin.json` lists every skill in `skills/` |

## Versioning

The version lives in `.claude-plugin/plugin.json` only. Bump it, then commit and push: installed plugins update when it changes. Run `scripts/check-plugin.sh` after adding or removing a skill, because `plugin.json` lists skills explicitly.
