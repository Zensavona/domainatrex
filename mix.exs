defmodule Domainatrex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :domainatrex,
      version: "3.0.2",
      elixir: "~> 1.3",
      test_coverage: [tool: ExCoveralls],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :inets, :ssl]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: [:dev, :docs]},
      {:excoveralls, "~> 0.18.0", only: [:dev, :test]},
      {:inch_ex, "~> 1.0", only: [:dev, :docs]},
      {:nimble_parsec, "~> 0.4.0", only: [:dev, :docs]}
    ]
  end

  defp description do
    """
    Domain / TLD parsing library for Elixir, using the Public Suffix List.
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      keywords: ["Elixir", "Domain", "TLD", "Public Suffix"],
      maintainers: ["Zen Savona"],
      links: %{
        "GitHub" => "https://github.com/zensavona/domainatrex",
        "Docs" => "https://hexdocs.pm/domainatrex"
      }
    ]
  end
end
