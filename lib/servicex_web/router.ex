defmodule ServicexWeb.Router do
  use ServicexWeb, :router

  #pipeline :browser do
  #  plug :accepts, ["html"]
  #  plug :fetch_session
  #  plug :fetch_flash
  #  plug :protect_from_forgery
  #  plug :put_secure_browser_headers
  #end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guardian_auth do
    plug Servicex.AuthenticatePipeline
  end

  pipeline :tmp_user_auth do
    plug Servicex.UserRegistrationAuthPipeline
  end

  pipeline :grant_check do
    repo = Application.get_env(:servicex, :repo)
    plug Servicex.Plug.GrantChecker, repo: repo
  end

  scope "/api", ServicexWeb do
    pipe_through :api

    post "sign-in", AuthenticatorController, :sign_in
    post "refresh", AuthenticatorController, :refresh
    post "tmp-registration", UserController, :registration_tmp_user

  end

  scope "/api", ServicexWeb do
    pipe_through [ :api, :tmp_user_auth]

    get "tmp-varidation", AuthenticatorController, :is_varid_tmp_user
    post "user-registration", UserController, :registration_user

  end

  scope "/api", ServicexWeb do
    pipe_through [ :api, :guardian_auth]

    get "/user", UserController, :show_me
    post "/grant", GrantController, :get_by_role
    post "sign-out", AuthenticatorController, :sign_out
    get "auth-check", AuthenticatorController, :is_authenticated
    post "search-users", UserController, :list_users_by_params

  end

  scope "/api/ops", ServicexWeb do
    pipe_through [ :api, :guardian_auth, :grant_check]

    resources "/users", UserController, except: [:edit, :new]
    resources "/grants", GrantController, except: [:new, :edit]
    resources "/templates", TemplateController, except: [:new, :edit]

  end

  # Other scopes may use custom stacks.
  # scope "/api", ServicexWeb do
  #   pipe_through :api
  # end
end
