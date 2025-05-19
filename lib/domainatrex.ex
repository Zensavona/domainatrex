defmodule Domainatrex do
  @moduledoc """
  Documentation for Domainatrex

  ## Examples
      iex> Domainatrex.parse("someone.com")
      {:ok, %{domain: "someone", subdomain: "", tld: "com"}}

      iex> Domainatrex.parse("blog.someone.id.au")
      {:ok, %{domain: "someone", subdomain: "blog", tld: "id.au"}}

      iex> Domainatrex.parse("zen.s3.amazonaws.com")
      {:ok, %{domain: "s3", subdomain: "zen", tld: "amazonaws.com"}}

  """

  require Logger

  @fallback_local_copy Application.compile_env(
                         :domainatrex,
                         :fallback_local_copy,
                         Application.app_dir(:domainatrex, "priv/public_suffix_list.dat")
                       )
  @fetch_latest Application.compile_env(:domainatrex, :fetch_latest, true)
  @public_suffix_list nil

  :inets.start()
  :ssl.start()

  if not File.exists?(@fallback_local_copy) do
    exit("The fallback file does not exists: #{@fallback_local_copy}")
  end

  with true <- @fetch_latest,
       public_suffix_list_url <-
         Application.compile_env(
           :domainatrex,
           :public_suffix_list_url,
           ~c"https://publicsuffix.org/list/public_suffix_list.dat"
         ),
       {:ok, {_, _, string}} <- :httpc.request(:get, {public_suffix_list_url, []}, [], []) do
    @public_suffix_list to_string(string)
  else
    _ ->
      case File.read(@fallback_local_copy) do
        {:ok, string} ->
          if @fetch_latest do
            IO.puts("""
              Could not read the public suffix list from the internet,
              trying to read from the backup at #{@fallback_local_copy}
            """)
          end

          @public_suffix_list string

        _ ->
          exit(
            "Could not read the public suffix list, please make sure that you either have an internet connection or #{@fallback_local_copy} exists"
          )
      end
  end

  custom_suffixes = Application.compile_env(:domainatrex, :custom_suffixes, [])

  string =
    if Application.compile_env(:domainatrex, :icann_only, false) or
         not Application.compile_env(:domainatrex, :include_private, true) do
      @public_suffix_list
      |> String.split("// ===END ICANN DOMAINS===")
      |> List.first()
    else
      @public_suffix_list
    end

  suffixes =
    string
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.reject(&String.contains?(&1, "//"))
    |> Enum.concat(custom_suffixes)
    |> Enum.map(&String.split(&1, "."))
    |> Enum.map(&Enum.reverse/1)
    |> Enum.sort_by(&length/1)
    |> Enum.reverse()

  Enum.each(suffixes, fn suffix ->
    if List.last(suffix) == "*" do
      case length(suffix) do
        2 ->
          defp match([unquote(Enum.at(suffix, 0)), a]) do
            format_response([unquote(Enum.at(suffix, 0))], [a])
          end

          defp match([unquote(Enum.at(suffix, 0)), a, b]) do
            format_response([unquote(Enum.at(suffix, 0))], [a, b])
          end

          defp match([unquote(Enum.at(suffix, 0)) | _] = args) do
            format_response(Enum.slice(args, 0, 2), Enum.slice(args, 2, 10))
          end

        3 ->
          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a, b]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a, b])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)) | _] = args) do
            format_response(Enum.slice(args, 0, 3), Enum.slice(args, 3, 10))
          end

        4 ->
          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a, b]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a, b])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)) | _] = args) do
            format_response(Enum.slice(args, 0, 4), Enum.slice(args, 4, 10))
          end

        5 ->
          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a, b]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a, b])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)) | _] = args) do
            format_response(Enum.slice(args, 0, 5), Enum.slice(args, 5, 10))
          end

        6 ->
          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a, b]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a, b])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)) | _] = args) do
            format_response(Enum.slice(args, 0, 6), Enum.slice(args, 6, 10))
          end

        7 ->
          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)), a, b]) do
            format_response([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1))], [a, b])
          end

          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)) | _] = args) do
            format_response(Enum.slice(args, 0, 7), Enum.slice(args, 7, 10))
          end
      end
    else
      case length(suffix) do
        1 ->
          defp match([unquote(Enum.at(suffix, 0)) | tail] = args) do
            format_response([Enum.at(args, 0)], tail)
          end

        2 ->
          defp match([unquote(Enum.at(suffix, 0)), unquote(Enum.at(suffix, 1)) | tail] = args) do
            format_response([Enum.at(args, 0), Enum.at(args, 1)], tail)
          end

        3 ->
          defp match(
                 [
                   unquote(Enum.at(suffix, 0)),
                   unquote(Enum.at(suffix, 1)),
                   unquote(Enum.at(suffix, 2)) | tail
                 ] = args
               ) do
            format_response([Enum.at(args, 0), Enum.at(args, 1), Enum.at(args, 2)], tail)
          end

        4 ->
          defp match(
                 [
                   unquote(Enum.at(suffix, 0)),
                   unquote(Enum.at(suffix, 1)),
                   unquote(Enum.at(suffix, 2)),
                   unquote(Enum.at(suffix, 3)) | tail
                 ] = args
               ) do
            format_response(
              [Enum.at(args, 0), Enum.at(args, 1), Enum.at(args, 2), Enum.at(args, 3)],
              tail
            )
          end

        5 ->
          defp match(
                 [
                   unquote(Enum.at(suffix, 0)),
                   unquote(Enum.at(suffix, 1)),
                   unquote(Enum.at(suffix, 2)),
                   unquote(Enum.at(suffix, 3)),
                   unquote(Enum.at(suffix, 4)) | tail
                 ] = args
               ) do
            format_response(
              [
                Enum.at(args, 0),
                Enum.at(args, 1),
                Enum.at(args, 2),
                Enum.at(args, 3),
                Enum.at(args, 4)
              ],
              tail
            )
          end

        6 ->
          defp match(
                 [
                   unquote(Enum.at(suffix, 0)),
                   unquote(Enum.at(suffix, 1)),
                   unquote(Enum.at(suffix, 2)),
                   unquote(Enum.at(suffix, 3)),
                   unquote(Enum.at(suffix, 4)),
                   unquote(Enum.at(suffix, 5)) | tail
                 ] = args
               ) do
            format_response(
              [
                Enum.at(args, 0),
                Enum.at(args, 1),
                Enum.at(args, 2),
                Enum.at(args, 3),
                Enum.at(args, 4),
                Enum.at(args, 5)
              ],
              tail
            )
          end

        7 ->
          defp match(
                 [
                   unquote(Enum.at(suffix, 0)),
                   unquote(Enum.at(suffix, 1)),
                   unquote(Enum.at(suffix, 2)),
                   unquote(Enum.at(suffix, 3)),
                   unquote(Enum.at(suffix, 4)),
                   unquote(Enum.at(suffix, 5)),
                   unquote(Enum.at(suffix, 6)) | tail
                 ] = args
               ) do
            format_response(
              [
                Enum.at(args, 0),
                Enum.at(args, 1),
                Enum.at(args, 2),
                Enum.at(args, 3),
                Enum.at(args, 4),
                Enum.at(args, 5),
                Enum.at(args, 6)
              ],
              tail
            )
          end

        _ ->
          {:error, "There exists a domain in the list which contains more than 7 dots: #{suffix}"}
      end
    end
  end)

  defp format_response(tld, domain) do
    with [domain | subdomains] <- domain do
      tld = tld |> Enum.reverse() |> Enum.join(".")
      subdomains = subdomains |> Enum.reverse() |> Enum.join(".")
      {:ok, %{domain: domain, subdomain: subdomains, tld: tld}}
    else
      _ -> {:error, "Cannot parse: invalid domain"}
    end
  end

  def parse(url) when is_binary(url) do
    case String.length(url) > 1 && String.contains?(url, ".") do
      true ->
        adjusted_url = url |> String.split(".") |> Enum.reverse()
        match(adjusted_url)

      _ ->
        {:error, "Cannot parse: invalid domain"}
    end
  end

  defp match(_it) do
    {:error, "Cannot match: invalid domain"}
  end
end
