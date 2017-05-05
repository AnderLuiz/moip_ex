defmodule MoipEx.Mixfile do
  use Mix.Project

  def project do
    [app: :moip_ex,
     version: "0.1.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/AnderLuiz/moip_ex",
     package: package(),
     description: description(),
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp description do
    """
    Lib para lidar com o Moip pagamentos (https://www.moip.com.br/).
    """
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
      {:ex_doc, "~> 0.13", only: :dev},
      {:httpoison, "~> 0.9.0"},
      {:poison, "~> 2.0 or ~> 3.0"},
    ]
  end
end
