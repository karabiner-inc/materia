# Servicex

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Usage

add deps

```mix.exs

 defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:mariaex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:servicex, "~> 0.1.0"}, #<- add here
    ]
  end

```

add Guardian DB conf

※is must do mix.deps.get before secret_key config
so update later.

```config/config.exs

# Configures Guardian
config :servicex, Servicex.Authenticator,
  issuer: "your_app_name",  #<- mod your app name
  # Generate mix task 
  # > mix phx.gen.secret
  secret_key: "your secusecret token"

# Configures GuardianDB
config :guardian, Guardian.DB,
  repo: YourApp.Repo,  #<- mod your app repo
  schema_name: "guardian_tokens", # default
  #token_types: ["refresh_token"], # store all token types if not set
  sweep_interval: 60 # default: 60 minutes

```

```config/dev.exs

# Configure servicex repo
config :servicex, :repo, YourApp.Repo  #<- add your app repo

```

```
> mix deps.get
```

update secret_key config

```
> mix phx.gen.secret
```

```config/config.exs

# Configures Guardian
config :servicex, Servicex.Authenticator,
  issuer: "your_app_name",  
  # Generate mix task 
  # > mix phx.gen.secret
  secret_key: "your secusecret token" #<- mod your token

```

add application config

```lib/your_app/application.ex

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(YourApp.Repo, []),
      # Start the endpoint when the application starts
      supervisor(YourAppWeb.Endpoint, []),
      # Start your own worker by calling: YourApp.Worker.start_link(arg1, arg2, arg3)
      # worker(YoutApp.Worker, [arg1, arg2, arg3]),
      worker(Guardian.DB.Token.SweeperServer, []), #<- if you wont auto sweep invalid token, you must add GuardianDB worker.
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YourApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

```

do generate migration file for servicex and migrate

```
> mix servicex.gen.migration
> mix ecto.create
> mix ecto.migrate
'''

add guardian pipeline

```lib/your_app_web/router.ex

  pipeline :guardian_auth do
    plug Servicex.AuthenticatePipeline #<-- guardian jwt token authentication by user model.
  end
  pipeline :grant_check do
    plug Servicex.Plug.GrantChecker, repo: YourApp.Repo #<-- Grant check by user ,role and grant model.
  end


```

add servicex user and grant model path.

```lib/your_app_web/router.ex

  scope "/your-path", ServicexWeb do
    pipe_through [ :api]

    post "sign-in", AuthenticatorController, :sign_in
  end

  scope "/your-path", ServicexWeb do
    pipe_through [ :api]

    get "/show-me", UserController, :show_me
    post "sign-out", AuthenticatorController, :sign_out
  end

  scope "/your-path", ServicexWeb do
    pipe_through [ :api, :guardian_auth, :grant_check]

    resources "/users", UserController, except: [:edit, :new]
    resources "/grants", GrantController, except: [:new, :edit]
  end

'''


regiter grant record.
servicex grant is white list about user role and request mothod.

Servicex.Plug.GrantChecker provide simple role check function.

for example
user hogehoge is administrator.
user fugafuga is ordialy operator.

``` priv/repo/seed.exs
alias Servicex.Accounts

Accounts.create_user(%{ name: "hogehoge", email: "hogehoge@example.com", password: "hogehoge", role: "admin"})
Accounts.create_user(%{ name: "fugafuga", email: "fugafuga@example.com", password: "fugafuga", role: "operator"})
Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/your-path/users" })
Accounts.create_grant(%{ role: "admin", method: "GET", request_path: "/your-path/grants" })

```
※ grant.role "anybody" is a special reserved keyword by Servicex and its means all roles.
※ grant.method "ANY" is a special reserved keyword by Servicex and its means all request methods.

```
> mix run priv/repo/seeds.exs
```

any request for "/your-path/users" is arrowed all users.
get request for "/your-path/grants" is arrowed only administrators.
if other role user access "/your-path/grants" by GET mthod, its access denied.
other request method for "/your-path/grants" is not arrowed anyone.


request sample 

```
mix phx.server
```

Request
```
POST http://lodalhost:4000/your-path/sign-in HTTP/1.1
Content-Type: application/json

{
    "email": "hogehoge@example.com", 
    "password": "hogehoge"
  }
```

Response
```
{
  "token": "jwt token",
  "id": 1
}
```

Request```
GET {{url}}/admin/show-me HTTP/1.1
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcHBfYWRtaW4iLCJleHAiOjE1Mzg3MzA0ODUsImlhdCI6MTUzNjMxMTI4NSwiaXNzIjoiYXBwX2FkbWluIiwianRpIjoiZTdiZmNlYzUtNmZlNC00YjY5LTlhMWEtNmRjMjRmODZlNTNjIiwibmJmIjoxNTM2MzExMjg0LCJzdWIiOiIxIiwidHlwIjoiYWNjZXNzIn0.JL1qxqK9JA6R176ataDI0wZj4MoxpdiOx_EEHCqHfbvPZzH_uSDkhAnfxEHa5cCL4KzcZbcCrniflzLsLZ_2pg
```

Responce
```
{
  "role": "admin",
  "name": "hogehoge",
  "id": 1,
  "email": "hogehoge@example.com"
}

```

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix