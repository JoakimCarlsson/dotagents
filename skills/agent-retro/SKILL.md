---
name: agent-retro
description: Look back at a coding session and suggest improvements to the agent's environment (navigation, automated checks, coding standards, steering files, tooling), most severe first. Use when the user asks for a retro or retrospective, or asks why a session went slowly or badly.
---

# Agent Retro

You are not judging the code that was written. You are finding what in the agent's surroundings caused wasted time, wrong turns or mistakes, and proposing changes that would prevent them next time.

## 1. Read the session

Use the session the user names. If they name none, use the current conversation. For an earlier session, look for its logs on this machine. Claude Code keeps transcripts as `.jsonl` files in a `projects/<repo path with / and . replaced by ->/` folder, under `~/.claude/` or the account folder your setup uses (`find ~ -type d -name projects -path '*claude*'` finds it), and Codex keeps them under `~/.codex/sessions/`. Take the newest file unless the user names one. Transcripts are huge, so filter them with `jq` or a short script, for example the lines with `"type": "user"` for the user's messages and tool results with errors, and skip bookkeeping entries (queued operations, system reminders, task notifications) that are not real user turns. Read what actually happened (the commands, errors and corrections). If all you have is the user's description of the session, work from that and say so in the report. Check anything it claims about the repo against the repo itself, and report any mismatch.

## 2. Find the friction

First read the repo's own check commands and CI configuration, so you know what already runs. If there are none, that is itself a finding.

Mark every point where the agent:

- searched a long time for something it should have found fast
- made a mistake a machine could have caught
- was told something by the user that it should have already known
- ran an expensive or noisy command to learn something small
- lacked information it needed (a log, a service state, a doc)
- followed an instruction that did not help, or that fought another one

## 3. Pick the cheapest fix that lasts

For each friction point, choose the first option on this ladder that would really have prevented it:

1. **An automated check.** A lint rule, a type check, a test, a pre-commit hook or a CI job. A rule that can be checked by a machine belongs here, not in a document. Read the repo's own check commands and CI first: a check that exists but is never run, or fails without anyone noticing, is the finding. A small code change that makes a check possible, such as exposing a list the check can loop over, is in scope.
2. **A tool or access.** A script, a CLI wrapper, readable logs or read-only access to a service, when the cost was getting at information.
3. **A pointer.** One line in `AGENTS.md` that tells the agent where to look, when the cost was finding things. Link to a doc instead of explaining in place.
4. **A written rule.** Last, and only for judgement calls no tool could enforce, such as "match the surrounding style". Put it where it is read at the right time: coding rules where review happens, not where implementation starts. A rule about this repo goes in the repo's `AGENTS.md`. A rule about how the user wants the agent to behave everywhere goes in their global instructions.

Not every friction point needs a fix. A rare one-off, or one whose cause you cannot tell from the record, is reported as "no change" or "cause unknown", with the reason. Do not invent a rule to have something to propose. If the fix belongs outside this repo, in a skill or the user's global instructions, say where.

Also look for instructions to remove. An `AGENTS.md` that is long, that repeats what the code or a linter already says, or that holds instructions which change nothing the agent does, costs attention on every run. Proposing a deletion counts as a good finding.

## 4. Report

Order the proposals by severity, worst first: how much the problem cost (time, wrong results, user corrections) and how likely it is to recur. For each, give:

- what went wrong, with the moment in the session that shows it
- the area it falls in: **navigation** (finding things), **automated checks**, **coding standards**, **steering files** (`AGENTS.md` and similar), or **tooling** (scripts, access, logs)
- the proposed change, and which rung of the ladder it is
- where it goes (file or tool), and how big it is in lines

Propose only. Do not edit any file until the user says which ones to apply.
