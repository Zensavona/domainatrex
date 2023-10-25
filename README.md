# Domainatrex


### Domainatrex is a TLD parsing library for Elixir, using the Public Suffix list.

[![Build Status](https://travis-ci.org/Zensavona/domainatrex.svg?branch=master)](https://travis-ci.org/Zensavona/domainatrex) [![Inline docs](http://inch-ci.org/github/zensavona/domainatrex.svg)](http://inch-ci.org/github/zensavona/domainatrex) [![Coverage Status](https://coveralls.io/repos/Zensavona/domainatrex/badge.svg?branch=master&service=github)](https://coveralls.io/github/Zensavona/domainatrex?branch=master) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/Zensavona/domainatrex.svg)](https://beta.hexfaktor.org/github/Zensavona/domainatrex) [![hex.pm version](https://img.shields.io/hexpm/v/domainatrex.svg)](https://hex.pm/packages/domainatrex) [![hex.pm downloads](https://img.shields.io/hexpm/dt/domainatrex.svg)](https://hex.pm/packages/domainatrex) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

### [Read the docs](https://hexdocs.pm/domainatrex)



## Installation

Add the following to your `mix.exs`

```

defp deps do
  [{:domainatrex, "~> 3.0.3"}]

```

## Usage

`Domainatrex` should be able to handle all valid hostnames, it uses the [Public Suffix List](https://publicsuffix.org/list/) and is heavily inspired by the fantastic [Domainatrix](https://github.com/pauldix/domainatrix) library for Ruby

```
iex> Domainatrex.parse("someone.com")
{:ok, %{domain: "someone", subdomain: "", tld: "com"}}

iex> Domainatrex.parse("blog.someone.id.au")
{:ok, %{domain: "someone", subdomain: "blog", tld: "id.au"}}
```

## Configuration

For maximum performance, `Domainatrex` reads the list of all known top-level domains at compile time.
Likewise, by default, the package will attempt to fetch the latest list of TLDs from the web before
falling back to a local (potentially out of date) copy. You can configure this behavior in your
`config.exs` as follows:

- `:fetch_latest`: A Boolean flag to determine whether `Domainatrex` should try to fetch the latest
  list of public suffixes at compile time; default is `true`
- `:public_suffix_list_url`: A charlist URL to the latest public suffix file that `Domainatrex` will
   try to fetch at compile time; default is
   `'https://raw.githubusercontent.com/publicsuffix/list/master/public_suffix_list.dat'`
- `:fallback_local_copy`: The path to the local suffix file that `Domainatrex` will use if it wasn't
  able to fetch a fresh file from the URL, or if fetching updated files was disabled; default is
  the `"lib/public_suffix_list.dat"` file included in the package.

Here's a complete example of how you might customize this behavior in your `confix.exs`:

```elixir
config :domainatrex,
  # Explicitly allow compile-time HTTP request to fetch the latest list of TLDs (default)
  fetch_latest: true,
  # Download the public suffix list from the official source (not necessarily tested with Domainatrex!)
  public_suffix_list_url: 'https://publicsuffix.org/list/public_suffix_list.dat',
  fallback_local_copy: "priv/my_app_custom_suffix_list.dat"
```

## Changelog

### 3.0.3
- Fix issue with new, longer domains from public_suffix_list.dat
### 3.0.1
- Resolve warnings about SSL and `Mix.Config` being deprecated.
### 3.0.0
- Breaking change: default to including private domains. `:include_private == false` is still respected (but defaults to false), and a new env var `:icann_only` is added and defaults to false.
### 2.4.0
- Support disabling compile time http request with `:fetch_latest` config (thanks @s3cur3 for the PR!)
### 2.3.0
- Bump deps
### 2.2.0
- Use `Logger` for logging

### 2.1.4
- Pin a version of `nimble_parsec` to fix a compilation error on `makeup` (`makeup` has fixed this downstream, so when `ex_doc` updates `makeup`, this will no longer be required)

### 2.1.3
- Merge a couple of minor PRs

### 2.1.2
- Improve tests and docs slightly

### 2.1.1
- Privatise `Domainatrex.match/n` and `Domainatrex.format_response/2` as they are only ever intended for internal use

### 2.1.0
- Better handle private domains. Private domains like `*.s3.amazonaws.com` are technically classed as TLDs (to my understanding?), it doesn't make a lot of sense to parse them this way.
- Fetch a new copy of the public suffix list from The Internet on compile, falling back to a (now updated!) local copy.

### 2.0.0
- Change the API from returning explicit results to {:ok, result} or {:error, result}. This is to be more uniform with other libraries I use and for better `with` usage. Sorry if this fucks up your day.

### 1.0.1
- Fully update the tests to reflect changes in `2.0.0` (thanks for the PR @pbonney!)
