defmodule Materia.Plug.ConnLogger do
  import Plug.Conn

  alias Materia.UserAuthenticator
  alias Materia.Logs
  alias Guardian.Token.Jwt

  require Logger

  def init(opts) do
    Logger.debug("#{__MODULE__}--- init---------------------")
  end

  def call(conn, opts) do
    Logger.debug("#{__MODULE__}--- call ---------------------")
    authorization = List.keyfind(conn.req_headers, "authorization", 0)
    user_agent = List.keyfind(conn.req_headers, "user_agent", 0)

    user_id =
      if authorization != nil do
        Logger.debug("#{__MODULE__}--- call authorization is not nil.")
        {"authorization", token} = authorization

        access_token =
          token
          |> String.split(" ")
          |> List.last()

        try do
          {:ok, claims} = Jwt.decode_token(UserAuthenticator, access_token)
          user_id = UserAuthenticator.get_user_id_from_claims(claims)
          Logger.debug("#{__MODULE__}--- call user_id:#{user_id}")
          user_id
        rescue
          e ->
            Logger.info("#{__MODULE__}--- call Jwt.decode_token excepton occured.")
            Logger.info("inspect(e)")
            nil
        end
      else
        nil
      end

    body_params = filter_password(conn.body_params)

    params = %{
      user_id: user_id,
      remote_ip: inspect(conn.remote_ip),
      user_agent: user_agent,
      owner_pid: inspect(conn.owner),
      req_headers: inspect(conn.req_headers),
      req_method: conn.method,
      req_path: conn.request_path,
      req_path_params: inspect(conn.path_params),
      req_body_params: inspect(body_params),
      assigns: inspect(conn.assigns)
    }

    {:ok, conn_log} = Logs.create_conn_log(params)
    conn
  end

  def filter_password(params) when is_map(params) do
    Logger.debug("#{__MODULE__}--- filter_password params ismap")
    password = Map.get(params, "password")

    _new_params =
      if password == nil do
        params
      else
        Map.put(params, "password", "[FILTERED]")
      end
  end

  def filter_password(params) do
    Logger.debug("#{__MODULE__}--- filter_password params is not map")
    params
  end
end
