defmodule MoipEx.Mixfile do
  use Mix.Project

  @version "0.3.0"
  @github "https://github.com/AnderLuiz/moip_ex"

  def project do
    [app: :moip_ex,
     version: @version,
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: @github,
     docs: docs(),
     package: package(),
     description: description(),
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger, :httpoison]]
  end

  defp description do
    """
    Lib para lidar com o Moip pagamentos (https://www.moip.com.br/).
    """
  end

  defp docs do
  [
    main: "readme",
    source_ref: "v#{@version}",
    source_url: @github,
    extras: [
      "README.md",
      "examples/notificacoes.md"
    ]
  ]
  end

  defp package do
    # These are the default files included in the package
    [
      name: :moip_ex,
      maintainers: ["Anderson Luiz Vendruscolo"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/AnderLuiz/moip_ex"}
    ]
  end

  def deps do
    [
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev]},
      {:mock, "~> 0.3.0", only: [:test]},
      {:httpoison, "~> 0.9.0"},
      {:poison, "~> 2.0 or ~> 3.0"},
    ]
  end

  defp elixirc_paths(:test), do: ["lib","test/mocks"]
  defp elixirc_paths(_), do: ["lib"]

end
