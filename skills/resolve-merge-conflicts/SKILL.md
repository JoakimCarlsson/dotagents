---
name: resolve-merge-conflicts
description: Resolve the conflicts from a stopped git merge, rebase, cherry-pick or revert by working out what each side was trying to do, keeping both intents, verifying the result and continuing the operation. Use when a merge, rebase, cherry-pick or pull stops on conflicts, or the user asks to resolve conflicts.
---

# Resolve Merge Conflicts

Finish a git operation that stopped on conflicts, without losing either side's work. Do not push.

## 1. Find out what is stopped

1. Run `git status`. It names the operation (merge, rebase, cherry-pick or revert) and lists the unmerged paths. `git diff --name-only --diff-filter=U` lists just the conflicted files.
2. If there are no unmerged paths, say so and stop.
3. Work out which side is which, because it flips between operations:
   - **Merge and cherry-pick:** "ours" is the branch you are on, "theirs" is what is being brought in.
   - **Rebase:** "ours" is the branch you are rebasing onto (the upstream work), and "theirs" is your own commit being replayed. A rebase that looks like it keeps "theirs" is keeping your change.

## 2. Learn what each side meant

For every conflicted file, before editing it:

1. See the common ancestor as well as both sides. Do this before you edit, because it rewrites the file and drops any edits already made: `git checkout --conflict=diff3 -- <file>` redoes the markers to include the base.
2. Read the commits behind each side that touched the file: `git log --merge -p -- <file>`. It only works while the operation is stopped, and it lists just the commits that touch that path. If it prints nothing, find the merge base with `git merge-base HEAD <other>` and run `git log <base>..HEAD -p -- <file>` and `git log <base>..<other> -p -- <file>`.
3. When a commit message points to a ticket or PR and the intent is still unclear, read it.
4. Say, in a sentence each, what the two sides were trying to do. If you cannot, you are not ready to edit.

## 3. Resolve

- **Keep both intents.** Rewrite the conflicted region so it does what both sides wanted. Do not pick a side wholesale unless the other side's change is fully contained in it or has been made obsolete by it.
- **When the order matters** (for example a discount and a tax that give different totals depending on which runs first), choose the order the surrounding code and commit messages suggest, and flag the choice in the report.
- Files that merged cleanly and are already staged are part of the operation. Leave them staged.
- **Generated and lock files** (lockfiles, compiled output, snapshots, schemas generated from code): do not hand-merge. Take either side, then regenerate with the project's own command.
- **Delete versus modify, and renames:** decide from the intent of each side. If one side removed a file because its purpose moved, carry the other side's edit to the new place.
- **Binary files:** you cannot merge them. Pick one side only if the history makes the right one clear, otherwise ask the user.
- **Ask the user** when the two intents truly contradict each other and the history does not say which wins. Ask one specific question and name both options.
- Remove every conflict marker. Leave unrelated lines in the file as they are.

## 4. Verify

1. Search the whole tree for leftover markers: `git grep -nE '^(<<<<<<<|=======|>>>>>>>)( |$)'`.
2. Run what `AGENTS.md` names for build, type-check, lint, format and tests. If it names nothing, run the project's obvious equivalents, and if there are none, say so in the report.
3. If the checks do not exercise the behaviour you merged, run a quick manual check of it and say in the report that coverage is thin. Do not add tests unless asked.
4. A merge can break code in files that never conflicted: one side changed a signature or behaviour, and the other side added a caller. If checks fail in a file you did not touch, fix it. These are part of the merge.

## 5. Continue

1. Stage the resolved files by path with `git add <file>`. Never `git add -A` or `git add .`.
2. Continue without opening an editor: `git -c core.editor=true merge --continue`, `rebase --continue`, `cherry-pick --continue` or `revert --continue`.
3. A rebase may stop again on the next commit. Repeat from step 1 until `git status` shows the operation is finished.

## Rules

- **Never** run `--abort`, `git reset --hard`, `git checkout --ours .` or `--theirs .`, `git rebase --skip`, a force push or any push. If the right move is to abort or skip, tell the user and let them decide.
- **No attribution.** Never add `Co-Authored-By`, "Generated with <agent>", a footer or an emoji tag to a merge or commit message.
- Keep the message git proposes. Do not hard-wrap or expand it.

## Report

For each conflicted file, one line on what each side wanted and how you combined them. Then say what you ran to verify and whether it passed, and flag any judgment call the user may want to review.
