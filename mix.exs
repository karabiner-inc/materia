defmodule Servicex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :servicex,
      version: "0.1.2",
      elixir: "~> 1.4",
      description: "This library is a summary of the functions that are generally required for Web service development.",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      package: [
        maintainers: ["tuchro yoshimura"],
        licenses: ["MIT"],
        links: %{"BitBucket" => "https://bitbucket.org/karabinertech_bi/servicex/src/master/"}
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
        :test -> [mod: {Servicex.Test.Application, []}]
      #  :dev -> [mod: {Servicex.Application, []}]
        _ -> []
      end
     #[mod: {Servicex.Application, []}]
    mod ++ [
      #mod: {Servicex.Application, []},
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
      #{:guardian_db, "~> 1.0"},
      {:guardian_db, git: "https://github.com/ueberauth/guardian_db"},
      {:guardian_backdoor, "~> 1.0.0", only: :test},
      {:poison, "~> 3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:timex, "~> 3.3"},
    ]
      _deps_list =
    if Mix.env() == :prod do
      IO.puts("prod!!")
      # 本番環境のみmasterから取得する
      deps_list ++ [
        {:servicex_utils, git: "https://bitbucket.org/karabinertech_bi/servicex_utils.git"},
      ]
    else
      # それ以外はdevelopから取得する
      IO.puts("dev!!")
      deps_list ++ [
        {:servicex_utils, git: "https://bitbucket.org/karabinertech_bi/servicex_utils.git", branch: "develop"},
      ]
    end
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
