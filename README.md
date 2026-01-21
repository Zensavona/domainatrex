# Domainatrex

> Domainatrex is a TLD parsing library for Elixir, using the Public Suffix list

[![hex.pm version](https://img.shields.io/hexpm/v/domainatrex.svg)](https://hex.pm/packages/domainatrex)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/domainatrex.svg)](https://hex.pm/packages/domainatrex)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

### [Read the docs](https://hexdocs.pm/domainatrex)

## Installation

Add the following to your `mix.exs`

```elixir
defp deps do
  [
    {:domainatrex, "~> 3.2"},
  ]
```

## Usage

`Domainatrex` parses host names using the
[Public Suffix List](https://publicsuffix.org/list/) and is heavily inspired by the fantastic
[Domainatrix](https://github.com/pauldix/domainatrix) library for Ruby

```elixir
iex> Domainatrex.parse("someone.com")
{:ok, %{domain: "someone", subdomain: "", tld: "com"}}

iex> Domainatrex.parse("blog.someone.id.au")
{:ok, %{domain: "someone", subdomain: "blog", tld: "id.au"}}

iex> Domainatrex.tld?("com")
true

iex> Domainatrex.tld?("someone.com")
false
```

## Configuration

For maximum performance, `Domainatrex` reads the list of all known top-level domains at compile
time. By default, the package will attempt to fetch the latest list of TLDs from the web. If
fetching fails (or is disabled), it falls back to a local copy. If the fallback file is also
missing, compilation will exit with an error.

You can configure this behavior in your `config.exs` as follows:

- `:fetch_latest`: Whether to fetch the latest public suffix list at compile time; default is `true`
- `:public_suffix_list_url`: A charlist URL to fetch the public suffix file from; default is
  `~c"https://publicsuffix.org/list/public_suffix_list.dat"`
- `:fallback_local_copy`: Path to a local suffix file used when fetching fails or is disabled;
  default is `"priv/public_suffix_list.dat"` included in the package
- `:custom_suffixes`: Additional suffixes to add beyond the public suffix file; default is `[]`
- `:icann_only`: When `true`, only include ICANN domains (excludes private domains like
  `s3.amazonaws.com`); default is `false`
- `:include_private`: When `false`, excludes private domains (same effect as `icann_only: true`);
  default is `true`

Here's a complete example of how you might customize this behavior in your `config.exs`:

```elixir
config :domainatrex,
  # Explicitly allow compile-time HTTP request to fetch the latest list of TLDs (default)
  fetch_latest: true,
  # Download the public suffix list from the official source
  public_suffix_list_url: ~c"https://publicsuffix.org/list/public_suffix_list.dat",
  fallback_local_copy: "priv/my_app_custom_suffix_list.dat",
  # Add custom suffix for com.be
  custom_suffixes: ["com.be"],
  # Include private domains (default)
  include_private: true
```

## Limitations

- **Expects host names only**: Pass a host name like `example.co.uk`, not a full URL. Use
  `URI.parse/1` to extract the host from a URL first.
- **IP addresses**: IPv4 addresses like `192.168.1.1` are not recognized as valid domains and
  will return an error.
- **Punycode**: Internationalized domain names (IDN) must be in Unicode form, not punycode.
  For example, `例子.中国` works, but `xn--fsq.xn--fiqs8s` does not.
- **Trailing/multiple dots**: Inputs with trailing dots (`example.com.`), leading dots
  (`.example.com`), or consecutive dots (`example..com`) are rejected as invalid.
