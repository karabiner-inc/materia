defmodule ServicexWeb.UserController do
  use ServicexWeb, :controller

  alias Servicex.Accounts
  alias Servicex.Accounts.User

  action_fallback ServicexWeb.FallbackController

  require Logger

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
    #%{"data" => %{"email" => "admin@example.com", "name" => "hogehoge太郎", "password" => "password", "role" => "admin"}}
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    Logger.debug("show id: #{id}")
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def show_me(conn, _params) do
    Logger.debug("show")
    id = String.to_integer(conn.private.guardian_default_claims["sub"])
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, user_params) do
    user = Accounts.get_user!(user_params["id"])

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
