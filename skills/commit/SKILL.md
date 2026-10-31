---
name: commit
description: Commit the changes made in this session on the current branch, without pushing. Use when the user asks to commit or invokes /commit.
---

# Commit

Commit the changes made during this session. Do not push.

## Rules

- **Never change branches.** Commit on whatever branch is currently checked out. Do not `git checkout`, `git switch`, or create a new branch — not even if the current branch is `main`/`master`.
- **Only stage what was touched in this session.** Stage those paths explicitly by name. Never use `git add -A`, `git add .`, or `git commit -a`.
- **Keep the message to one line.** No bullet lists, no body paragraphs.
- **No attribution lines.** Never add `Co-Authored-By`, `Generated with Claude Code`, or any similar trailer, footer, or emoji tag.
- **Never push.** Pushing is a separate step.

## Steps

1. Run `git status` and `git diff` to confirm what changed, and `git branch --show-current` to confirm the branch.
2. Stage only the files changed in this session, by path. If the changes were made earlier by another agent or session and the user is asking you to commit them, stage the modified tracked files they cover. Leave untracked files you did not create out, and mention them in your reply.
3. Print the full staged diff with `git diff --cached` and read it (not just `--stat`, and not a line count) before writing the message.
4. Commit with a short message describing what changed and why. Do not run tests first unless the user asks.

## Message format

A single line in the imperative mood. No body, no trailer.

```
Add rate limiting to the auth endpoints
```

## If something blocks the commit

- Pre-commit hooks fail: report the failure, leave the changes staged, and let the user decide. Never use `--no-verify`.
- Nothing to commit: say so and stop.
