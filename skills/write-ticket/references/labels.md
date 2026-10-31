# Labels

## Contents

- The rule
- Prefix/value axes
- Standard axes and vocabularies
- Process labels
- Choosing labels for a batch
- Anti-patterns
- Naming rules

## The rule

**Every ticket gets at least one label.** A label only earns its place when filtering by it produces a *meaningful subset* of the ticket list. If filtering by the label returns "basically every ticket", the label is wallpaper: drop it.

A single ticket can (and often should) carry **one label per axis**, because each axis answers a different filtering question. A typical triaged ticket carries 3–4 labels.

## Prefix/value axes

Use `prefix/value` for closed-vocabulary axes, the convention pioneered by kubernetes/kubernetes: the **prefix names the axis** (what question the label answers), the **value names the choice**. The delimiter is `/`. Multiple axes coexist on one ticket.

Prefixes are good when they encode a real taxonomy axis with a closed set of values. They are bad when invented per label without a real axis behind them.

## Standard axes and vocabularies

| Prefix | Vocabulary | Question |
|---|---|---|
| `kind/` | **closed** | What type of work is this? |
| `triage/` | **closed** | What is the triage state? |
| `lifecycle/` | **closed** | Is this still active? |
| `area/` | **open**, derived per project | Which subsystem or component? |
| `sig/` or `team/` | **open**, derived per org | Which team owns this? |

Use the closed axes verbatim. Do not invent new values unless the canonical set genuinely cannot express the ticket.

**`kind/`**: `kind/bug`, `kind/feature`, `kind/cleanup`, `kind/refactor`, `kind/regression`, `kind/flake`, `kind/failing-test`, `kind/documentation`, `kind/dependency`, `kind/deprecation`, `kind/design`, `kind/api-change`, `kind/support`, `kind/security`, `kind/performance`.

**`triage/`**: `triage/accepted`, `triage/needs-information`, `triage/not-reproducible`, `triage/unresolved`, `triage/duplicate`.

**`lifecycle/`** (often bot-managed): `lifecycle/active`, `lifecycle/stale`, `lifecycle/rotten`, `lifecycle/frozen`.

**`area/`**: derive from the codebase you are in. Inspect the directory structure or module boundaries, and pick names that match this codebase. Never copy area labels from another project's domain.

**`sig/` or `team/`**: derive from the org. Only useful if several teams share the repo.

**Missing-metadata flags**, which mark that triage is incomplete: `needs-triage`, `needs-kind`, `needs-area`, `needs-repro`, `needs-design`. Make these explicit instead of leaving the ticket unlabeled.

## Process labels

Reserve unprefixed labels for process and bot signals, not taxonomy: `good-first-ticket`, `help-wanted`, `lgtm`, `approved`, `do-not-merge`, `blocked-external`, `wontfix`.

## Choosing labels for a batch

1. List the existing labels first (see the tracker's reference file).
2. Decide which axes apply. Most batches want `kind/` and `area/`. Add `triage/` only if there is a real triage workflow, and skip axes the project does not use.
3. For open axes (`area/`), inspect the codebase and pick names that match its natural components.
4. Create only the labels missing from that list. Never recreate or overwrite an existing label, and do not create a near-duplicate of one (`area/api` when `area/backend-api` exists): reuse it, or change it only if the user asks.
5. Apply per ticket: one value per axis that applies.

## Anti-patterns

- **Any priority label** (`priority/*`, `high`, `low`, `P1`...): never create or apply one. Bare `high`/`low`/`medium` encode severity without a timeframe and degrade into noise.
- **Bare `enhancement`**: use `kind/feature`.
- **`task` or `todo`** as labels: every ticket is a ticket.
- **Dependency labels** (`blocked-by`, `blocks`, `foundation`, `parallel`): dependencies go in the ticket.
- **Copying area labels** from another project's domain.
- **Inventing prefixes per label** without a real axis behind them: `mything/value` with no other `mything/*` labels is just a flat label with a slash in it.
- **The same label on every ticket in a series with no other axis varying.** Uniformity is only a problem if it is the only label, or if no other axis varies.
- **Triage or lifecycle labels applied reflexively** in a project that does not run that workflow.

## Naming rules

- Closed-axis labels: use the canonical `prefix/value` names above verbatim.
- Open-axis labels: `prefix/short-name`, lowercase, hyphens for multi-word, a single token where possible.
- Unprefixed process labels: lowercase, hyphens, no `/`.
- Use a consistent color per prefix (all `kind/*` one color, all `area/*` another) so the list reads quickly.
