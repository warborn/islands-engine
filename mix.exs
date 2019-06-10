defmodule IslandsEngine.MixProject do
  use Mix.Project

  def project do
    [
      app: :islands_engine,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        plt_add_deps: :apps_direct
      ],
      preferred_cli_env: [
        validate: :test,
        espec: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Docs
      name: "Islands Engine",
      source_url: "https://github.com/warborn/islands-engine",
      docs: [],

      # Testing
      test_coverage: [
        tool: ExCoveralls,
        test_task: "espec"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {IslandsEngine.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.11.1", only: [:test], runtime: false},
      {:espec, "~> 1.7", only: [:test], runtime: false},
      {:ex_doc, "~> 0.20.2", only: [:dev], runtime: false},
      {:inch_ex, "~> 2.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      lint: "credo --strict",
      dialyze: "dialyzer --format dialyxir",
      validate: ["dialyze", "lint", "inch", "coveralls"]
    ]
  end
end
