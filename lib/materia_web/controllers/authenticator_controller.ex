defmodule MateriaWeb.AuthenticatorController do
  @moduledoc """
  """
  use MateriaWeb, :controller

  # import Comeonin.Bcrypt, only: [ checkpw: 2]

  # alias Materia.Accounts
  # alias Materia.Accounts.User

  action_fallback(MateriaWeb.FallbackController)

  require Logger

  # def sign_in(conn, _params = %{ "email" => email, "password" => password }) do
  #  claims = %{"email" => email}
  #  with {:ok,  nil} <- Materia.Authenticator.resource_from_claims(claims) do
  #    handle_unauthenticated(conn, "email or password is invalid")
  #  else
  #    {:ok,  resource} ->
  #       _conn =
  #       if Comeonin.Bcrypt.checkpw(password, resource.hashed_password) do
  #        Logger.debug("#{__MODULE__} --- sign_in Comeonin.Bcrypt.checkpw == true")
  #         with {:ok, token, _claims} <- Materia.Authenticator.encode_and_sign(resource) do
  #          Logger.debug("#{__MODULE__} --- sign_in Materia.Authenticator.encode_and_sign ok")
  #          Logger.debug("#{__MODULE__} --- sign_in token:#{token}")
  #          Logger.debug("#{__MODULE__} --- sign_in claims:#{inspect(claims)}")
  #           conn
  #           |> put_status(:created)
  #           |> render("show.json", authenticator: %{id: resource.id ,token: token})
  #         else
  #           _ -> handle_unauthenticated(conn, "email or password is invalid")
  #         end
  #       else
  #         handle_unauthenticated(conn, "email or password is invalid")
  #       end
  #    _ ->
  #      handle_unauthenticated(conn, "email or password is invalid")
  #  end
  #
  # end
  def sign_in(conn, _params = %{"account" => account, "email" => email, "password" => password}) do
    Logger.debug("--- MateriaWeb.AuthenticateController sign_in with account-----------------")

    with {:ok, result} <- Materia.AccountAuthenticator.sign_in(account, email, password) do
      authenticator =
        if Map.has_key?(result, :refresh_token) do
          %{id: result.id, access_token: result.access_token, refresh_token: result.refresh_token}
        else
          %{id: result.id, access_token: result.access_token}
        end

      conn
      |> put_status(:created)
      |> render("show.json", authenticator: authenticator)
    else
      {:error, message} ->
        handle_unauthenticated(conn, message)
    end
  end

  def sign_in(conn, _params = %{"email" => email, "password" => password}) do
    Logger.debug("--- MateriaWeb.AuthenticateController sign_in-----------------")

    with {:ok, result} <- Materia.UserAuthenticator.sign_in(email, password) do
      authenticator =
        if Map.has_key?(result, :refresh_token) do
          %{id: result.id, access_token: result.access_token, refresh_token: result.refresh_token}
        else
          %{id: result.id, access_token: result.access_token}
        end

      conn
      |> put_status(:created)
      |> render("show.json", authenticator: authenticator)
    else
      {:error, message} ->
        handle_unauthenticated(conn, message)
    end
  end

  def refresh(conn, _params = %{"refresh_token" => refresh_token}) do
    with {:ok, access, _refresh} <- Materia.UserAuthenticator.refresh_tokens(refresh_token) do
      {access_token, _access_claims} = access
      {refresh_token, refresh_claims} = access
      {:ok, sub} = Poison.decode(refresh_claims["sub"])
      IO.inspect(sub)

      conn
      |> put_status(:created)
      |> render(
        "show.json",
        authenticator: %{id: sub["user_id"], access_token: access_token, refresh_token: refresh_token}
      )
    else
      {:error, message} ->
        handle_unauthenticated(conn, message)
    end
  end

  def sign_out(conn, _params) do
    Logger.debug("--- MateriaWeb.AuthenticateController sign_out-----------------")
    token = conn.private[:guardian_default_token]

    with {:ok, _claims} = Materia.UserAuthenticator.revoke(token) do
      conn
      |> put_status(200)
      |> render("delete.json", [])
    end
  end

  def is_authenticated(conn, _params) do
    Logger.debug("--- MateriaWeb.AuthenticateController is_authenticated-----------------")
    send_resp(conn, 200, "{\"message\":\"authenticated\"}")
  end

  def is_varid_token(conn, _params) do
    Logger.debug("--- MateriaWeb.AuthenticateController is_varid_token-----------------")
    send_resp(conn, 200, "{\"message\":\"authenticated\"}")
  end

  defp handle_unauthenticated(conn, reason) do
    conn
    |> put_status(:unauthorized)
    |> render("401.json", message: reason)
  end
end
