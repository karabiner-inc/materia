use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :servicex, ServicexWeb.Test.Endpoint,
  http: [port: 4001],
  #server: false,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Print only warnings and errors during test
config :logger, level: :info

# Configure your database
config :servicex, Servicex.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "servicex_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
