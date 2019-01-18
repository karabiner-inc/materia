# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :materia,
  ecto_repos: [Materia.Test.Repo]

# Configures the endpoint
config :materia, MateriaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xAeVCjjYbPDJQW5oou/zXYHs9KpzNG3XOO/zZuEFxKpTCAwc09sEm9REdzlGPqnE",
  render_errors: [view: MateriaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Materia.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Materia.Authenticator
config :materia, Materia.Authenticator,
  access_token_ttl: {10, :minutes}, #必須
  refresh_token_ttl: {1, :days}, # refresh_tokenを定義しない場合sign-inはaccess_tokenのみ返す
  user_registration_token_ttl: {35, :minutes},
  password_reset_token_ttl: {35, :minutes}

# Configures Guardian
config :materia, Materia.UserAuthenticator,
  issuer: "Materia",
  secret_key: "VlY6rTO8s+oM6/l4tPY0mmpKubd1zLEDSKxOjHA4r90ifZzCOYVY5IBEhdicZStw",
  allowed_algos: ["HS256"]

# Configures Guardian
config :materia, Materia.AccountAuthenticator,
  issuer: "Materia",
  secret_key: "VlY6rTO8s+oM6/l4tPY0mmpKubd1zLEDSKxOjHA4r90ifZzCOYVY5IBEhdicZStw",
  allowed_algos: ["HS256"]

# Configures gettext for Materia
config :materia, gettext: MateriaWeb.Gettext

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

