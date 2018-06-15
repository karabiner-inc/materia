defmodule ServicexWeb.AuthenticatorController do
  @moduledoc """
  """
  use ServicexWeb, :controller

  import Comeonin.Bcrypt, only: [ checkpw: 2]

  alias Servicex.Accounts
  alias Servicex.Accounts.User

  require Logger

  #def sign_in(conn, params = %{ "email" => email, "password" => password}) do
  def sign_in(conn, params = %{ "email" => email, "password" => password }) do
    #email = operator["email"]
    claims = %{"email" => email}
    with {:ok,  nil} <- Servicex.Authenticator.resource_from_claims(claims) do
      handle_unauthenticated(conn, "email or password is invalid")
    else
      {:ok,  resource} ->
         Logger.debug("#{__MODULE__} --- sign_in resource-----------------")
         IO.inspect(resource)
         conn =
         if Comeonin.Bcrypt.checkpw(password, resource.hashed_password) do
          Logger.debug("#{__MODULE__} --- sign_in Comeonin.Bcrypt.checkpw == true")
           with {:ok, token, claims} <- Servicex.Authenticator.encode_and_sign(resource) do
            Logger.debug("#{__MODULE__} --- sign_in Servicex.Authenticator.encode_and_sign ok")
            Logger.debug("#{__MODULE__} --- sign_in token:#{token}")
             conn
             |> put_status(:created)
             |> render("show.json", authenticator: %{id: resource.id ,token: token})
           else
             _ -> handle_unauthenticated(conn, "email or password is invalid")
           end
         else
           handle_unauthenticated(conn, "email or password is invalid")
         end
      _ ->
        handle_unauthenticated(conn, "email or password is invalid")
    end

  end

  def sign_out(conn, _params) do
    Logger.debug("--- ServicexWeb.AuthenticateController sign_out-----------------")
    token = conn.private[:guardian_default_token]
    Logger.debug("#{__MODULE__} ---  token:#{token}")
    #IO.inspect(conn.private)
    with {:ok, claims} = Servicex.Authenticator.revoke(token) do
      IO.inspect(claims)
      conn
      |> put_status(200)
      |> render("delete.json", [])
    end
  end



  defp handle_unauthenticated(conn, reason) do
    conn
    |> put_status(:unauthorized)
    |> render("401.json", message: reason)
  end

end

