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

  pipeline :grant_check do
    plug Servicex.Plug.GrantChecker, repo: Servicex.Repo
  end

  scope "/api", ServicexWeb do
    pipe_through :api

    post "sign-in", AuthenticatorController, :sign_in

  end

  scope "/api", ServicexWeb do
    pipe_through [ :api, :guardian_auth]

    get "/user", UserController, :show_me
    post "sign-out", AuthenticatorController, :sign_out

  end

  scope "/api/ops", ServicexWeb do
    pipe_through [ :api, :guardian_auth, :grant_check]

    resources "/users", UserController, except: [:edit, :new]
    resources "/grants", GrantController, except: [:new, :edit]

  end

  # Other scopes may use custom stacks.
  # scope "/api", ServicexWeb do
  #   pipe_through :api
  # end
end
