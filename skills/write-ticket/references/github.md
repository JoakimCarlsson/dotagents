# Tracker: GitHub

Tickets are GitHub issues. Use the **`gh`** CLI. Use `git` only for local repo operations. Do not use the web UI for bulk or scripted work unless the user asks.

## Contents

- Check the target
- Search
- Create
- Edit, reopen
- Labels
- Link: blocking and sub-issues
- Attach screenshots and recordings
- Series: second pass

## Check the target

In a fork, `gh` can default to the upstream parent. Before the first `gh issue create` of a session, check the target with `gh repo view --json nameWithOwner`. Confirm with the user only if the repo is not the one named in the request or the current clone's `origin`, or if the clone is a fork (`gh repo view --json isFork`).

## Search

```bash
gh issue list --state all --limit 200 --json number,title,state,labels
gh issue list --state all --search "<key terms> in:title,body" --json number,title,state,url
gh pr list --state all --search "<key terms>" --json number,title,state,url
```

## Create

```bash
gh issue create --title "Clear, specific title" --body-file <path>
```

- On PowerShell always prefer `--body-file`, because bash heredocs do not work the same way.
- Pass `--label` only when you have chosen labels per [labels.md](labels.md). Do not pass `--label "enhancement"` reflexively.

## Edit, reopen

```bash
gh issue edit <num> --body-file <path>
gh issue reopen <num>
gh issue view <num>
```

## Labels

```bash
gh label list
gh label create "<prefix/value>" --description "<short description>" --color "<hex without #>"
gh issue edit <num> --add-label "kind/bug,area/cache"
gh issue edit <num> --remove-label "<label>"
```

Hex colors are written without `#`.

## Link: blocking and sub-issues

Native links need `gh` 2.94 or later (check `gh --version`).

```bash
gh issue create --blocked-by 12,13 ...          # at creation
gh issue edit <child> --add-blocked-by <blocker>
gh issue create --parent <parent> ...           # sub-issue at creation
gh issue edit <parent> --add-sub-issue <child>
```

Create blockers first so the numbers exist. Also write `Blocked by #X` in the body. On an older `gh`, or where dependencies are unavailable, the body line is the only record. Use `Part of #<parent>` at the top of a child body where sub-issues are unavailable.

## Attach screenshots and recordings

Use `--attach <file>` once per file on `gh issue create`, `gh issue edit` or `gh issue comment`. It needs gh 2.99 or later.

- Reference each file in the body by the same path you pass to `--attach`: `![What it shows](shot.png)` for an image, and `![](clip.mov)` alone in its own paragraph for a video, which then renders as a player. Videos must be MP4, MOV or WebM.
- Capture only when the user asks. On macOS use `screencapture`, which never moves the cursor: `screencapture -x shot.png` for the whole screen, `-R x,y,w,h` for a region, `-l <window-id>` for one window, `screencapture -x -v -V 5 clip.mov` for a five-second recording. Never use the interactive modes (`-i`, `-W`).
- Save captures under `~/.cache/scratch/<project>/`, never `/tmp`, and delete them after the upload.

## Series: second pass

Create blockers first, so a dependent ticket's body can cite the real `#number` when you write it. Then no second pass is needed. Only when a body had to be written before the number it refers to existed, edit it afterwards with `gh issue edit <num> --body-file` to replace every named cross-reference with the real `#number`. Either way, re-read each body with `gh issue view <num>` and confirm every dependency is an actual number.
