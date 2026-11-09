# Architecture Decision Records

An ADR records a decision that a future maintainer could not reconstruct from the code alone.

## When to write one

Write an ADR only when all three hold:

- Reversing the decision later would be costly.
- The choice is surprising without context.
- Real alternatives were weighed and the trade-off matters.

Do not write one for routine implementation choices, temporary constraints, or conventions that explain themselves.
Changes to a decision that already has an ADR update or supersede that ADR in the same pull request.

## Numbering and files

- Name files `NNNN-short-title.md` with a four-digit number, lowercase words, and hyphens.
- Take the next number. Numbers run `0001`, `0002`, ... without gaps; `bin/docs-check` enforces this.
- Never delete an ADR or renumber one. Mark an obsolete ADR **Deprecated** or **Superseded by NNNN**.
- Add the new ADR to the Decisions list in [docs/README.md](../README.md).

## Template

```markdown
# Short title

One to three sentences: the context, the decision, and why it was chosen.
```

Add a status line, the alternatives, or the consequences only when they preserve context a reader would otherwise lose.

## Decisions

The first two ADRs record decisions Railbed made before this application existed. Add application decisions after them.

- [0001 -- One PostgreSQL database for Solid tables](0001-one-postgres-database-for-solid-tables.md)
- [0002 -- Credentials.dig over ENV](0002-credentials-dig-over-env.md)
