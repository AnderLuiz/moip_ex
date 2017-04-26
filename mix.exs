defmodule MoipEx.Mixfile do
  use Mix.Project

  def project do
    [app: :moip_ex,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def deps do
    [
      {:httpoison, "~> 0.9.0"},
      {:poison, "~> 2.0 or ~> 3.0"},
    ]
  end
end
