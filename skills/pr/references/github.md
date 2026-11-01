# Host: GitHub

Use the **`gh`** CLI.

## Look up an open PR

```bash
gh pr list --head "$(git branch --show-current)" --state open --json url -q '.[].url'
```

Any output is the URL of the open PR. No output means there is none.

## Default branch

```bash
gh repo view --json defaultBranchRef -q .defaultBranchRef.name
```

## Create

```bash
gh pr create --base "<base>" \
  --title "<title>" --body-file <file> [--attach <file> ...]
```

`<base>` is the branch the user named, or the default branch from above. Add `--draft` only if the user asks.

## Check the issue link

The PR appears under the **issue's** Development sidebar only when its body has a closing keyword such as `Closes #N`. After creating the PR, run:

```bash
gh pr view --json closingIssuesReferences -q '.closingIssuesReferences[].number'
```

GitHub can take a few seconds to index the link, so if `N` is missing, wait about 5 seconds and run it once more before editing. If `N` is still missing:

```bash
{ gh pr view --json body -q .body; printf '\nCloses #N\n'; } > <file>
gh pr edit --body-file <file>
```

Then check again.

## Attach

Upload with `--attach <file>`, once per file, on `gh pr create`, `gh pr edit` or `gh pr comment`. It needs gh 2.99 or later: check `gh --version`. gh uploads each file and replaces its local reference in the body with a `github.com/user-attachments` URL, so reference it by the same path you pass to `--attach`. Attached files the body does not reference are appended at the end.
