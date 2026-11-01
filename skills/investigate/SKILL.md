---
name: investigate
description: Look something up in primary sources and write the findings to a Markdown file with citations. Use for questions about a topic, an API or a library, or when reading should be handed off while the user keeps working.
---

# Investigate

Answer a question from the sources that own the facts, and leave the answer in a file the team can reuse.

## How

1. **Pin the question.** Restate it in one sentence. If it is too broad to answer in one document, or a word in it could mean two things, say how you narrowed it, and ask the user first if the two readings would need different research.
2. **Delegate if you can.** If your agent can run a background subagent and the user has not asked you to do it yourself, hand it the question, these steps and the file rules below with a clean context of its own, and tell the user it is running so they can keep working. Otherwise do the research yourself.
3. **Go to primary sources.** Official documentation, the source code, specifications, first-party APIs and release notes. A blog post or a forum answer can point you to a source but is never the source. Check that a page is current, because docs get versioned. If a long docs page comes back truncated or summarised, fetch the raw source instead (the docs repository file, or the site's JSON or markdown export), and check any version number or default you quote against the raw text, since a summary can get them wrong. Code moves between files, so confirm a file still holds what you cite.
4. **Verify what you can by running it.** If a claim is about behaviour you can test locally in a few seconds, test it, using a scratch directory under `~/.cache/scratch/<project>/` (a sibling directory if the working tree is the project) that you delete afterwards, and record the exact command and the result so a reader can rerun it.
5. **Write one Markdown file.** Put the answer first, then the evidence. Every claim carries a link or a file path to where it came from, and anything you could not confirm is labelled as unconfirmed rather than stated flat.

## Where the file goes

Read the repo's `AGENTS.md` for a notes convention. Otherwise look for where the repo already keeps notes of this kind (`docs/`, `research/`, `notes/`) and follow it. If there is nothing, use `docs/research/<topic>.md`, with `<topic>` a short lowercase slug of the question, creating the directory if needed. Tell the user the path. Never write it to `/tmp`.

## Layout of the file

```markdown
# <the question>

**Answer:** <two or three sentences, one per version if the answer differs by version>

**Scope:** <how you narrowed the question, if you did>

## Findings
- <claim> ([source](url))
- <claim you tested locally>: `<command>` gave `<result>`, <tool and version>

## Unconfirmed
- <what you could not verify, and why>

## Sources
- <title>, <url>, <doc version and date consulted>. For a rolling branch, give the commit hash or release instead of "main".
```

Do not commit the file.
