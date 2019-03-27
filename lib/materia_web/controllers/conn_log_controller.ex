defmodule MateriaWeb.ConnLogController do
  use MateriaWeb, :controller

  alias Materia.Logs
  alias Materia.Logs.ConnLog

  action_fallback MateriaWeb.FallbackController

  def show(conn, %{"id" => id}) do
    conn_log = Logs.get_conn_log!(id)
    render(conn, "show.json", conn_log: conn_log)
  end

  def list_conn_logs_by_params(conn, params) do
    conn_logs = Logs.list_conn_logs_by_params(params)
    render(conn, "index.json", conn_logs: conn_logs)
  end

end
