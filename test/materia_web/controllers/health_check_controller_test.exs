defmodule MateriaWeb.HealthCheckControllerTest do
  use MateriaWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "health check test" do
    test "health check ok", %{conn: conn} do
      get_conn = get(conn, health_check_path(conn, :health_check))
      resp = response(get_conn, 200)
      assert resp == "{\"message\":\"health_check_ok\"}"
    end

    test "health check ng", %{conn: conn} do
      # change repo config for unexpected error.
      config_repo = Application.get_env(:materia, :repo)
      Application.put_env(:materia, :repo, Materia.NotExist.Repo, persistent: true)

      get_conn = get(conn, health_check_path(conn, :health_check))
      resp = response(get_conn, 500)
      assert resp == "{\"message\":\"health_check_ng\"}"

      # recover repo config for next test case
      Application.put_env(:materia, :repo, config_repo, persistent: true)
    end
  end
end
