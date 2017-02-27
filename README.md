# Domainatrex


### Elixtagram is a simple Instagram client for Elixir.

[![Build Status](https://travis-ci.org/Zensavona/elixtagram.svg?branch=master)](https://travis-ci.org/Zensavona/elixtagram) [![Inline docs](http://inch-ci.org/github/zensavona/elixtagram.svg)](http://inch-ci.org/github/zensavona/elixtagram) [![Coverage Status](https://coveralls.io/repos/Zensavona/elixtagram/badge.svg?branch=master&service=github)](https://coveralls.io/github/Zensavona/elixtagram?branch=master) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/Zensavona/elixtagram.svg)](https://beta.hexfaktor.org/github/Zensavona/elixtagram) [![hex.pm version](https://img.shields.io/hexpm/v/elixtagram.svg)](https://hex.pm/packages/elixtagram) [![hex.pm downloads](https://img.shields.io/hexpm/dt/elixtagram.svg)](https://hex.pm/packages/elixtagram) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

### [Read the docs](https://hexdocs.pm/domainatrex)



## Installation

Add the following to your `mix.exs`

```

defp deps do
  [{:domainatrex, "~> 1.0.0"}]

```

## Usage

`Domainatrex` should be able to handle all valid hostnames, it uses the [Public Suffix List](https://publicsuffix.org/list/) and is heavily inspired by the fantastic [Domainatrix](https://github.com/pauldix/domainatrix) library for Ruby

```
iex> Domainatrex.parse("someone.com")
%{domain: "someone", subdomain: "", tld: "com"}

iex> Domainatrex.parse("blog.someone.id.au")
%{domain: "someone", subdomain: "blog", tld: "id.au"}
```



## Changelog
