defmodule MateriaWeb.ClientLogControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Logs
  alias Materia.Logs.ClientLog

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create client_log" do
    test "renders client_log when data is valid", %{conn: conn} do
      create_attrs = %{
        client_ip: "some client_ip",
        evidence_url: "some evidence_url",
        log_datetime: "2010-04-17 14:00:00.000000Z",
        routing_path: "some routing_path",
        trace_log: "some trace_log",
        user_agent: "some user_agent",
        user_id: 42
      }

      conn = post(conn, client_log_path(conn, :create), create_attrs)
      resp = json_response(conn, 201)

      conn = get(conn, client_log_path(conn, :show, resp["id"]))

      assert resp == %{
               "id" => resp["id"],
               "client_ip" => "some client_ip",
               "evidence_url" => "some evidence_url",
               "log_datetime" => "2010-04-17T14:00:00.000000Z",
               "routing_path" => "some routing_path",
               "trace_log" => "some trace_log",
               "user_agent" => "some user_agent",
               "user_id" => 42
             }

      params = %{"and" => [%{"id" => resp["id"]}]}
      conn = post(conn, client_log_path(conn, :list_client_logs_by_params, params))
      req = json_response(conn, 200)

      assert resp == %{
               "id" => resp["id"],
               "client_ip" => "some client_ip",
               "evidence_url" => "some evidence_url",
               "log_datetime" => "2010-04-17T14:00:00.000000Z",
               "routing_path" => "some routing_path",
               "trace_log" => "some trace_log",
               "user_agent" => "some user_agent",
               "user_id" => 42
             }
    end
  end
end
