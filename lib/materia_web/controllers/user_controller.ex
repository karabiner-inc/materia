defmodule MateriaWeb.UserController do
  use MateriaWeb, :controller

  alias Materia.Accounts
  alias Materia.Accounts.User

  action_fallback MateriaWeb.FallbackController

  require Logger

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def list_users_by_params(conn, params) do
    users = Accounts.list_user_by_params(params)
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
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
    Logger.debug("show_me")
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

  def send_verify_mail(conn, %{"id" => id}) do
    # メールアドレス検証用のメール送信
    user = Accounts.get_user!(id)

    with {:ok, _result} = Accounts.send_verify_mail(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def registration_tmp_user(conn, %{"email" => email, "role" => role}) do
    Materia.ControllerBase.transaction_flow(conn, :tmp_user, Materia.Accounts, :regster_tmp_user, [email, role])
  end

  def registration_user(conn, params) do
  id = String.to_integer(conn.private.guardian_default_claims["sub"])
  user = Accounts.get_user!(id)
  Materia.ControllerBase.transaction_flow(conn, :user, Materia.Accounts, :registration_user, [user, params])
  end

end
