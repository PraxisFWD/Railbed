# Credentials.dig over ENV

Application code reads settings and secrets only through `Credentials.dig`, which returns a non-blank environment
variable when one is set and otherwise the current environment's Rails credentials. `ENV` is read nowhere else, and
`Quality/NoDirectEnv` enforces it. Every setting therefore has one name, one override rule, and one place to stub in
specs, at the price of a thin accessor that returns scalar strings and must be parsed where used. See
[configuration](../guides/configuration.md).
