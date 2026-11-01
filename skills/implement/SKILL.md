---
name: implement
description: Start work on a ticket (issue) — create a branch named after it and implement it. Use when the user links or names a ticket or issue, or invokes /implement.
---

# Implement

Given a ticket (issue URL or number), branch for it and implement it.

## Tracker

Work out the tracker before the first step, then read only its reference file:

1. Check `git remote get-url origin`. A `github.com` host means [references/github.md](references/github.md). A GitLab host means [references/gitlab.md](references/gitlab.md).
2. No remote, or an unknown host: ask the user once. If the ticket is a local file, use [references/local-markdown.md](references/local-markdown.md).
3. The user named a tracker: use that one.

The steps use these verbs: **fetch** a ticket and **create a linked branch**. The reference file says how to do each on that tracker.

## Input

A full ticket URL, or a bare number (`176` or `#176`, resolved against the repo of the current working directory). If neither is given, ask for the ticket.

## Part 1 — Branch

1. **Fetch** the ticket with its comments. If it cannot be found, stop and say so.
2. Build the branch name. First read the repo's `AGENTS.md` and `CONTRIBUTING.md` if they exist. If either states a branch naming pattern, use it. Otherwise use `task/<number>-<slug>`, where `<slug>` is the title:
   - lowercased
   - non-alphanumeric runs replaced by a single `-`
   - leading and trailing `-` stripped
   - if longer than 60 characters, cut at the last `-` at or before the 60th character; otherwise keep it whole
3. Make sure the working tree is clean (`git status --porcelain`; any output, untracked files included, means dirty). If it is not, stop and report. Do not stash or discard.
4. Note the starting branch with `git branch --show-current`. If it is empty (detached HEAD), stop and ask which branch to base on. The ticket branch starts from the starting branch, not from the default branch.
5. Check whether the branch already exists, by exact name: `git show-ref --verify --quiet refs/heads/<branch>` locally and `git ls-remote --heads origin <branch>` on the remote. If it does, check it out (a tracking branch for a remote one) instead of creating it.
6. Otherwise **create a linked branch** so the tracker links it to the ticket the moment it exists. See the reference file. Never post a comment on the ticket to "link" it, and never force-create over an existing branch.

Report the branch name before moving on.

## Part 2 — Implement

7. Read the ticket body **and its comments** in full, and follow any links in them. Treat later comments as refinements of the original body.
8. Read the repo's `AGENTS.md` files (root and any nested ones covering the files you touch) and follow them.
9. Explore the relevant code before editing. Match the surrounding style, naming and structure.
10. Implement the ticket completely, every point it asks for. If part of it is blocked or ambiguous in a way that changes the outcome, do the rest and say explicitly what you left out and why.
11. Verify. Run what `AGENTS.md` names for build, lint, type-check and tests, and then the ticket's "How to verify" steps if it has them. If you start a server, use a port that is free (check before starting it) and set it through the port variable `AGENTS.md` names, such as `PORT`, even if the ticket's steps name a different one, and stop the server afterwards. Fix what you broke.
12. Review. Run the `code-review` skill on your uncommitted changes, in a subagent with a fresh context if your agent can start one, so the reviewer is not the author. Fix every blocker and should-fix finding in code you wrote, and remove any unrequested behaviour it reports, then verify again (step 11). Do not act on nits or on code the ticket did not touch: list them in the summary instead.
13. Summarize: the branch, what changed and where, how it was verified, the review findings you fixed or left, and anything left open.

## Rules

- **Scope is the ticket.** Do not refactor unrelated code or fix unrelated bugs you notice. Mention them instead.
- **Tests:** write them when `AGENTS.md` requires tests for the kind of change you made, or when the ticket's acceptance criteria call for them. Otherwise do not add tests unprompted.
- **Do not commit or push.** Leave the changes in the working tree and tell the user they are ready to commit. Creating the branch on the remote through the tracker (Part 1) is the one exception.
- Do not open a pull request.

## Example

```
/implement https://github.com/OWNER/REPO/issues/176
```

Ticket #176 titled "Add `--json` output to `status`" becomes the branch `task/176-add-json-output-to-status`, and the change is implemented on it.
