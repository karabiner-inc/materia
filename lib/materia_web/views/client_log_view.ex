defmodule MateriaWeb.ClientLogView do
  use MateriaWeb, :view
  alias MateriaWeb.ClientLogView

  def render("index.json", %{client_logs: client_logs}) do
    render_many(client_logs, ClientLogView, "client_log.json")
  end

  def render("show.json", %{client_log: client_log}) do
    render_one(client_log, ClientLogView, "client_log.json")
  end

  def render("client_log.json", %{client_log: client_log}) do
    %{
      id: client_log.id,
      log_datetime: client_log.log_datetime,
      user_id: client_log.user_id,
      client_ip: client_log.client_ip,
      user_agent: client_log.user_agent,
      routing_path: client_log.routing_path,
      evidence_url: client_log.evidence_url,
      trace_log: client_log.trace_log
    }
  end
end
