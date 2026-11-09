# Documentation

Start here. Each topic lives in one file; [AGENTS.md](../AGENTS.md) points here instead of repeating it.

## Architecture and domain

- [ARCHITECTURE.md](../ARCHITECTURE.md) -- codemap, invariants, boundaries, and dependency rules
- [DOMAIN.md](DOMAIN.md) -- business workflows, relationships, and compliance context

## Guides

- [Configuration](guides/configuration.md) -- `Credentials.dig`, environment overrides, and Rails credentials
- [Testing and quality](guides/testing.md) -- the quality commands and the RubyCritic rating gate

## Decisions

- [Architecture decision records](adr/README.md) -- when to write one, numbering, and the template
- [0001 -- One PostgreSQL database for Solid tables](adr/0001-one-postgres-database-for-solid-tables.md)
- [0002 -- Credentials.dig over ENV](adr/0002-credentials-dig-over-env.md)

Run `bin/docs-check` after changing Markdown links or moving documentation. It runs in `bin/ci` and in GitHub Actions.
Add each new page to this index; `bin/docs-check` fails on a page under `docs/` that it does not link.
