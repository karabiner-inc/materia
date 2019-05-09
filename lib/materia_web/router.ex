defmodule MateriaWeb.Router do
  use MateriaWeb, :router

  #pipeline :browser do
  #  plug :accepts, ["html"]
  #  plug :fetch_session
  #  plug :fetch_flash
  #  plug :protect_from_forgery
  #  plug :put_secure_browser_headers
  #end

  pipeline :api do
    plug :accepts, ["json"]
    #plug Materia.Plug.Debug
    plug Materia.Plug.ConnLogger
  end

  pipeline :guardian_auth do
    plug Materia.UserAuthPipeline
  end

  pipeline :guardian_auth_acount do
    plug Materia.AccountAuthPipeline
  end

  pipeline :tmp_user_auth do
    plug Materia.UserRegistrationAuthPipeline
  end

  pipeline :pw_reset_auth do
    plug Materia.PasswordResetAuthPipeline
  end

  pipeline :grant_check do
    repo = Application.get_env(:materia, :repo)
    plug Materia.Plug.GrantChecker, repo: repo
  end

  scope "/api", MateriaWeb do
    pipe_through :api

    post "/sign-in", AuthenticatorController, :sign_in
    post "/refresh", AuthenticatorController, :refresh
    post "/tmp-registration", UserController, :registration_tmp_user
    post "/request-password-reset", UserController, :request_password_reset

    get "/client-logs/:id", ClientLogController, :show
    post "/client-logs", ClientLogController, :create
    post "/search-client-logs", ClientLogController,:list_client_logs_by_params
    get "/conn_logs/:id", ConnLogController, :show
    post "/search-conn-logs", ConnLogController, :list_conn_logs_by_params

    post "/like-serach-tags", TagController, :list_tags_by_normalized
    post "/tags", TagController, :merge

  end

  scope "/api", MateriaWeb do
    pipe_through [ :api, :tmp_user_auth]

    get "/varidation-tmp-user", AuthenticatorController, :is_varid_token
    post "/user-registration", UserController, :registration_user
    post "/user-registration-and-sign-in", UserController, :registration_user_and_sign_in

  end

  scope "/api", MateriaWeb do
    pipe_through [ :api, :pw_reset_auth]

    get "/varidation-pw-reset", AuthenticatorController, :is_varid_token
    post "/reset-my-password", UserController, :reset_my_password

  end

  scope "/api", MateriaWeb do
    pipe_through [ :api, :guardian_auth]

    get "/user", UserController, :show_me
    post "/grant", GrantController, :get_by_role
    post "/sign-out", AuthenticatorController, :sign_out
    get "/auth-check", AuthenticatorController, :is_authenticated
    post "/search-users", UserController, :list_users_by_params
    resources "/addresses", AddressController, except: [:new, :edit]
    post "/create-my-addres", AddressController, :create_my_address
    resources "/accounts", AccountController, except: [:new, :edit]
    post "/search-accounts", AccountController, :list_accounts_by_params
    resources "/value-definitions", ValueDefinitionController, except: [:new, :edit]
    post "/search-definitions", ValueDefinitionController, :list_definitions_by_params
  end

  scope "/api", MateriaWeb do
    pipe_through [ :api, :guardian_auth_acount]

    get "/my-account", AccountController, :show_my_account
  end

  scope "/api/ops", MateriaWeb do
    pipe_through [ :api, :guardian_auth, :grant_check]

    resources "/grants", GrantController, except: [:new, :edit]
    resources "/mail-templates", MailTemplateController, except: [:new, :edit]

    resources "/users", UserController, except: [:edit, :new]
    resources "/organizations", OrganizationController, except: [:new, :edit]

  end

  # Other scopes may use custom stacks.
  # scope "/api", MateriaWeb do
  #   pipe_through :api
  # end
end
