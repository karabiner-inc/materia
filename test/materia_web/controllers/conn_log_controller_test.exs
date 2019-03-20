defmodule MateriaWeb.ConnLogControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Logs
  alias Materia.Logs.ConnLog

  alias Materia.Accounts
  alias Materia.Accounts.Account

  @admin_user_attrs %{
    account: "hogehoge_code",
    email: "hogehoge@example.com",
    password: "hogehoge"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "logging and search test" do
    test "conn log life cycle", %{conn: conn} do
      # オペレーターログイン
      token_conn = post(conn, authenticator_path(conn, :sign_in), @admin_user_attrs)
      resp_sgin_in = json_response(token_conn, 201)
      %{"access_token" => token} = resp_sgin_in
      %{"id" => user_id} = resp_sgin_in
      conn_auth = put_req_header(conn, "authorization", "Bearer " <> token)

      # check log
      params = %{"and" => [%{"req_path" => "/api/sign-in"}]}
      conn = post(conn, conn_log_path(conn, :list_conn_logs_by_params, params))
      resp = json_response(conn, 200)
      log = resp
      |> List.last()
      assert log == %{
        "assigns" => "%{}",
        "id" => log["id"],
        "inserted_at" => log["inserted_at"],
        "owner_pid" => log["owner_pid"],
        "remote_ip" => log["remote_ip"],
        "req_body_params" =>
          "%{\"account\" => \"hogehoge_code\", \"email\" => \"hogehoge@example.com\", \"password\" => \"[FILTERED]\"}",
        "req_headers" =>
          "[{\"accept\", \"application/json\"}, {\"content-type\", \"multipart/mixed; boundary=plug_conn_test\"}]",
        "req_method" => "POST",
        "req_path" => "/api/sign-in",
        "req_path_params" => "%{}",
        "user_agent" => nil,
        "user_id" => nil
      }

      # 一覧紹介
      conn_index0 = get(conn_auth, account_path(conn, :index))
      resp_index0 = json_response(conn_index0, 200)

      # check log
      params = %{"and" => [%{"req_path" => "/api/accounts"}]}
      conn = post(conn, conn_log_path(conn, :list_conn_logs_by_params, params))
      resp = json_response(conn, 200)
      log = resp
      |> List.last()
      assert log == %{
        "assigns" => "%{}",
        "id" => log["id"],
        "inserted_at" => log["inserted_at"],
        "owner_pid" => log["owner_pid"],
        "remote_ip" => log["remote_ip"],
        "req_body_params" => "%{}",
        "req_headers" => log["req_headers"],
        "req_method" => "GET",
        "req_path" => "/api/accounts",
        "req_path_params" => "%{}",
        "user_agent" => nil,
        "user_id" => 1
      }
    end
  end
end
