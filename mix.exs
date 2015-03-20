defmodule Suxuri.Mixfile do
  use Mix.Project

  def project do
    [
      app: :suxuri,
      version: "0.1.0",
      elixir: "~> 1.0",
      deps: deps,
      description: description,
      package: package
    ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.6"},
      {:exjsx, "~> 3.1"}
    ]
  end

  defp description do
    "Suzuri client library for elixir."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      contributors: ["Joe Honzawa"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/Joe-noh/suxuri",
        "suzuri" => "https://suzuri.jp"
      }
    ]
  end
end
