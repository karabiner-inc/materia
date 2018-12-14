defmodule Materia.Mixfile do
  use Mix.Project

  def project do
    [
      app: :materia,
      version: "0.1.0",
      elixir: "~> 1.6",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      description: "This library is a summary of the functions that are generally required for Web service development.",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      package: [
        maintainers: ["karabiner.inc"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/karabiner-inc/materia"}
      ],
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    mod =
      case Mix.env() do
        # テストのみアプリケーションとして起動する
        :test -> [mod: {Materia.Test.Application, []}]
      #  :dev -> [mod: {Materia.Application, []}]
        _ -> []
      end
     #[mod: {Materia.Application, []}]
    mod ++ [
      #mod: {Materia.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    deps_list = [
      {:phoenix, "== 1.3.2"},
      {:phoenix_pubsub, "== 1.0.2"},
      {:plug, "== 1.5.1"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:guardian, "~> 1.0"},
      {:guardian_db, "~> 1.0"},
      {:guardian_backdoor, "~> 1.0.0", only: :test},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.3"},
      {:sendgrid, "~> 1.8"},
      {:materia_utils, "~> 0.1.1"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "run priv/repo/seeds.exs", "test"]
    ]
  end
end
