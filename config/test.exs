use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :servicex, ServicexWeb.Test.Endpoint,
  http: [port: 4001],
  #server: false,
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  watchers: []

# Print only warnings and errors during test
config :logger, level: :debug

# Configure your database
config :servicex, Servicex.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "servicex_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

  config :servicex, repo: Servicex.Test.Repo

# Configures GuardianDB
config :guardian, Guardian.DB,
repo: Servicex.Test.Repo,
schema_name: "guardian_tokens", # default
#token_types: ["refresh_token"], # store all token types if not set
sweep_interval: 60 # default: 60 minutes

