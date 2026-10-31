# Tracker: local Markdown

The ticket is a Markdown file, usually under `.tickets/`, `.scratch/` or `.tasks/`, given as a path or a number.

## Fetch the ticket

Read the file in full, including its `## Comments` section. If given a number, find the file whose name starts with that number.

## Create a linked branch

There is nothing to link to. Create the branch locally:

```bash
git checkout -b <branch> <start>
```

Use the ticket file's number and title for the name. If the branch already exists, check it out instead.
