# Architecture

Starter map of this application. Replace every `[Replace: ...]` marker with facts about this codebase, and keep the
document short and stable. Name files and modules so readers can search for them; describe individual methods in code,
not here. Update it in the same change that alters what it says. [docs/README.md](docs/README.md) indexes the rest of the
documentation.

## Overview

[Replace: one paragraph on the problem this application solves and for whom. Describe the problem, not the stack.]

## Codemap

Rails conventions apply to everything not listed here.

### `app/models` -- domain data and rules

[Replace: the central models and the rules each owns.]

### `app/controllers` and `app/views` -- HTTP interface

[Replace: the entry points, the authentication boundary, and how views are composed (ViewComponent under
`app/components`).]

### `app/jobs` -- background work

Active Job on Solid Queue, in the primary database. [Replace: the jobs that exist and what triggers them.]

### `lib/credentials.rb` -- settings and secrets

The only place that reads `ENV`. See [configuration](docs/guides/configuration.md).

### `[Replace: another significant directory]` -- [purpose]

[Replace: one or two sentences.]

## Invariants

Rules that hold across the codebase. Include absences: things that deliberately do not exist.

- Settings and secrets are read with `Credentials.dig`; no `ENV` access in `app/`, `lib/`, or `config/initializers/`.
- One PostgreSQL database holds application, Solid Queue, Solid Cache, and Solid Cable tables. See
  [ADR 0001](docs/adr/0001-one-postgres-database-for-solid-tables.md).
- There are no `queue`, `cache`, or `cable` database entries and no `db/*_schema.rb` files.
- [Replace: an invariant of this application, such as who may write a given table.]
- [Replace: an absence, such as "no direct calls to the payment provider outside `app/gateways`".]

## Boundaries

### Public interface and internals

- [Replace: what is public (routes, API, events) and what is internal.]

### Dependency rules

- [Replace: which layers may call which. Example: controllers call models and services; models never call controllers.]
- [Replace: what shared code may and may not depend on.]

## Cross-Cutting Concerns

### Errors and observability

[Replace: how errors surface, where they are reported, and how logs are structured.]

### Authentication and authorization

[Replace: where identity is established and where permissions are checked.]

### Configuration

`Credentials.dig` reads a non-blank environment variable first and then the current environment's Rails credentials.
See [configuration](docs/guides/configuration.md).
