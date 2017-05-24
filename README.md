# Domainatrex


### Domainatrex is a TLD parsing library for Elixir, using the Public Suffix list.

[![Build Status](https://travis-ci.org/Zensavona/domainatrex.svg?branch=master)](https://travis-ci.org/Zensavona/domainatrex) [![Inline docs](http://inch-ci.org/github/zensavona/domainatrex.svg)](http://inch-ci.org/github/zensavona/domainatrex) [![Coverage Status](https://coveralls.io/repos/Zensavona/domainatrex/badge.svg?branch=master&service=github)](https://coveralls.io/github/Zensavona/domainatrex?branch=master) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/Zensavona/domainatrex.svg)](https://beta.hexfaktor.org/github/Zensavona/domainatrex) [![hex.pm version](https://img.shields.io/hexpm/v/domainatrex.svg)](https://hex.pm/packages/domainatrex) [![hex.pm downloads](https://img.shields.io/hexpm/dt/domainatrex.svg)](https://hex.pm/packages/domainatrex) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

### [Read the docs](https://hexdocs.pm/domainatrex)



## Installation

Add the following to your `mix.exs`

```

defp deps do
  [{:domainatrex, "~> 2.0"}]

```

## Usage

`Domainatrex` should be able to handle all valid hostnames, it uses the [Public Suffix List](https://publicsuffix.org/list/) and is heavily inspired by the fantastic [Domainatrix](https://github.com/pauldix/domainatrix) library for Ruby

```
iex> Domainatrex.parse("someone.com")
{:ok, %{domain: "someone", subdomain: "", tld: "com"}}

iex> Domainatrex.parse("blog.someone.id.au")
{:ok, %{domain: "someone", subdomain: "blog", tld: "id.au"}}
```



## Changelog

### 1.0.1
- Fully update the tests to reflect changes in `2.0.0` (thanks for the PR @pbonney!)

### 2.0.0
- Change the API from returning explicit results to {:ok, result} or {:error, result}. This is to be more uniform with other libraries I use and for better `with` usage. Sorry if this fucks up your day.
