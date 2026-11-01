---
name: plan-interview
description: Interview the user hard about a plan or design until it is settled, and record the vocabulary and decisions that come out of it in GLOSSARY.md and docs/adr/. Use when the user wants a plan stress-tested, says "grill me", or is shaping a design whose terms are fuzzy.
---

# Plan Interview

Question the user about a plan until nothing important is left assumed, and write down what gets settled so the next session does not reopen it.

## The interview

- **Ask in rounds.** Each round is two to five numbered questions whose answers do not depend on anything the user has not told you yet. Put every independent question in the earliest round it fits, and a question that needs an answer from this round in the next one. A question that depends on another open one waits for a later round.
- **Recommend an answer.** After each question, say what you would pick and why in one line, and word the question so "yes" accepts it. If the decision hinges on a fact only the user knows (where it is deployed, who uses it), ask that openly and say what you would assume without it.
- **Look facts up yourself.** If the answer is in the code, the docs, the tracker or the git history, find it instead of asking. Ask the user only for decisions and for things only they know.
- **Probe with cases.** When a rule or a relationship is stated, invent a concrete scenario that tests its edge and ask what should happen.
- **Treat the repo's written rules as settled.** What `AGENTS.md` and the ADRs already decide (no dependencies, say) is not up for another vote: build on it, or flag the conflict.
- **Check the code against what you hear.** If the user says how something works and the code disagrees, say so and ask which is right.
- **Stop when no branch is open.** The interview is done when every decision has an answer and nothing is silently assumed. Summarise the shared understanding and wait for the user to confirm before acting on it.

## Keep a glossary

Read `GLOSSARY.md` and `docs/adr/` first, if they exist, and use the project's own terms.

- If the user's word clashes with the glossary, or a word that means two things ("account": the person or the login?), stop and settle it.
- Record only terms that were contested, ambiguous or specific to this project, or that the project has no word for yet, not words the code already makes obvious. When one is settled, add it to `GLOSSARY.md` right then, not at the end. One entry is the term in bold and a one or two sentence definition, plus terms to avoid if there are any. No implementation details, no specs, no scratch notes.
- Create the file when the first term is settled.

## Record decisions sparingly

Offer ADRs once, near the end of the interview, not mid-way. Offer one only when all three are true: the decision is hard to reverse, a future reader would be surprised by it without context, and it was a real choice between alternatives. If any is missing, do not write one.

An ADR is one file, `docs/adr/NNNN-short-title.md`, numbered in order from `0001` (create the directory if it is missing):

```markdown
# NNNN. Title

Status: accepted

## Context
What forced the decision.

## Decision
What we chose, and the alternatives we turned down.

## Consequences
What gets easier, what gets harder.
```

Create it only after the user agrees. Do not commit any of these files.
