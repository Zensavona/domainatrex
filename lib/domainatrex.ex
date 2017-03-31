defmodule Domainatrex do
  @moduledoc """
  Documentation for Domainatrex.
  """

  case File.read "lib/public_suffix_list.dat" do
    {:ok, string} ->
      suffixes =
        string
        |> String.split("\n")
        |> Enum.reject(&(&1 == ""))
        |> Enum.reject(&(String.contains?(&1, "//")))
        |> Enum.reject(&(String.contains?(&1, "*")))
        |> Enum.map(&(String.split(&1, ".")))
        |> Enum.map(&Enum.reverse/1)
        |> Enum.sort_by(&length/1)
        |> Enum.reverse

      Enum.each(suffixes, fn(suffix) ->
        case length(suffix) do
          1 ->
            def match([unquote(Enum.at(suffix,0)) | tail] = args) do
               tld = [Enum.at(args, 0)]
               Domainatrex.format_response(tld, tail)
            end
          2 ->
            def match([unquote(Enum.at(suffix,0)), unquote(Enum.at(suffix,1)) | tail] = args) do
              tld = [Enum.at(args, 0), Enum.at(args, 1)]
              Domainatrex.format_response(tld, tail)
            end
          3 ->
            def match([unquote(Enum.at(suffix,0)), unquote(Enum.at(suffix,1)), unquote(Enum.at(suffix,2)) | tail] = args) do
              tld = [Enum.at(args, 0), Enum.at(args, 1), Enum.at(args, 2)]
              Domainatrex.format_response(tld, tail)
            end
          4 ->
            def match([unquote(Enum.at(suffix,0)), unquote(Enum.at(suffix,1)), unquote(Enum.at(suffix,2)), unquote(Enum.at(suffix,3)) | tail] = args) do
              tld = [Enum.at(args, 0), Enum.at(args, 1), Enum.at(args, 2), Enum.at(args, 3)]
              Domainatrex.format_response(tld, tail)
            end
          5 ->
            def match([unquote(Enum.at(suffix,0)), unquote(Enum.at(suffix,1)), unquote(Enum.at(suffix,2)), unquote(Enum.at(suffix,3)), unquote(Enum.at(suffix,4)) | tail] = args) do
              tld = [Enum.at(args, 0), Enum.at(args, 1), Enum.at(args, 2), Enum.at(args, 3), Enum.at(args, 4)]
              Domainatrex.format_response(tld, tail)
            end
          _ ->
            raise "There exists a domain in the list which contains more than 5 dots: #{suffix}"
        end
      end)

    {:error, reason} ->
      IO.puts "Error: #{reason}"
  end

  def format_response(tld, domain) do
    [domain | subdomains] = domain
    tld = tld |> Enum.reverse |> Enum.join(".")
    subdomains = subdomains |> Enum.reverse |> Enum.join(".")
    %{domain: domain, subdomain: subdomains, tld: tld}
  end

  @doc """
  ## Examples
      iex> Domainatrex.parse("someone.com")
      %{domain: "someone", subdomain: "", tld: "com"}

      iex> Domainatrex.parse("blog.someone.id.au")
      %{domain: "someone", subdomain: "blog", tld: "id.au"}
  """
  def parse(url) do
    adjusted_url = url |> String.split(".") |> Enum.reverse
    match(adjusted_url)
  end

  def match(it) do
    raise "Invalid domain #{it}"
  end
end
