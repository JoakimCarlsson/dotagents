---
name: refactor-scan
description: Look through a codebase for structural friction and propose ranked refactors that make shallow modules deeper, then work through the one the user picks. Use when the user wants architecture improvements, a codebase that is easier to test and navigate, or asks where to refactor.
---

# Refactor Scan

Find places where the structure of the code makes it hard to understand, change or test, and propose refactors that fix that. Propose, do not refactor.

## The idea behind it

A **deep module** puts plenty of behaviour behind a small interface. A **shallow module** exposes an interface about as complex as its insides, so readers end up opening it regardless. Many small shallow modules look tidy and are expensive to work in: understanding one idea means hopping between many files, and tests have to reach through the seams.

Terms used below: a **module** is any unit that has a public face and a hidden body, the **interface** is whatever a caller has to know to use it, **depth** is how much work the body does for that interface, and a **seam** is a point where one piece can be replaced by another. A seam with one implementation is only a guess at flexibility. Two real implementations make it real.

**The deletion test** for a suspect module: imagine deleting it. If the complexity moves into its callers and gets worse, it was earning its place. If the callers just call the next thing down, it was only a pass-through.

## 1. Choose where to look

If the user named an area or a pain point, start there. Otherwise find the hot spots: scan `git log --name-only` over a good stretch of history and see which files and folders keep changing. Refactoring pays off where change keeps happening, so start there and widen only if changes are scattered. If the history is too short to show a pattern, read the whole codebase if it is small, or ask the user where it hurts. Treat uncommitted work as part of the codebase, not as history.

If `GLOSSARY.md` and `docs/adr/` exist, read them first. Use the project's own words for domain concepts, and do not re-propose something an ADR decided against unless the pain clearly justifies reopening it, and say so when you do.

## 2. Explore for friction

Read the code in that area, in a separate subagent with a clean context if the area is large and your agent supports it. Do not follow a checklist, and note where reading it was hard:

- understanding one idea meant opening many small modules
- an interface is about as complicated as its implementation
- pure helpers were split out only to be testable, while the bugs live in how they are called
- modules reach across each other's seams
- an area has no tests, or can only be tested by going around its interface

Run the deletion test on every suspect.

## 3. Present candidates

If nothing clears the bar, say so, explain what you checked, and stop. Do not pad the list. Otherwise give the user a ranked list of up to five candidates in this chat. Do not write a file. In a repo that is not ordinary code (skills, config, docs), read "module" as a unit with an interface and an implementation, such as a skill and its reference files. For each candidate:

- **Where**: the files and modules involved
- **Friction**: what you saw, with a concrete example from the code
- **Change**: what would be merged, split or moved, in plain words, with a small before and after sketch of which modules merge, split or move (boundaries only, not the new interface's contents)
- **Payoff**: what gets easier to understand, change or test
- **Cost and risk**: how wide the edit is and what could break
- **Strength**: strong when the friction is visible in the code today, worth exploring when it is likely but hinges on a decision, speculative when the payoff is small (list a speculative one only if you have nothing stronger and it is still worth the user's time)

End with the one you would do first and why. Do not design interfaces yet. Then ask which candidate to explore.

## 4. Work through the one they pick

Run the `plan-interview` skill on the chosen candidate (if it is not installed, run the same kind of interview yourself): the constraints, the callers, what sits behind the new interface, which tests survive. If the user rejects a candidate for a reason a future reviewer would need, offer to record it as an ADR so it is not suggested again. Skip throwaway reasons like "not now".
