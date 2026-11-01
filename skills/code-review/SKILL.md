---
name: code-review
description: Review a change before it ships. Checks it against the ticket, against the repo's own rules, and for bugs, then gives one verdict and a list ordered by severity. Use right after implementing a ticket, or when the user asks to review a branch, a PR or uncommitted work. Reports only and never edits code.
---

# Code Review

Decide whether a change is ready, and list what has to change if it is not. Report only: do not edit, stage or commit anything.

## 1. Scope

Review what the user names (a ref, a branch, a PR). Otherwise:

1. If the working tree has uncommitted changes, review those: `git diff HEAD`, plus every untracked file in `git status --porcelain` (a diff leaves them out, so read them directly).
2. If it is clean, review the branch against the default branch: `git diff <default>...HEAD`. Find the default with `git symbolic-ref --short refs/remotes/origin/HEAD`.

If the ref does not resolve or the diff is empty, stop and say so.

## 2. Gather context

- **The ticket.** Use one the user named, else the number in the branch name (`task/<N>-…`, or the repo's own pattern) or a `Closes #N` in the commits. Fetch it with its comments: `gh issue view N --json title,body,comments` (add `--repo OWNER/REPO` if `origin` is not its repo), `glab issue view N --comments`, or the local file. No ticket, no spec file, and the user says there is none: skip check A and say so.
- **The rules.** Every document that tells contributors how to write code: `AGENTS.md` (root and nested ones covering the changed files), `CONTRIBUTING.md`, lint and formatter configs.
- **The code.** Read each changed file whole, not only the changed lines, and open the callers of anything whose behaviour changed.

## 3. Three checks

**A. Does it do what was asked?** For every acceptance criterion in the ticket, decide met, partly met or not met, and point at the code or the command output that shows it. Run the ticket's "How to verify" steps and the project's tests. Starting a local server on a free port is fine if you stop it, and logs and pid files go under `~/.cache/scratch/<project>/`, never `/tmp`. Never run anything that touches a remote. Also list anything the change does that the ticket did not ask for or put out of scope.

**B. Does it follow the repo's rules?** Only rules the repo wrote down, quoted by file. Skip what a linter or formatter already enforces, and do not invent style preferences of your own.

**C. Will it break?** Read the code looking for wrong conditions, unhandled errors and empty or oversized input, off-by-one slips, leaked resources, races, and security problems (injection, unsanitised input, secrets in code or logs). Then read the tests: would they fail if the behaviour broke, or do they only run the code? New behaviour with no test is a finding when the repo's rules ask for tests.

Report only what you can point to in the code. If you suspect something you could not confirm, say it is unconfirmed.

## 4. Severity

- **blocker**: wrong behaviour, a missed acceptance criterion (including a test the ticket demands), a crash, a security hole, or a broken written rule.
- **should fix**: a real weakness that will cost later and that no criterion or written rule requires fixing now, such as an unhandled edge case or a thin test.
- **nit**: take it or leave it. Report at most three, and none if nothing is worth saying.

## 5. Report

```markdown
**Verdict:** ready | ready, N should-fix | fix first (N blockers)

**Ticket #N** (omit if none)
- [met] criterion text
- [partly met] criterion text: what is missing
- [not met] criterion text: what is missing

**Findings**
1. [blocker, A] `file:line`: what is wrong, why it matters, and the smallest fix.
2. [should fix, C] `file:line`: …
```

Order findings by severity, then by file. Tag each with the check (A, B or C) that found it. Put unrequested behaviour under A, and list a defect once: as a finding if it also breaks a criterion, not again as a separate item. If there are no findings, say the change is ready and nothing else. Keep the whole report short enough to read in a minute.

For a very large diff you may split the files across subagents, each started with a fresh context and asked for findings only, but you write the one merged report.
