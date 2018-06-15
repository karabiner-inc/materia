defmodule Servicex.Plug.GrantChecker do
  import Plug.Conn

  require Logger

  alias Servicex.Accounts

  def init(opts) do
    Logger.debug("#{__MODULE__}--- init---------------------")
    IO.inspect(opts)
  end

  def call(conn, opts) do
    Logger.debug("#{__MODULE__}--- call ---------------------")
    user = Accounts.get_user!(conn.private.guardian_default_claims["sub"])
    grants = Accounts.get_grant_by_role(user.role)
    has_grant? = grants
    |> Enum.any?(fn(grant) -> ( grant.method == "ANY" or grant.method == conn.method ) and Regex.match?(~r/#{grant.request_path}[0-9]*/,conn.request_path) end)

    if has_grant? do
      Logger.debug("#{__MODULE__}--- call has_grant?:#{has_grant?}---------------------")
      conn
    else
      Logger.debug("#{__MODULE__}--- call has_grant?:#{has_grant?}---------------------")
      keyword = Keyword.get(opts, :error_handler, conn.private[:guardian_error_handler])
      Logger.debug("#{__MODULE__}--- call keyword---------------------")
      IO.inspect(keyword)
      conn
      |> halt()
      |> send_resp(401, Poison.encode!(%{message: "no grant"}))
    end
  end

end
