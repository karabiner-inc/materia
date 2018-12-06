# Materia

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


## Installation

add deps

mix.exs

```
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
      {:materia, "~> 0.1.0"}, #<- add here
    ]
  end
```

add Guardian DB conf

is must do mix.deps.get before secret_key config.
so update later.

config/config.exs

```
# Configures Guardian
config :materia, Materia.Authenticator,
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

config/dev.exs

```
# Configure materia repo
config :materia, :repo, YourApp.Repo  #<- add your app repo
```

```
> mix deps.get
```

update secret_key config

```
> mix phx.gen.secret
```

config/config.exs

```
# Configures Guardian
config :materia, Materia.Authenticator,
  issuer: "your_app_name",  
  # Generate mix task 
  # > mix phx.gen.secret
  secret_key: "your secusecret token" #<- mod your token
```

add application config

lib/your_app/application.ex

```
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

do generate migration file for materia and migrate

```
> mix materia.gen.migration
> mix ecto.create
> mix ecto.migrate
```

add guardian pipeline

lib/your_app_web/router.ex

```
  pipeline :guardian_auth do
    plug Materia.AuthenticatePipeline #<-- guardian jwt token authentication by user model.
  end
  pipeline :grant_check do
    plug Materia.Plug.GrantChecker, repo: YourApp.Repo #<-- Grant check by user ,role and grant model.
  end
```

add materia user and grant model path.

lib/your_app_web/router.ex

```
  scope "/your-path", MateriaWeb do
    pipe_through [ :api]

    post "sign-in", AuthenticatorController, :sign_in
  end

  scope "/your-path", MateriaWeb do
    pipe_through [ :api, :guardian_auth]

    get "/show-me", UserController, :show_me
    post "sign-out", AuthenticatorController, :sign_out

    resources "/addresses", AddressController, except: [:index, :new, :edit]
    get "/my-addresses", AddressController, :my_addresses
  end

  scope "/your-path", MateriaWeb do
    pipe_through [ :api, :guardian_auth, :grant_check]

    resources "/users", UserController, except: [:edit, :new]
    resources "/grants", GrantController, except: [:new, :edit]
  end
```

## Mailer
### SendGrid
Add SendGrid API Key.
lib/config.exs
```
config :sendgrid, api_key: System.get_env("SENDGRID_API_KEY")
```


## Usage

regiter grant record.
materia grant is white list about user role and request mothod.

Materia.Plug.GrantChecker provide simple role check function.

for example
user hogehoge is administrator.
user fugafuga is ordialy operator.

priv/repo/seed.exs

```
alias Materia.Accounts

Accounts.create_user(%{ name: "hogehoge", email: "hogehoge@example.com", password: "hogehoge", role: "admin"})
Accounts.create_user(%{ name: "fugafuga", email: "fugafuga@example.com", password: "fugafuga", role: "operator"})
Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/your-path/users" })
Accounts.create_grant(%{ role: "admin", method: "GET", request_path: "/your-path/grants" })
```

※ grant.role "anybody" is a special reserved keyword by Materia and its means all roles.
※ grant.method "ANY" is a special reserved keyword by Materia and its means all request methods.

```
> mix run priv/repo/seeds.exs
```

any request for "/your-path/users" is arrowed all users.
get request for "/your-path/grants" is arrowed only administrators.
if other role user access "/your-path/grants" by GET mthod, its access denied.
other request method for "/your-path/grants" is not arrowed anyone.


request sample 

```
> mix phx.server
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
  "access_token": "your_jwd_token",
  "id": 1
}
```

Request

```
GET {{url}}/admin/show-me HTTP/1.1
Content-Type: application/json
Authorization: Bearer your_jwd_token
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


## Comvert from Srvicex

#### Step1 modify mix.exs

```
{:servicex, git: "https://bitbucket.org/karabinertech_bi/servicex.git"},
```
modify to
```
{:materia, git: "https://bitbucket.org/karabinertech_bi/materia.git"},
```

#### Step2 replace Code
  
  Servicex -> Materia
  servicex -> materia
  MateriaErrorError -> BusinessError

#### Step3 Timex setting update


mix.exs application settings add ":tzdata"
```
def application do
    [
      mod: {AppEx.Application, []},
      extra_applications: [:logger, :runtime_tools, :httpoison, :tzdata]
    ]
  end
```

#### Step4 gen migrate

remove old migration files
```
> ls -1d priv/repo/migrations/* | grep servicex
priv/repo/migrations/20181001042440_servicex_craete_user.exs
priv/repo/migrations/20181001042441_servicex_craete_grant.exs
> ls -1d priv/repo/migrations/* | grep servicex | xargs rm
> ls -1d priv/repo/migrations/* | grep servicex
```

```
> mix deps.clean servicex materia servicex_utils materia_utils
> mix deps.update materia materia_utils
> mix materia.gen.migration

```

If a foreign key construct to the servicex schema was defined,
You need to change the name of Materia's migration file to be before the name of your migration file.

```
ls -1 priv/repo/migrations
20181006090000_create_your_table
20181206081940_materia_1_craete_users.exs
20181206081941_materia_2_craete_organizations.exs
20181206081942_materia_3_craete_address.exs
20181206081943_materia_4_craete_grants.exs
20181206081944_materia_5_craete_mail_templates.exs
```

rename files

```
ls -1 priv/repo/migrations
20180106081940_materia_1_craete_users.exs
20180106081941_materia_2_craete_organizations.exs
20180106081942_materia_3_craete_address.exs
20180106081943_materia_4_craete_grants.exs
20180106081944_materia_5_craete_mail_templates.exs
20181006090000_create_your_table
```

### Step5 ecto.reset

ecto reset

```
> mix ecto.reset
```

 
## Servicex -> Materia change Over View  
 
 #### move ServicexMatching.Accounts.User -> Materia.Accounts.User
 
 add clumns 
 ```
 field :back_ground_img_url, :string
 field :icon_img_url, :string
 field :one_line_message, :string
 ```

####  Materia.Accounts.User
 
 add columns
 ```
 field :descriptions, :string
 filed :external_user_id, :string
 field :phone_number, :string
 ```

#### Mix.Tasks.Materia.Gen.Migration 

  change do'nt execute Mix.Tasks.Guardian.Db.Gen.Migration.run([])
 
#### Servicex.Accounts.Address　-> Materia.Locations.Address

 add columns
 ```
 add organization_id, :integer # and association "organization has_many address"
 add lock_version, :integer # and optimistic_lock logic 
 ```

#### Materia.Authenticator.sign_in()

  add check logic.
  if user.status != User.status.activate, return response as "invalid_token"

#### AddressAPI add endpoint ad 'create-my-address'

  post "create-my-addres", AddressController, :create_my_address

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix