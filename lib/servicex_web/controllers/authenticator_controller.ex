defmodule ServicexWeb.AuthenticatorController do
  @moduledoc """
  """
  use ServicexWeb, :controller

  #import Comeonin.Bcrypt, only: [ checkpw: 2]

  #alias Servicex.Accounts
  #alias Servicex.Accounts.User

  require Logger

  #def sign_in(conn, _params = %{ "email" => email, "password" => password }) do
  #  claims = %{"email" => email}
  #  with {:ok,  nil} <- Servicex.Authenticator.resource_from_claims(claims) do
  #    handle_unauthenticated(conn, "email or password is invalid")
  #  else
  #    {:ok,  resource} ->
  #       _conn =
  #       if Comeonin.Bcrypt.checkpw(password, resource.hashed_password) do
  #        Logger.debug("#{__MODULE__} --- sign_in Comeonin.Bcrypt.checkpw == true")
  #         with {:ok, token, _claims} <- Servicex.Authenticator.encode_and_sign(resource) do
  #          Logger.debug("#{__MODULE__} --- sign_in Servicex.Authenticator.encode_and_sign ok")
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
  #end

  def sign_in(conn, _params = %{ "email" => email, "password" => password }) do
    Logger.debug("--- ServicexWeb.AuthenticateController sign_in_with_refresh-----------------")

    with {:ok, result} <- Servicex.Authenticator.sign_in(email, password) do
      authenticator =
      if Map.has_key?(result, :refresh_token) do
        %{id: result.id ,access_token: result.access_token, refresh_token: result.refresh_token}
      else
        %{id: result.id ,access_token: result.access_token}
      end
    conn
      |> put_status(:created)
      |> render("show.json", authenticator: authenticator)
    else
      {:error, message} ->
        handle_unauthenticated(conn, message)
    end

  end

  def refresh(conn, _params = %{ "refresh_token" => refresh_token}) do
    with {:ok, access, _refresh } <- Servicex.Authenticator.refresh_tokens(refresh_token) do
      {access_token, _access_claims} = access
      {refresh_token, refresh_claims} = access
      conn
        |> put_status(:created)
        |> render("show.json", authenticator: %{id: refresh_claims["sub"] ,access_token: access_token, refresh_token: refresh_token})
      else
        {:error, message} ->
          handle_unauthenticated(conn, message)
      end
  end

  def sign_out(conn, _params) do
    Logger.debug("--- ServicexWeb.AuthenticateController sign_out-----------------")
    token = conn.private[:guardian_default_token]
    with {:ok, _claims} = Servicex.Authenticator.revoke(token) do
      conn
      |> put_status(200)
      |> render("delete.json", [])
    end
  end

  def is_authenticated(conn, _params) do
    Logger.debug("--- ServicexWeb.AuthenticateController is_authenticated-----------------")
    send_resp(conn, 200, "{\"message\":\"authenticated\"}")
  end

  def is_varid_tmp_user(conn, _params) do
    Logger.debug("--- ServicexWeb.AuthenticateController is_varid_user_registration_token-----------------")
    send_resp(conn, 200, "{\"message\":\"authenticated\"}")
  end


  defp handle_unauthenticated(conn, reason) do
    conn
    |> put_status(:unauthorized)
    |> render("401.json", message: reason)
  end

end

