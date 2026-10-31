# Tracker: local Markdown

Use when there is no remote tracker. Each ticket is one Markdown file, never a single combined file.

## Layout

```
.tickets/
└── <feature-slug>/
    ├── spec.md                  # optional parent spec, never an actionable ticket
    └── 01-<slug>.md             # one file per ticket, numbered from 01
```

Check for an existing tickets directory (`.tickets/`, `.scratch/`, `.tasks/`) and reuse it. Otherwise create `.tickets/`.

## Verbs

- **Search:** `grep -ril "<key terms>" .tickets/`, and read the matching files. Closed tickets keep `Status: done` and are not deleted.
- **Create:** write `NN-<slug>.md`, numbered in dependency order (blockers first), using the ticket template from `SKILL.md`. Put these lines near the top:

  ```
  **Status:** open
  **Blocked by:** 01, 02   (or "None")
  **Labels:** kind/feature, area/auth
  ```

- **Edit:** edit the file in place. Reopen by setting `Status:` back to `open`.
- **Label:** the `Labels:` line. There is no label registry, so skip label creation and keep to the names in [labels.md](labels.md).
- **Link:** the `Blocked by:` line, using file numbers. A ticket is unblocked when every file it lists has `Status: done`.
- **Attach:** save the file next to the ticket and link it with a relative path.
- **Comments:** append under a `## Comments` heading at the bottom of the file.
