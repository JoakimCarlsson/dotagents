# Tracker: GitLab

Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI.

## Fetch the ticket

```bash
glab issue view NUMBER --comments
```

Add `-R OWNER/REPO` when the ticket is in another repo. Use `-F json` for machine-readable output.

## Create a linked branch

GitLab has no command that links a branch to an issue. Create the branch locally:

```bash
git checkout -b <branch> <start>
```

If the branch already exists locally or on the remote, check it out instead. The link to the issue comes later, from `Closes #NUMBER` in the merge request.
