# Host: GitLab

Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI. GitLab calls pull requests "merge requests".

## Look up an open MR

```bash
glab mr list --source-branch "$(git branch --show-current)" -O json
```

An empty list means there is no open MR.

## Default branch

```bash
git remote show origin | sed -n 's/.*HEAD branch: //p'
```

## Create

```bash
glab mr create --target-branch "<default branch>" --title "<title>" --description "$(cat <file>)"
```

Add `--draft` only if the user asks.

## Check the issue link

`Closes #N` in the description closes the issue when the MR merges. After creating the MR, run `glab mr view` and confirm the description contains the line. If it is missing, append it and apply it with `glab mr update --description "$(cat <file>)"`.

## Attach

Upload with the project uploads API, `glab api projects/:id/uploads -F file=@<file>`, and use the Markdown link it returns in the description.
