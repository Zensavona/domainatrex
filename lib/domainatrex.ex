defmodule Domainatrex do
  @moduledoc """
  Documentation for Domainatrex.
  """
  @public_suffix_list_url 'https://raw.githubusercontent.com/publicsuffix/list/master/public_suffix_list.dat'
  @public_suffix_list nil

  :inets.start
  :ssl.start

  case :httpc.request(:get, {@public_suffix_list_url, []}, [], []) do
    {:ok, {_, _, string}} ->
      @public_suffix_list to_string(string)
    _ ->
      case File.read "lib/public_suffix_list.dat" do
        {:ok, string} ->
          IO.puts "[Domainatrex] Error: Could not read the public suffix list from the internet, trying to read from the backup at lib/public_suffix_list.dat"
          @public_suffix_list string
        _ ->
          IO.puts "[Domainatrex] Error: Could not read the public suffix list, please make sure that you either have an internet connection or lib/public_suffix_list.dat exists"
          @public_suffix_list nil
      end
  end

  string = @public_suffix_list |> String.split("// ===END ICANN DOMAINS===") |> List.first
  custom_suffixes = Application.get_env(:domainatrex, :custom_suffixes, [])
  suffixes =
    string
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.reject(&(String.contains?(&1, "//")))
    |> Enum.reject(&(String.contains?(&1, "*")))
    |> Enum.concat(custom_suffixes)
    |> Enum.map(&(String.split(&1, ".")))
    |> Enum.map(&Enum.reverse/1)
    |> Enum.sort_by(&length/1)
    |> Enum.reverse

  Enum.each(suffixes, fn(suffix) ->
    case length(suffix) do
      1 ->
        defp match([unquote(Enum.at(suffix,0)) | tail] = args) do
          {:ok, format_response([Enum.at(args, 0)], tail)}
        end
      2 ->
        defp match([unquote(Enum.at(suffix,0)), unquote(Enum.at(suffix,1)) | tail] = args) do
          {:ok, format_response([Enum.at(args, 0), Enum.at(args, 1)], tail)}
        end
      3 ->
        defp match([unquote(Enum.at(suffix,0)), unquote(Enum.at(suffix,1)), unquote(Enum.at(suffix,2)) | tail] = args) do
          {:ok, format_response([Enum.at(args, 0), Enum.at(args, 1), Enum.at(args, 2)], tail)}
        end
      4 ->
        defp match([unquote(Enum.at(suffix,0)), unquote(Enum.at(suffix,1)), unquote(Enum.at(suffix,2)), unquote(Enum.at(suffix,3)) | tail] = args) do
          {:ok, format_response([Enum.at(args, 0), Enum.at(args, 1), Enum.at(args, 2), Enum.at(args, 3)], tail)}
        end
      5 ->
        defp match([unquote(Enum.at(suffix,0)), unquote(Enum.at(suffix,1)), unquote(Enum.at(suffix,2)), unquote(Enum.at(suffix,3)), unquote(Enum.at(suffix,4)) | tail] = args) do
          {:ok, format_response([Enum.at(args, 0), Enum.at(args, 1), Enum.at(args, 2), Enum.at(args, 3), Enum.at(args, 4)], tail)}
        end
      _ ->
        {:error, "There exists a domain in the list which contains more than 5 dots: #{suffix}"}
    end
  end)

  defp format_response(tld, domain) do
    [domain | subdomains] = domain
    tld = tld |> Enum.reverse |> Enum.join(".")
    subdomains = subdomains |> Enum.reverse |> Enum.join(".")
    %{domain: domain, subdomain: subdomains, tld: tld}
  end

  @doc """
  ## Examples
      iex> Domainatrex.parse("someone.com")
      {:ok, %{domain: "someone", subdomain: "", tld: "com"}}

      iex> Domainatrex.parse("blog.someone.id.au")
      {:ok, %{domain: "someone", subdomain: "blog", tld: "id.au"}}

      iex> Domainatrex.parse("zen.s3.amazonaws.com")
      {:ok, %{domain: "amazonaws", subdomain: "zen.s3", tld: "com"}}
  """
  def parse(url) do
    case String.length(url) > 1 && String.contains?(url, ".") do
      true ->
        adjusted_url = url |> String.split(".") |> Enum.reverse
        match(adjusted_url)
      _ ->
        {:error, "Cannot parse: invalid domain"}
    end
  end

  defp match(_it) do
    {:error, "Cannot match: invalid domain"}
  end
end
