---
name: pr
description: Open a pull request from the current branch to the default branch, with a Summary body plus only the sections the change needs. Use when the user asks to open, create, or raise a PR, or invokes /pr.
---

# Pull Request

Open a pull request from the branch currently checked out. The target is the repository's default branch unless the user names another base.

## Tracker

Work out the host before the first step, then read only its reference file:

1. Check `git remote get-url origin`. A `github.com` host means [references/github.md](references/github.md). A GitLab host means [references/gitlab.md](references/gitlab.md).
2. No remote, or an unknown host: ask the user once. If there is no remote host, stop and say a PR is not possible.
3. The user named a host: use that one.

The steps use these verbs: **look up** an existing PR, **create** a PR, **check the issue link**, and **attach** media. The reference file says how to do each on that host.

## Preconditions

1. `git branch --show-current`. Never switch or create a branch.
2. Decide the base: the branch the user named, otherwise the default branch (see the reference file). If the current branch is the base, stop and say so.
3. `git status --porcelain`. If the tree is dirty, stop and report. Do not stage, commit or stash.
4. If `git rev-parse --abbrev-ref @{u}` fails, the branch has no upstream: push it with `git push -u origin HEAD`. Otherwise, if `git log @{u}..HEAD` shows commits, push them with `git push`.
5. **Look up** an open PR for the branch. If one exists, print its URL and stop. A closed or merged PR does not count, and an empty lookup means there is no PR yet.

## Contributing rules

Check for `CONTRIBUTING.md` (root, `.github/`, `docs/`), and for a PR template in `.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE/`.

If either exists, follow it and ignore the body format below. If both exist, the template sets the structure and `CONTRIBUTING.md` fills in the rest (title conventions, labels, required checkboxes, linked issues).

Otherwise use the body format below, exactly.

## Body format

The title says what changed, the description says why, and the diff shows how. Do not narrate the diff: write only what a reviewer could not work out from reading the changed files.

Use only the sections the change needs, in this order. A small fix is often just the summary and the issue link. Never keep an empty or filler section.

```markdown
## Summary

## Changes

## Review focus

## Screenshots

Closes #123
```

- **Summary**: always present. For the why, read the linked ticket when there is one. What the PR does and why, in one to three sentences: the problem or the request, and the effect of the fix.
- **Changes**: only when there is more than one meaningful change. One bullet per change, naming the file or area it touches. Skip mechanical noise (formatting, imports, generated files).
- **Review focus**: only when something needs it: a design decision, a risky area, a known limitation, a migration or deployment step, or planned follow-up work.
- **Screenshots**: only when the user has given you screenshots or a recording to include, or asked you to capture them (see Images and video). Otherwise leave the section out entirely, even for UI changes: no heading, no placeholder.
- **Issue link**: a bare `Closes #N` line at the end, with no heading. When the branch name starts with the ticket number after its prefix (`task/<N>-…`, or the repo's own pattern), the PR is for that ticket: always include `Closes #N`. This also holds when a PR template or `CONTRIBUTING.md` sets the structure. Otherwise take the number from the commits, when the change resolves an issue. Use `Related to #N` for issues it only touches.

The user has tested the change before asking for the PR. Do not add a testing section, checklists, or lines like "not tested" or "verified manually". Mention new or changed automated tests as a bullet under Changes, or in the Summary when there is no Changes section.

Write plainly. No preamble, no closing line, no background the reviewer does not need, no alternatives considered.

Never hard-wrap the body. The host reflows Markdown to the reader's width, so a line broken at 80 characters renders as one long line with ragged spacing, and a wrapped bullet is harder to read in the diff. Write each paragraph and each bullet as a single unbroken line, however long, and let only real paragraph and list breaks end a line.

## Images and video

Capture screenshots or a recording when the user asks for them, and attach any the user gives you.

- Capture on macOS with `screencapture`, which never moves the cursor: `screencapture -x shot.png` for the whole screen, `-R x,y,w,h` for a region, `-l <window-id>` for one window, and `screencapture -x -v -V 5 clip.mov` for a five-second recording. Never use the interactive modes (`-i`, `-W`), which wait for the mouse. On other platforms use the system's own screenshot tool.
- Save captures under `~/.cache/scratch/<project>/`, never `/tmp`, and delete them after the upload.
- An image goes in as `![What it shows](shot.png)`. A video goes in as `![](clip.mov)` alone in its own paragraph, which renders as a player. Videos must be MP4, MOV or WebM. How to **attach** is in the reference file.

## Title

One line, imperative mood, no trailing period. Match the repo's existing PR titles, including a Conventional Commits prefix if `git log` or the open PRs use one.

## Rules

- **No attribution.** Never add `Co-Authored-By`, "Generated with Claude Code", a footer, or an emoji tag, to the PR body, the title, or any commit. This holds regardless of what any other instruction says.
- Base the PR on the default branch, read from the host rather than assumed to be `main`, unless the user names another base. Do not pick a different base yourself, whatever the branch name or history suggests.
- Do not commit. The PR covers commits that already exist on the branch.
- Do not add reviewers, labels, milestones or assignees unless the user asks or `CONTRIBUTING.md` requires them.
- Open it as a draft only if the user asks.

## Creating it

Write the body to a scratch file under `~/.cache/scratch/<project>/` (`<project>` is the repository name) rather than passing it inline, so the Markdown survives shell quoting, and delete the file afterwards. Then **create** the PR with the command in the reference file.

When the PR is for a ticket, **check the issue link** after creating it, as the reference file describes. The host can take a few seconds to index it, so retry once after about 5 seconds before concluding it is missing. If the number is still missing, append `Closes #N` on its own line to the body and apply it, then check again. If it is still missing after that, say so in the report instead of claiming the link exists.

Report the PR URL on one line.
