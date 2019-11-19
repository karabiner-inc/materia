defmodule Materia.Plug.Debug do
  import Plug.Conn

  def init(opts) do
    IO.puts("--- Materia.Plug.Debug init---------------------")
    IO.inspect(opts)
  end

  def call(conn, _repo) do
    IO.puts("--- Materia.Plug.Debug call conn ---------------------")
    IO.inspect(conn)
  end
end
