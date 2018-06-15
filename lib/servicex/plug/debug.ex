defmodule Servicex.Plug.Debug do
  import Plug.Conn

  def init(opts) do
    IO.puts("--- Servicex.Plug.Debug init---------------------")
    IO.inspect(opts)
  end

  def call(conn, _repo) do
    IO.puts("--- Servicex.Plug.Debug call conn ---------------------")
    IO.inspect(conn)
    #IO.puts("--- Servicex.Plug.Debug call maybe_user ---------------------")
    #maybe_user = Servicex.Authenticator.Plug.current_resource(conn)
    #IO.inspect(maybe_user)
    #sub = conn.private.guardian_default_claims["sub"]
    #IO.puts("--- Servicex.Plug.Debug call sub:#{sub}")
    #conn
  end

end
