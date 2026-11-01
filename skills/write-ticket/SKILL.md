---
name: write-ticket
description: Creates and edits tickets (issues) and their labels so an AI agent or a human can pick them up and implement them. Use when creating or editing tickets, triaging, defining label taxonomy, or running issue or label commands. Always use this skill when the user asks to create tickets, plan a feature as tickets, break down work into tickets, or set up a project board. Also triggers when the user says "create a ticket", "create an issue", "open a ticket for", "track this as a ticket", or asks to organize work into tickets.
---

# Write Tickets

## Tracker

Work out the tracker before the first write, then read only its reference file:

1. Check `git remote get-url origin`. A `github.com` host means [references/github.md](references/github.md). A GitLab host means [references/gitlab.md](references/gitlab.md).
2. No remote, or an unknown host: ask the user once. If there is no tracker, use [references/local-markdown.md](references/local-markdown.md).
3. The user named a tracker: use that one.

The steps below use these verbs: **search**, **create**, **edit**, **label**, **link**, **attach**. The reference file says how to do each on that tracker.

Run the tracker's CLI from inside the repo, or pass its repo flag (`--repo OWNER/REPO` for `gh`), because scratch directories are not git repositories. Before drafting, read the repo's `AGENTS.md` and skim the code the work touches, so the ticket uses the project's own names.

## Core principles

### A ticket is a prompt

An agent reads the ticket and nothing else, so write it to stand on its own. Give it what it cannot discover from the code: why the work exists, which decisions are already made, what is out of bounds, and how to prove it is done.

### Every ticket leaves the codebase runnable

The developer should be able to implement it, verify it locally, and *then* open a PR.

- Never split work so the project is broken mid-series: no broken imports, missing routes, dangling references or unusable build.
- Size each ticket as one vertical slice: a thin cut that goes end to end through every layer the work touches, checkable on its own, and small enough for one fresh context window. If it needs more, split it.
- Acceptance criteria are binary (done or not done), never statements of intent.

### Explain why, not just what

A good ticket answers: why does this exist, what exactly changes, which decisions are already made, and how do we know it is done.

### Point, don't paste

Name the module, symbol or existing pattern to follow (`createApp`, "the auth middleware"). A plain file name like `server.test.js` is fine. Do not give line numbers or deep file paths, and do not paste code: they go stale. The one exception is a snippet that pins down a decision better than words can, such as a schema, a state machine, a type shape, or an exact response body.

Repo-wide rules (build and test commands, conventions) belong in `AGENTS.md`. Do not repeat them in the ticket. Put only task-specific constraints in it.

## Ticket template

Omit sections that are genuinely irrelevant. A trivial ticket (a typo, a one-line change) needs only a title, a sentence, and how to verify it.

```markdown
## Why / Context
<!-- Why does this exist? The problem it solves, or the goal it serves.
     Link the broader feature or parent spec if there is one. -->

## What needs to happen
<!-- The behaviour that changes, from the user's perspective.
     Specific enough that the implementer does not have to guess scope. -->

## Decisions and constraints
<!-- Only what the implementer cannot discover from the code: decisions already
     made, constraints, edge cases, API contracts, the existing pattern to follow.
     Name modules or symbols, not line numbers. -->

## Out of scope
<!-- What must not change, and what is deliberately left for other tickets. -->

## Acceptance criteria
- [ ] Specific, binary, testable criterion
- [ ] Another criterion

## How to verify (runnable)
<!-- Exact commands or steps run locally BEFORE opening a PR: a curl command,
     a CLI invocation, `npm test`, `pytest path::test_name`, "visit /route,
     click X, expect Y". If they fail, the PR is not ready. -->

## Dependencies / notes
<!-- "Blocked by #X", "Part of #Y". External dependencies (config, secrets,
     third-party APIs) belong here. Only include if relevant. -->
```

For a bug, add a **Steps to reproduce** section and the expected and actual behaviour. Reproduction steps beat a description of the problem.

Work that touches auth, security, or production-critical paths, or that needs a design decision nobody has made, is for a human. Say so in the ticket.

## Labels

See [references/labels.md](references/labels.md) for the taxonomy. The rules that always apply:

- Every ticket gets at least one label, and a label earns its place only if filtering by it gives a meaningful subset.
- Never create or apply priority labels, or dependency labels (`blocked-by`, `blocks`, `foundation`, `parallel`).
- Never use bare `enhancement`. Use `kind/feature`.

## Series: ordering and dependencies

When creating several tickets in a sequence, decide the order *before* writing any body:

- Which ticket leaves the codebase working on its own?
- Which cannot start until another is merged?
- Which are independent and can run in parallel?

Create dependencies in the order **blockers first**, so each ticket can reference real numbers.

**Record a dependency once.**
- Where the tracker has native blocking links, use them (see the reference file), and also write `Blocked by #X` in the body so the ticket reads on its own.
- Otherwise, the body's **Dependencies / notes** section is the only record.
- Do not add a comment that restates a dependency. A comment is only for genuinely new information that appears after creation.

**Always reference a related ticket by its number** (`#12`), never by a descriptive name. If bodies were written before the tickets had numbers, do a second pass with `edit` to replace every named reference with the real number. Afterwards, re-read each body and confirm every dependency is an actual number.

### Parents and umbrella tickets

A parent **spec** is fine: a separate artifact that describes the whole effort and links its tickets. It is never an actionable ticket, and you do not close or modify it. Do not create tracking tickets whose only purpose is a checklist of other tickets. Encode the series in each ticket's **Dependencies / notes** instead.

## Creating tickets

### Search for existing tickets first

Before creating any ticket, **search** open and closed tickets and PRs for the same work. Try at least two keyword variants (the feature name and its symptom or synonym), not only the exact title, since a duplicate is often worded differently. An empty result is fine: gaps in ticket numbers just mean tickets were deleted, so proceed. Then, for each planned ticket:

- **Open ticket already covers it:** do not create a new one. If its body is missing scope, acceptance criteria or verification steps from the request, **edit** it, keeping what is already there. Reuse its number in every cross-reference.
- **Closed as completed, and the work is in the codebase:** do not recreate it. Report it as already done.
- **Closed, but the work is not done** (closed as not planned, or the fix regressed): reopen it and update the body, rather than filing a copy. Report that you reopened it.
- **Open PR already implements it:** do not create a ticket. Report the PR.
- **Partial overlap:** create the new ticket for the remaining work only, and link the existing one in Dependencies / notes.
- **Unsure whether it is the same work:** ask the user before creating it.

The same applies when re-running a batch that partly failed: list what exists, create only what is missing, and never create a second copy of a ticket from the first run.

After the pass, report every ticket by number and say which were created, updated, reopened or skipped as duplicates.

### Create

- **Never hard-wrap prose.** The tracker renders Markdown and reflows paragraphs to the full width. Write each paragraph as a single unbroken line. A hard newline is only meaningful where it belongs: between list items, between paragraphs, in code blocks, in tables.
- Write body files under `~/.cache/scratch/<project>/` (`<project>` is the repository name) and delete them afterwards, cd'ing out of the directory first.
- Pass labels only when you have chosen them per the rules above.
- Attach screenshots or a recording only when the user asks. Save captures under `~/.cache/scratch/<project>/`, never `/tmp`, and delete them after the upload. How to attach is in the reference file.

## Do not

- Create a ticket without first searching open and closed tickets and PRs for one that already covers the work.
- Create a label that already exists, or a near-duplicate of one.
- Hard-wrap prose at ~80 columns in a ticket body.
- Write vague acceptance criteria like "it works". Every criterion must be binary and testable.
- Omit "How to verify". Verification happens locally before the PR is opened, never "after merging".
- Create a ticket whose implementation leaves the project broken mid-series.
- Reference a related ticket by a descriptive name when it exists. Use its number.
- Create tracking or umbrella tickets, or apply priority or dependency labels.
- Paste code or deep file paths into a ticket, or repeat repo-wide rules from `AGENTS.md`.
