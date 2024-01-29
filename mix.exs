defmodule Domainatrex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :domainatrex,
      version: "3.0.4",
      elixir: "~> 1.10",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),

      # Docs
      name: "Domainatrex",
      description: description(),
      source_url: "https://github.com/Zensavona/domainatrex",
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger, :inets, :ssl]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: [:dev]}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      keywords: ["Elixir", "Domain", "TLD", "Public Suffix"],
      maintainers: ["Zen Savona"],
      links: %{
        "GitHub" => "https://github.com/zensavona/domainatrex",
        "Public Suffix List" => "https://publicsuffix.org/list/"
      }
    ]
  end

  defp description do
    """
    Domain / TLD parsing library for Elixir, using the Public Suffix List.
    """
  end

  defp docs do
    [
      main: "overview",
      api_reference: false,
      formatters: ["html"],
      extra_section: "Pages",
      extras: [
        "README.md": [filename: "overview", title: "Overview"],
        "CHANGELOG.md": [filename: "changelog", title: "Changelog"]
      ],
      source_ref: "master"
    ]
  end
end
