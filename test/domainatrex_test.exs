defmodule DomainatrexTest do
  use ExUnit.Case

  doctest Domainatrex

  test "another weird one" do
    assert Domainatrex.parse("zen.deca.jp") ==
             {:ok, %{domain: "zen", subdomain: "", tld: "deca.jp"}}
  end

  test "blogspot specifically" do
    assert Domainatrex.parse("zen.blogspot.com") ==
             {:ok, %{domain: "zen", subdomain: "", tld: "blogspot.com"}}
  end

  test "1 dot domains" do
    assert Domainatrex.parse("domainatrex.com") ==
             {:ok, %{domain: "domainatrex", subdomain: "", tld: "com"}}
  end

  test "2 dot domains" do
    assert Domainatrex.parse("zen.id.au") == {:ok, %{domain: "zen", subdomain: "", tld: "id.au"}}
  end

  test "subdomains" do
    assert Domainatrex.parse("my.blog.zen.id.au") ==
             {:ok, %{domain: "zen", subdomain: "my.blog", tld: "id.au"}}
  end

  test "s3" do
    # amazonaws.com is not in the list so it is parsed normally under `com` as a TLD.
    assert Domainatrex.parse("amazonaws.com") ==
             {:ok, %{domain: "amazonaws", subdomain: "", tld: "com"}}

    # s3.amazonaws.com IS in the public suffix list (private section), so it functions as a TLD.
    # Parsing it alone is like parsing "co.uk" - valid TLD, but invalid domain (no name).
    assert Domainatrex.parse("s3.amazonaws.com") == {:error, "Cannot parse: invalid domain"}

    # Because s3.amazonaws.com is the TLD, "zen" is the domain.
    assert Domainatrex.parse("zen.s3.amazonaws.com") ==
             {:ok, %{domain: "zen", subdomain: "", tld: "s3.amazonaws.com"}}
  end

  test "custom suffix" do
    assert Domainatrex.parse("s3.amazonaws.localhost") ==
             {:ok, %{domain: "amazonaws", subdomain: "s3", tld: "localhost"}}
  end

  ##  bd : https://en.wikipedia.org/wiki/.bd
  ## *.bd
  test "domains with wildcard" do
    assert Domainatrex.parse("www.techtunes.com.bd") ==
             {:ok, %{domain: "techtunes", subdomain: "www", tld: "com.bd"}}

    assert Domainatrex.parse("www.techtunes.bd") ==
             {:ok, %{domain: "techtunes", subdomain: "www", tld: "bd"}}

    assert Domainatrex.parse("mail.send.kawasaki.jp") ==
             {:ok, %{domain: "mail", subdomain: "", tld: "send.kawasaki.jp"}}

    assert Domainatrex.parse("www.send.kawasaki.jp") ==
             {:ok, %{domain: "www", subdomain: "", tld: "send.kawasaki.jp"}}

    assert Domainatrex.parse("www.elb.send.kawasaki.jp") ==
             {:ok, %{domain: "elb", subdomain: "www", tld: "send.kawasaki.jp"}}
  end

  test "nonsense" do
    assert Domainatrex.parse("nonsense") == {:error, "Cannot parse: invalid domain"}
  end

  test "valid public suffixes without domain" do
    ["ca.us", "fl.us", "or.us"]
    |> Enum.each(fn domain ->
      assert Domainatrex.parse(domain) == {:error, "Cannot parse: invalid domain"}
    end)
  end

  test "valid private suffixes without domain" do
    ["s3.amazonaws.com", "on.crisp.email"]
    |> Enum.each(fn domain ->
      assert Domainatrex.parse(domain) == {:error, "Cannot parse: invalid domain"}
    end)
  end

  test "exception rules" do
    # !city.kawasaki.jp is an exception rule.
    # city.kawasaki.jp is NOT a TLD, so TLD is kawasaki.jp and domain is city.
    assert Domainatrex.parse("city.kawasaki.jp") ==
             {:ok, %{domain: "city", subdomain: "", tld: "kawasaki.jp"}}

    # other.kawasaki.jp matches *.kawasaki.jp, so it IS a TLD.
    assert Domainatrex.parse("other.kawasaki.jp") == {:error, "Cannot parse: invalid domain"}

    # subdomains work correctly with exception
    assert Domainatrex.parse("foo.city.kawasaki.jp") ==
             {:ok, %{domain: "city", subdomain: "foo", tld: "kawasaki.jp"}}
  end

  # domains are case insensitive
  test "case insensitivity" do
    assert Domainatrex.parse("EXAMPLE.COM") ==
             {:ok, %{domain: "example", subdomain: "", tld: "com"}}

    assert Domainatrex.parse("WwW.GoOgLe.CoM") ==
             {:ok, %{domain: "google", subdomain: "www", tld: "com"}}
  end

  # unicode domains are supported
  test "unicode domains" do
    assert Domainatrex.parse("食狮.com.cn") ==
             {:ok, %{domain: "食狮", subdomain: "", tld: "com.cn"}}
  end
end
