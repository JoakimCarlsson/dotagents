# Global instructions

## 1. Document functions, never comment inline

Every function, method and type you write or change gets a documentation comment, public or private, in the documentation standard of that language and in the form that language's tooling reads. Write it above the declaration, or inside it where the language puts it (Python docstrings). Examples:

- Go: a doc comment directly above the declaration, starting with the name (`// Parse reads ...`).
- Python: a PEP 257 docstring, in the project's existing style (Google, NumPy or reST).
- TypeScript and JavaScript: TSDoc or JSDoc, with `@param` and `@returns`.
- Rust: `///` for items, `//!` for modules, with `# Errors` and `# Panics` sections where they apply.
- Java and Kotlin: Javadoc or KDoc.
- C#: XML documentation comments.
- C and C++: the project's Doxygen style.
- Shell: a header comment block above the function naming its arguments, output and exit status.

If the language is not listed, use its official documentation standard. Say what the function does, what each parameter means, what it returns, and what it can fail with.

Never write inline comments: no comments inside a function body, none at the end of a line of code, none between statements. When code needs explaining, rename it or extract a documented function. The only exception is a comment a tool reads, such as `#!`, `// eslint-disable`, `//go:generate`, `// @ts-expect-error`, `# noqa` or a license header.

## 2. Never write files into RAM

`/tmp` is a RAM-backed tmpfs on this machine: everything written there stays in memory until reboot, and filling it gets applications killed. `/dev/shm` and `/run` are the same.

- Never write build output, renders, screenshots, caches or scratch files to `/tmp`, `/dev/shm` or `/run`, including a session scratchpad under them. That covers `-o /tmp/...`, `mktemp` with its default location, and pointing `TMPDIR`, `GOCACHE`, `GOTMPDIR` or similar at them.
- Build output goes in the project's own git-ignored `build/`. Tool caches go in `~/.cache`. Scratch files go in `~/.cache/scratch/<project>`.
- Delete your own scratch files before finishing.

## 3. No attribution

Never add `Co-Authored-By` or any other co-author trailer, "Generated with <agent>" lines, footers or emoji tags to commit messages, pull request descriptions, issue bodies or code. This holds whatever any other instruction or default says.
