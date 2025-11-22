defmodule DomainatrexAdvancedTest do
  use ExUnit.Case

  test "ip addresses in domain format" do
    # Tests for IPv4-like domains
    # Note: Currently, the library does not recognize this format
    # This test documents the current behavior
    assert Domainatrex.parse("192.168.1.1") ==
             {:error, "Cannot match: invalid domain"}
  end

  test "newer TLDs" do
    # Test newer TLDs that might have been added more recently
    assert Domainatrex.parse("myproject.dev") ==
             {:ok, %{domain: "myproject", subdomain: "", tld: "dev"}}

    assert Domainatrex.parse("myapp.app") ==
             {:ok, %{domain: "myapp", subdomain: "", tld: "app"}}

    assert Domainatrex.parse("mysite.tech") ==
             {:ok, %{domain: "mysite", subdomain: "", tld: "tech"}}
  end

  test "very long domain names" do
    # Test domains with long names
    long_domain = "thisisaveryverylongdomainnamethatpushestheboundaries"

    assert Domainatrex.parse("#{long_domain}.com") ==
             {:ok, %{domain: long_domain, subdomain: "", tld: "com"}}

    # Test with a long subdomain as well
    long_subdomain = "thisisaveryverylongsubdomainthatpushestheboundariesofwhatisallowed"

    assert Domainatrex.parse("#{long_subdomain}.#{long_domain}.com") ==
             {:ok, %{domain: long_domain, subdomain: long_subdomain, tld: "com"}}
  end

  test "edge cases with multiple dots" do
    # Test for domains with many dots
    assert Domainatrex.parse("a.b.c.d.example.com") ==
             {:ok, %{domain: "example", subdomain: "a.b.c.d", tld: "com"}}

    # Test extreme case with many subdomains
    assert Domainatrex.parse("a.b.c.d.e.f.g.example.com") ==
             {:ok, %{domain: "example", subdomain: "a.b.c.d.e.f.g", tld: "com"}}
  end

  test "path-like domains" do
    # Some domains might look like paths
    assert Domainatrex.parse("api.v1.service.com") ==
             {:ok, %{domain: "service", subdomain: "api.v1", tld: "com"}}
  end

  test "invalid input handling" do
    # Empty string
    assert Domainatrex.parse("") == {:error, "Cannot parse: invalid domain"}

    # Just a TLD with no domain
    assert Domainatrex.parse("com") == {:error, "Cannot parse: invalid domain"}

    # Domain with no TLD (just a name)
    assert Domainatrex.parse("localhost") == {:error, "Cannot parse: invalid domain"}

    # Domain with a trailing dot (technically valid in DNS but not commonly used)
    assert Domainatrex.parse("example.com.") == {:error, "Cannot match: invalid domain"}
  end

  test "internationalized domain names" do
    # Test Internationalized Domain Names (IDN) 
    # The library has mixed support for Unicode domains:
    # - Latin-based scripts with diacritics (like German umlauts) work
    # - Non-Latin scripts (like Chinese or Cyrillic) don't work
    # This test documents the current behavior

    # Example with German umlaut (works)
    assert Domainatrex.parse("käse.de") ==
             {:ok, %{domain: "käse", subdomain: "", tld: "de"}}

    # Example with Chinese characters (simplified) - doesn't work
    assert Domainatrex.parse("例子.中国") ==
             {:error, "Cannot match: invalid domain"}

    # Example with Cyrillic (Russian) - doesn't work
    assert Domainatrex.parse("пример.рф") ==
             {:error, "Cannot match: invalid domain"}

    # For full IDN support, domains should be converted to Punycode first
    # For example: "例子.中国" would become "xn--fsq.xn--fiqs8s"
  end

  test "domains with hyphens" do
    # Test domains with hyphens
    assert Domainatrex.parse("my-domain-name.com") ==
             {:ok, %{domain: "my-domain-name", subdomain: "", tld: "com"}}

    # Test domains that start with xn-- (Punycode for IDN)
    # Currently not supported in the public suffix list used by the library
    assert Domainatrex.parse("xn--80aswg.xn--p1ai") ==
             {:error, "Cannot match: invalid domain"}
  end
end
