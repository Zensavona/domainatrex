# Guide to Domainatrex library

## Project Overview

Domainatrex is a pure Elixir library that parses domain names into subdomain, domain, and TLD parts using the Mozilla Public Suffix List. It handles multi-part TLDs (`co.uk`), wildcard rules (`*.bd`), exception rules (`!city.kawasaki.jp`), and private domains (`s3.amazonaws.com`).

## Build & Test Commands

```bash
mix test              # Run all tests
mix check             # Run all checks (formatter, docs, unused deps)
mix format            # Format code
```

## Architecture

### Core Modules

- **`lib/domainatrex.ex`** - Main API with `parse/1` and `tld?/1` functions
- **`lib/trie.ex`** - Internal trie builder for efficient suffix lookups

### Data

- **`priv/public_suffix_list.dat`** - Mozilla Public Suffix List, fetched at compile time

### Compile-Time Behavior

The library fetches the latest PSL from publicsuffix.org at compile time and builds a trie data structure. Configuration in `config/config.exs`:

- `fetch_latest: true` - Fetch PSL at compile time (disable for offline builds)
- `icann_only: false` - Set true to exclude private domains
- `custom_suffixes: []` - Add custom TLDs (test env adds `localhost`)

**Configuration changes require recompilation** - not hot-reloadable.

### Algorithm

1. Normalize to lowercase, split on dots, reverse
2. Traverse trie: exact match → wildcard `*` → exception `!label`
3. Return longest matched suffix as TLD

## Testing

Tests in `test/`:
- `domainatrex_test.exs` - Core parsing (multi-dot TLDs, subdomains, wildcards)
- `domainatrex_config_test.exs` - Configuration and custom suffixes
- `domainatrex_advanced_test.exs` - Edge cases, Unicode, invalid input

Run single test: `mix test test/domainatrex_test.exs:42`

## Development Environment

Uses Nix flake + direnv (optional). Tool versions in `.tool-versions` (Elixir 1.19.3, Erlang 28.1.1).

## No Runtime Dependencies

Only uses Erlang stdlib (`logger`, `inets`, `ssl`). All mix dependencies are dev-only.
