defmodule Domainatrex do
  @moduledoc """
  Domainatrex splits a host name into `{subdomain, domain, tld}` using the
  [Public Suffix List](https://publicsuffix.org/).

  Many domain parsing implementations are incorrect if they assume "the TLD is
  always the last label". For example, `id.au` is a public suffix, so in
  `blog.someone.id.au` the registrable domain is `someone` and the TLD is `id.au`.
  Domainatrex uses the Public Suffix List (including wildcard and exception
  rules) to make this split correctly.

  Use this library when you need:

  - Deterministic, PSL-correct splitting for analytics, cookie scoping, tenant
    routing, allow/deny rules, or normalization.
  - Support for "private" suffixes (like `s3.amazonaws.com`) when enabled via
    configuration.

  Domainatrex expects a host name (e.g. `example.co.uk`), not a full URL. If you
  have a URL, extract its host first (for example via Elixir's `URI.parse/1`).
  """

  @fetch_latest Application.compile_env(:domainatrex, :fetch_latest, true)

  :inets.start()
  :ssl.start()

  @public_suffix_list (with true <- @fetch_latest,
                            public_suffix_list_url <-
                              Application.compile_env(
                                :domainatrex,
                                :public_suffix_list_url,
                                ~c"https://publicsuffix.org/list/public_suffix_list.dat"
                              ),
                            {:ok, {_, _, string}} <-
                              :httpc.request(:get, {public_suffix_list_url, []}, [],
                                body_format: :binary
                              ) do
                         string
                       else
                         _ ->
                           default_file =
                             Application.app_dir(:domainatrex, "priv/public_suffix_list.dat")

                           fallback_local_copy =
                             Application.compile_env(
                               :domainatrex,
                               :fallback_local_copy,
                               default_file
                             )

                           case File.read(fallback_local_copy) do
                             {:ok, string} ->
                               if @fetch_latest do
                                 IO.puts("""
                                 Could not read the public suffix list from the internet,
                                 trying to read from the backup at #{fallback_local_copy}
                                 """)
                               end

                               string

                             _ ->
                               exit("""
                               Could not read the public suffix list,
                               please make sure that you either have an internet connection
                               or #{fallback_local_copy} exists
                               """)
                           end
                       end)

  custom_suffixes = Application.compile_env(:domainatrex, :custom_suffixes, [])

  suffixes_string =
    if Application.compile_env(:domainatrex, :icann_only, false) or
         not Application.compile_env(:domainatrex, :include_private, true) do
      @public_suffix_list
      |> String.split("// ===END ICANN DOMAINS===")
      |> List.first()
    else
      @public_suffix_list
    end

  parsed_suffixes =
    suffixes_string
    |> String.split("\n")
    |> Enum.reject(&(&1 == "" or String.contains?(&1, "//")))
    |> Enum.concat(custom_suffixes)
    |> Enum.map(&(&1 |> String.split(".") |> Enum.reverse()))

  @trie Domainatrex.TrieBuilder.build(parsed_suffixes)

  @doc """
  Parses a host name into `{subdomain, domain, tld}` using the public suffix list.

  Returns `{:ok, %{domain: domain, subdomain: subdomain, tld: tld}}` when the host
  contains a registrable domain, otherwise returns `{:error, reason}`.

  Domain labels are treated case-insensitively.

  ## Examples

      iex> Domainatrex.parse("someone.com")
      {:ok, %{domain: "someone", subdomain: "", tld: "com"}}

      iex> Domainatrex.parse("blog.someone.id.au")
      {:ok, %{domain: "someone", subdomain: "blog", tld: "id.au"}}

      iex> Domainatrex.parse("zen.s3.amazonaws.com")
      {:ok, %{domain: "zen", subdomain: "", tld: "s3.amazonaws.com"}}

  """
  def parse(url) when is_binary(url) do
    # domains are case insensitive
    url = String.downcase(url)

    if valid_host_input?(url) and String.contains?(url, ".") do
      parts = url |> String.split(".") |> Enum.reverse()

      case find_longest_match(parts, @trie) do
        {tld_parts, remaining_parts} ->
          format_response(tld_parts, remaining_parts)

        nil ->
          {:error, "Cannot match: invalid domain"}
      end
    else
      {:error, "Cannot parse: invalid domain"}
    end
  end

  @doc """
  Returns `true` when the given string is a public suffix (TLD) in the loaded public suffix list.

  ## Examples

      iex> Domainatrex.tld?("com")
      true

      iex> Domainatrex.tld?("id.au")
      true

      iex> Domainatrex.tld?("someone.com")
      false
  """
  def tld?(tld) when is_binary(tld) do
    # public suffixes are case insensitive
    tld = String.downcase(tld)

    if valid_host_input?(tld) do
      parts = tld |> String.split(".") |> Enum.reverse()

      case find_longest_match(parts, @trie) do
        {tld_parts, []} -> length(tld_parts) == length(parts)
        _ -> false
      end
    else
      false
    end
  end

  defp valid_host_input?(host) do
    host != "" and not String.starts_with?(host, ".") and not String.ends_with?(host, ".") and
      not String.contains?(host, "..")
  end

  defp find_longest_match(parts, trie), do: do_find(parts, trie, [], nil)

  defp do_find([], %{_end: true}, current_path, _last_match), do: {current_path, []}
  defp do_find([], _node, _current_path, last_match), do: last_match

  defp do_find([head | tail] = parts, node, current_path, last_match) do
    current_is_end = Map.get(node, :_end, false)
    new_last_match = if current_is_end, do: {current_path, parts}, else: last_match

    case Map.fetch(node, "!" <> head) do
      {:ok, _} ->
        {current_path, parts}

      :error ->
        exact_res =
          case Map.fetch(node, head) do
            {:ok, child} -> do_find(tail, child, [head | current_path], new_last_match)
            :error -> nil
          end

        wild_res =
          case Map.fetch(node, "*") do
            {:ok, child} -> do_find(tail, child, [head | current_path], new_last_match)
            :error -> nil
          end

        pick_better_match(exact_res, wild_res) || new_last_match
    end
  end

  defp pick_better_match(nil, nil), do: nil
  defp pick_better_match(a, nil), do: a
  defp pick_better_match(nil, b), do: b

  defp pick_better_match({path_a, _parts_a} = a, {path_b, _parts_b} = b) do
    if length(path_a) >= length(path_b), do: a, else: b
  end

  defp format_response(tld_parts, [domain | subdomains]) do
    tld = Enum.join(tld_parts, ".")
    subdomains = subdomains |> Enum.reverse() |> Enum.join(".")
    {:ok, %{domain: domain, subdomain: subdomains, tld: tld}}
  end

  defp format_response(_tld_parts, _domain_parts) do
    {:error, "Cannot parse: invalid domain"}
  end
end
