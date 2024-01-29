# Domainatrex

> Domainatrex is a TLD parsing library for Elixir, using the Public Suffix list

[![hex.pm version](https://img.shields.io/hexpm/v/domainatrex.svg)](https://hex.pm/packages/domainatrex) [![hex.pm downloads](https://img.shields.io/hexpm/dt/domainatrex.svg)](https://hex.pm/packages/domainatrex) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

### [Read the docs](https://hexdocs.pm/domainatrex)

## Installation

Add the following to your `mix.exs`

```elixir
defp deps do
  [
    {:domainatrex, "~> 3.0.4"},
  ]
```

## Usage

`Domainatrex` should be able to handle all valid hostnames, it uses the
[Public Suffix List](https://publicsuffix.org/list/) and is heavily inspired by the fantastic
[Domainatrix](https://github.com/pauldix/domainatrix) library for Ruby

```elixir
iex> Domainatrex.parse("someone.com")
{:ok, %{domain: "someone", subdomain: "", tld: "com"}}

iex> Domainatrex.parse("blog.someone.id.au")
{:ok, %{domain: "someone", subdomain: "blog", tld: "id.au"}}
```

## Configuration

For maximum performance, `Domainatrex` reads the list of all known top-level domains at compile
time. Likewise, by default, the package will attempt to fetch the latest list of TLDs from the
web before falling back to a local (potentially out of date) copy. You can configure this behavior
in your `config.exs` as follows:

- `:fetch_latest`: A Boolean flag to determine whether `Domainatrex` should try to fetch the
  latest list of public suffixes at compile time; default is `true`
- `:public_suffix_list_url`: A charlist URL to the latest public suffix file that `Domainatrex`
  will try to fetch at compile time; default is
  `'https://raw.githubusercontent.com/publicsuffix/list/master/public_suffix_list.dat'`
- `:fallback_local_copy`: The path to the local suffix file that `Domainatrex` will use if it
  wasn't able to fetch a fresh file from the URL, or if fetching updated files was disabled;
  default is the `"lib/public_suffix_list.dat"` file included in the package.

Here's a complete example of how you might customize this behavior in your `config.exs`:

```elixir
config :domainatrex,
  # Explicitly allow compile-time HTTP request to fetch the latest list of TLDs (default)
  fetch_latest: true,
  # Download the public suffix list from the official source (not necessarily tested with Domainatrex!)
  public_suffix_list_url: 'https://publicsuffix.org/list/public_suffix_list.dat',
  fallback_local_copy: "priv/my_app_custom_suffix_list.dat"
```
