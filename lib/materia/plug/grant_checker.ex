defmodule Materia.Plug.GrantChecker do
  import Plug.Conn

  require Logger

  alias Materia.Accounts
  alias Materia.Accounts.Grant

  def init(opts) do
    Logger.debug("#{__MODULE__}--- init---------------------")
  end

  def call(conn, opts) do
    Logger.debug("#{__MODULE__}--- call ---------------------")
    user = Accounts.get_user!(conn.private.guardian_default_claims["sub"])
    grants = Accounts.get_grant_by_role(user.role)
    has_grant? = grants
    |> Enum.any?(fn(grant) -> ( String.upcase(grant.method) == Grant.method.any or String.upcase(grant.method) == conn.method ) and Regex.match?(~r/#{grant.request_path}[0-9]*/,conn.request_path) end)

    conn =
    if has_grant? do
      Logger.debug("#{__MODULE__}--- call has_grant?:#{has_grant?}---------------------")
      conn
    else
      Logger.debug("#{__MODULE__}--- call has_grant?:#{has_grant?}---------------------")
      conn
      |> halt()
      |> send_resp(401, Poison.encode!(%{message: "no grant"}))
    end
    conn
  end

end
