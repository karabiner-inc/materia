defmodule MateriaWeb.ConnLogView do
  use MateriaWeb, :view
  alias MateriaWeb.ConnLogView

  def render("index.json", %{conn_logs: conn_logs}) do
    render_many(conn_logs, ConnLogView, "conn_log.json")
  end

  def render("show.json", %{conn_log: conn_log}) do
    render_one(conn_log, ConnLogView, "conn_log.json")
  end

  def render("conn_log.json", %{conn_log: conn_log}) do
    %{
      id: conn_log.id,
      user_id: conn_log.user_id,
      remote_ip: conn_log.remote_ip,
      user_agent: conn_log.user_agent,
      owner_pid: conn_log.owner_pid,
      req_headers: conn_log.req_headers,
      req_method: conn_log.req_method,
      req_path: conn_log.req_path,
      req_path_params: conn_log.req_path_params,
      req_body_params: conn_log.req_body_params,
      assigns: conn_log.assigns,
      inserted_at: conn_log.inserted_at
    }
  end
end
