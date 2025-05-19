# Changelog

## 3.0.5

- FIX: when download fails use local fallback [@Sgiath](https://github.com/sgiath)
- FEAT: add update script [@Sgiath](https://github.com/sgiath)
- Update dependencies [@Sgiath](https://github.com/Sgiath)
- Add Nix flake setup [@Sgiath](https://github.com/Sgiath)
- Add LICENSE file [@Sgiath](https://github.com/Sgiath)

## 3.0.4

- Fix issue with new, even longer domains from public_suffix_list.dat [@Sgiath](https://github.com/Sgiath)

## 3.0.3

- Fix issue with new, longer domains from public_suffix_list.dat [@fabiokr](https://github.com/fabiokr)

## 3.0.1

- Resolve warnings about SSL and `Mix.Config` being deprecated.

## 3.0.0

- Breaking change: default to including private domains. `:include_private == false` is still
  respected (but defaults to false), and a new env var `:icann_only` is added and defaults to
  false.

## 2.4.0

- Support disabling compile time http request with `:fetch_latest` config (thanks @s3cur3 for
  the PR!)

## 2.3.0

- Bump deps

## 2.2.0

- Use `Logger` for logging

## 2.1.4

- Pin a version of `nimble_parsec` to fix a compilation error on `makeup` (`makeup` has fixed
  this downstream, so when `ex_doc` updates `makeup`, this will no longer be required)

## 2.1.3

- Merge a couple of minor PRs

## 2.1.2

- Improve tests and docs slightly

## 2.1.1

- Privatize `Domainatrex.match/n` and `Domainatrex.format_response/2` as they are only ever
  intended for internal use

## 2.1.0

- Better handle private domains. Private domains like `*.s3.amazonaws.com` are technically
  classed as TLDs (to my understanding?), it doesn't make a lot of sense to parse them this way.
- Fetch a new copy of the public suffix list from The Internet on compile, falling back to a
  (now updated!) local copy.

## 2.0.0

- Change the API from returning explicit results to {:ok, result} or {:error, result}. This is to
  be more uniform with other libraries I use and for better `with` usage. Sorry if this fucks up
  your day.

## 1.0.1

- Fully update the tests to reflect changes in `2.0.0` (thanks for the PR @pbonney!)
