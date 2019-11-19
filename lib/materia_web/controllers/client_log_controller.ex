defmodule MateriaWeb.ClientLogController do
  use MateriaWeb, :controller

  alias Materia.Logs
  alias Materia.Logs.ClientLog

  action_fallback(MateriaWeb.FallbackController)

  def create(conn, client_log_params) do
    with {:ok, %ClientLog{} = client_log} <- Logs.create_client_log(client_log_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", client_log_path(conn, :show, client_log))
      |> render("show.json", client_log: client_log)
    end
  end

  def show(conn, params) do
    client_log = Logs.get_client_log!(params["id"])
    render(conn, "show.json", client_log: client_log)
  end

  def list_client_logs_by_params(conn, params) do
    client_logs = Logs.list_client_logs_by_params(params)
    render(conn, "index.json", client_logs: client_logs)
  end
end
