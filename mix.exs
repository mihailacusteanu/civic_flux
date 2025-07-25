defmodule CivicFlux.MixProject do
  use Mix.Project

  def project do
    [
      app: :civic_flux,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {CivicFlux.Application, []},
      extra_applications: [:logger, :runtime_tools, :eventstore]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.21"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.17"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.19"},
      {:finch, "~> 0.16"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},

      # CQRS and Event Sourcing
      {:ecto_sql, "~> 3.11"},
      {:postgrex, "~> 0.17.5"},
      {:geo_postgis, "~> 3.7.1"},
      {:eventstore, "~> 1.4.8"},
      {:commanded, "~> 1.4"},
      {:commanded_eventstore_adapter, "~> 1.3"},
      {:commanded_ecto_projections, "~> 1.4"},
      {:broadway, "~> 1.2.1"},

      # only dev and tests
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false},

      #  # only for test
      {:mix_test_interactive, "~> 5.0", only: :dev, runtime: false},

      # only for dev
      {:dialyxir, "~> 1.3.0", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["event_store.drop --quiet", "event_store.create --quiet", "event_store.init", "test"],
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind civic_flux", "esbuild civic_flux"],
      "assets.deploy": [
        "tailwind civic_flux --minify",
        "esbuild civic_flux --minify",
        "phx.digest"
      ]
    ]
  end
end
