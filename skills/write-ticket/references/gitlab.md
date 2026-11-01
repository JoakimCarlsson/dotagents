# Tracker: GitLab

On GitLab a ticket is an issue, handled with `glab` (GitLab's command line tool). GitLab names comments "notes" and pull requests "merge requests".

## Check the target

Confirm the project with `glab repo view` before the first `glab issue create` of a session.

## Search

```bash
glab issue list --all -O json
glab issue list --all --search "<key terms>" -O json
glab mr list --all --search "<key terms>" -O json
```

## Create and edit

```bash
glab issue create --title "Clear, specific title" --description "<body>"
glab issue update <num> --description "<body>"
glab issue reopen <num>
glab issue view <num> --comments
```

Use `--description -` to open an editor.

## Labels

```bash
glab label list
glab label create --name "<prefix/value>" --description "<short description>" --color "#<hex>"
glab issue update <num> --label "kind/bug,area/cache"
glab issue update <num> --unlabel "<label>"
```

## Link

- **Blocking:** use GitLab's own link, created by sending the `/blocked_by` quick action as a note: `glab issue note <child> --message "/blocked_by #<blocker>"`. Only paid tiers (Premium and Ultimate) have it. On the free tier, the body line `Blocked by #X` is the only record.
- **Related:** `glab issue create --linked-issues <n> --link-type relates_to`.

Also write `Blocked by #X` in the body. Create blockers first.

## Attach

Upload through the web UI or the project uploads API (`glab api projects/:id/uploads -F file=@<file>`), then reference the returned Markdown link in the body. Save captures under `~/.cache/scratch/<project>/`, never `/tmp`, and delete them afterwards.

## Series: second pass

Create blockers first so dependent bodies can cite real `#number`s. Only edit a body afterwards if it was written before the number it refers to existed. Re-read each one to confirm.
