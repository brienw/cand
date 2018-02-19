defmodule Cand.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cand,
      version: "0.1.0",
      build_path: "_build",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Cand.Application, []}
    ]
  end

  defp deps do
    [
    ]
  end
end
