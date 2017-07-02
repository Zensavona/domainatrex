defmodule DomainatrexTest do
  use ExUnit.Case
  doctest Domainatrex

  test "1 dot domains" do
    assert Domainatrex.parse("domainatrex.com") == {:ok, %{domain: "domainatrex", subdomain: "", tld: "com"}}
  end

  test "2 dot domains" do
    assert Domainatrex.parse("zen.id.au") == {:ok, %{domain: "zen", subdomain: "", tld: "id.au"}}
  end

  test "subdomains" do
    assert Domainatrex.parse("my.blog.zen.id.au") == {:ok, %{domain: "zen", subdomain: "my.blog", tld: "id.au"}}
  end

  test "s3" do
   assert Domainatrex.parse("s3.amazonaws.com") == {:ok, %{domain: "amazonaws", subdomain: "s3", tld: "com"}}
  end

 test "nonsense" do
   assert Domainatrex.parse("nonsense") == {:error, "Cannot parse: invalid domain"}
 end
end
