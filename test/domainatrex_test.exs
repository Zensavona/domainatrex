defmodule DomainatrexTest do
  use ExUnit.Case
  doctest Domainatrex

  test "1 dot domains" do
    assert Domainatrex.parse("domainatrex.com") == %{domain: "domainatrex", subdomain: "", tld: "com"}
  end

  test "2 dot domains" do
    assert Domainatrex.parse("zen.id.au") == %{domain: "zen", subdomain: "", tld: "id.au"}
  end

  test "subdomains" do
    assert Domainatrex.parse("my.blog.zen.id.au") == %{domain: "zen", subdomain: "my.blog", tld: "id.au"}
  end
end
