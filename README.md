# Servicex

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Usage

 add deps

 ```
{:servicex, "~> 0.0.1"},
 ```

mix deps.get


add Config

```
# Configures Guardian
config :servicex, Servicex.Authenticator,
  issuer: "app_ex",
  secret_key: "VlY6rTO8s+oM6/l4tPY0mmpKubd1zLEDSKxOjHA4r90ifZzCOYVY5IBEhdicZStw"

# Configures GuardianDB
config :guardian, Guardian.DB,
  repo: AppEx.Repo,
  schema_name: "guardian_tokens", # default
  #token_types: ["refresh_token"], # store all token types if not set
  sweep_interval: 60 # default: 60 minutes
```

add Servicex Repo

```
# Configures Servicex
config :app_ex, Servicex.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "otta_dev",
  hostname: "localhost",
  pool_size: 10

  # Configures Servicex
config :servicex, Servicex.Repo,
adapter: Ecto.Adapters.Postgres,
username: "postgres",
password: "postgres",
database: "otta_dev",
hostname: "localhost",
pool_size: 10
```
add application.ex

```
# Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(AppEx.Repo, []),
      # Start the endpoint when the application starts
      supervisor(AppExWeb.Endpoint, []),
      # Start your own worker by calling: AppEx.Worker.start_link(arg1, arg2, arg3)
      # worker(AppEx.Worker, [arg1, arg2, arg3]),
      supervisor(Servicex.Repo, []), <-- add here
    ]
```

add router


```
defmodule AppExWeb.Router do
  use AppExWeb, :router
 use ServicexWeb, :router <-- add here

# pipline for Servicex add start.
  pipeline :guardian_auth do
    plug Servicex.AuthenticatePipeline
  end
  pipeline :grant_check do
    plug Servicex.Plug.GrantChecker, repo: AppEx.Repo
  end
    # pipline for Servicex add start.

# routing for Servicex add start.
  scope "/api", ServicexWeb do
    pipe_through :api

    post "sign-in", AuthenticatorController, :sign_in
  end

  scope "/api", ServicexWeb do
    pipe_through [ :api, :guardian_auth] # Use the default browser stack

    get "/user", UserController, :show_me
    post "sign-out", AuthenticatorController, :sign_out
  end

  scope "/api/ops", ServicexWeb do
    pipe_through [ :api, :guardian_auth, :grant_check]

    resources "/users", UserController, except: [:edit, :new]
    resources "/grants", GrantController, except: [:new, :edit]
  end
  # routing for Servicex add end.
```



## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix