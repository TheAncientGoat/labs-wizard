defmodule VltLabsWizard.Mixfile do
  use Mix.Project

  def project do
    [app: :vlt_labs_wizard,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {VltLabsWizard.Application, []},
     extra_applications: [
       :corsica, :logger, :runtime_tools, :comeonin, :hackney, :poison,
       :arc_ecto
     ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:comeonin, "~> 3.0"},
     {:cowboy, "~> 1.0"},
     {:corsica, "~> 1.0"},
     {:credo, "~> 0.9.1", only: [:dev, :test]},
     {:ecto_enum, "~> 1.0"},
     {:ex_machina, "~> 2.0", only: :test},
     {:ex_admin, github: "smpallen99/ex_admin", branch: "phx-1.3"},
     {:guardian, github: "TheAncientGoat/guardian", branch: "master" },
     {:slack, "~> 0.12.0"},
     {:arc, "~> 0.8.0"},
     {:arc_ecto, "~> 0.7.0"},
     {:ex_aws, "~> 1.1" },
     {:hackney, "~> 1.6" },
     {:poison, "~> 3.1" },
     {:sweet_xml, "~> 0.6" },
     {:quantum, ">= 2.0.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
