defmodule MateriaWeb.UserController do
  use MateriaWeb, :controller

  alias Materia.Accounts
  alias Materia.Accounts.User
  alias MateriaWeb.ControllerBase

  action_fallback(MateriaWeb.FallbackController)

  require Logger

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def list_users_by_params(conn, params) do
    users = Accounts.list_users_by_params(params)
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
    id = ControllerBase.get_user_id(conn)
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

  # def send_verify_mail(conn, %{"id" => id}) do
  #  # メールアドレス検証用のメール送信
  #  user = Accounts.get_user!(id)
  #
  #  with {:ok, _result} = Accounts.send_verify_mail(user) do
  #    send_resp(conn, :no_content, "")
  #  end
  # end

  def registration_tmp_user(conn, %{"email" => email, "role" => role}) do
    MateriaWeb.ControllerBase.transaction_flow(conn, :tmp_user, Materia.Accounts, :regster_tmp_user, [email, role])
  end

  def registration_user(conn, params) do
    # id = String.to_integer(conn.private.guardian_default_claims["sub"])
    id = ControllerBase.get_user_id(conn)
    user = Accounts.get_user!(id)
    conn = MateriaWeb.ControllerBase.transaction_flow(conn, :user, Materia.Accounts, :registration_user, [user, params])

    if Map.has_key?(conn, :private) do
      token = conn.private.guardian_default_token
      Materia.UserAuthenticator.revoke(token)
    end

    conn
  end

  def registration_user_and_sign_in(conn, params) do
    # id = String.to_integer(conn.private.guardian_default_claims["sub"])
    id = ControllerBase.get_user_id(conn)
    user = Accounts.get_user!(id)

    conn =
      MateriaWeb.ControllerBase.transaction_flow(conn, :user_token, Materia.Accounts, :registration_user_and_sign_in, [
        user,
        params
      ])

    token = conn.private.guardian_default_token
    Materia.UserAuthenticator.revoke(token)
    conn
  end

  def request_password_reset(conn, %{"email" => email}) do
    MateriaWeb.ControllerBase.transaction_flow(conn, :password_reset, Materia.Accounts, :request_password_reset, [email])
  end

  def reset_my_password(conn, %{"password" => password}) do
    # id = String.to_integer(conn.private.guardian_default_claims["sub"])
    id = ControllerBase.get_user_id(conn)
    user = Accounts.get_user!(id)

    conn =
      MateriaWeb.ControllerBase.transaction_flow(conn, :user, Materia.Accounts, :reset_my_password, [user, password])

    token = conn.private.guardian_default_token
    Materia.UserAuthenticator.revoke(token)
    conn
  end
end
