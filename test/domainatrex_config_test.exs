defmodule DomainatrexConfigTest do
  use ExUnit.Case

  # Note: Since configuration is loaded at compile time, 
  # we can't easily test different configurations in a single test run.
  # These tests are more for documentation purposes.
  
  test "current configuration works" do
    # This just ensures the basic functionality works with the current config
    assert Domainatrex.parse("example.com") == 
      {:ok, %{domain: "example", subdomain: "", tld: "com"}}
  end
  
  test "custom suffixes" do
    # The test config adds 'localhost' as a custom suffix
    # This demonstrates how custom suffixes can be used
    # (Test config is loaded in config/config.exs for :test environment)
    assert Domainatrex.parse("myapp.localhost") == 
      {:ok, %{domain: "myapp", subdomain: "", tld: "localhost"}}
      
    assert Domainatrex.parse("sub.myapp.localhost") == 
      {:ok, %{domain: "myapp", subdomain: "sub", tld: "localhost"}}
  end
  
  @doc """
  For reference, here are the available configuration options:
  
  config :domainatrex,
    # Whether to fetch the latest public suffix list at compile time
    fetch_latest: true,
    
    # The URL to fetch the public suffix list from
    public_suffix_list_url: 'https://publicsuffix.org/list/public_suffix_list.dat',
    
    # The local file to use as a fallback if fetching fails
    fallback_local_copy: "priv/public_suffix_list.dat",
    
    # Custom suffixes to add
    custom_suffixes: ["custom.tld"],
    
    # Whether to only include ICANN domains (defaults to false)
    icann_only: false,
    
    # Whether to include private domains (defaults to true)
    include_private: true
  """
  test "documentation of configuration options" do
    # This test doesn't actually test anything, it just documents the options
    assert true
  end
end