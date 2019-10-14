defmodule Messin.MixProject do
  use Mix.Project

  def project do
    [
      app: :messin,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:typed_ecto_schema, "~> 0.1.0"},
      {:gradualixir, github: "overminddl1/gradualixir", ref: "master"},
      # {:ex_type, github: "gyson/ex_type", ref: "master", only: :dev, runtime: false},
      {:ex_type, "~> 0.4.0", only: :dev, runtime: false},
      # Optional
      # {:ex_type_runtime, "~> 0.1.0"}
    ]
  end
end
