# Tracker: GitHub

Use the **`gh`** CLI.

## Fetch the ticket

- Full URL: `gh issue view NUMBER --repo OWNER/REPO --json number,title,body,labels,state,comments`
- Bare number: `gh issue view NUMBER --json number,title,body,labels,state,comments`

## Create a linked branch

Create the branch through the issue, so GitHub lists it under the issue's Development section. This creates the branch on the remote, which is fine:

```bash
gh issue develop NUMBER [--repo OWNER/REPO] --name <branch> --base <start>
git fetch origin
git checkout -b <branch> --track origin/<branch>
```

- If the branch already exists locally or on the remote, check it out (a tracking branch for a remote one) and skip `gh issue develop`, because it cannot link an existing branch.
- If the starting branch has local commits its remote lacks, the new branch will not contain them, so run `git merge --ff-only <start>` after the checkout.
- The `--base` branch must exist on the remote. If `gh issue develop` fails (for example, the starting branch is not pushed), report why, then fall back to `git checkout -b <branch> <start>`.
