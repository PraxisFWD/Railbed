# One PostgreSQL database for Solid tables

Rails 8 gives Solid Queue, Solid Cache, and Solid Cable separate production databases. This application keeps their
tables in the primary database instead, so a job enqueued inside a transaction commits or rolls back with the data it
depends on. A separate queue database cannot offer that guarantee and adds connection pools, schema files, and
deployment steps. The cost is that heavy queue or cache traffic shares capacity with application queries; split a
database out again only when measurements show contention. The Solid schemas are ordinary migrations in `db/migrate`.
