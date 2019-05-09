defmodule MateriaWeb.TagControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Tags
  alias Materia.Tags.Tag

  alias Materia.Accounts
  alias Materia.Accounts.Account

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "merge and search test" do
    test "tag life cycle", %{conn: conn} do

      # merge tag
      params = %{"tag_category" => "merge_test001", "label" => "Elixir01"}
      conn = post(conn, tag_path(conn, :merge, params))
      resp = json_response(conn, 201)
      assert resp["tag_category"] == "merge_test001"
      assert resp["normalized"] == "elixir01"

      # merge tag
      params = %{"tag_category" => "merge_test001", "label" => "Elixir02"}
      conn = post(conn, tag_path(conn, :merge, params))
      resp = json_response(conn, 201)
      assert resp["tag_category"] == "merge_test001"
      assert resp["normalized"] == "elixir02"

      # merge tag
      params = %{"tag_category" => "merge_test001", "label" => "Elixir01"}
      conn = post(conn, tag_path(conn, :merge, params))
      resp = json_response(conn, 201)
      assert resp["tag_category"] == "merge_test001"
      assert resp["normalized"] == "elixir01"

      # merge ather catetory tag
      params = %{"tag_category" => "merge_test001_02", "label" => "Elixir01"}
      conn = post(conn, tag_path(conn, :merge, params))
      resp = json_response(conn, 201)
      assert resp["tag_category"] == "merge_test001_02"
      assert resp["normalized"] == "elixir01"

      # search tag
      params = %{"tag_category" => "merge_test001", "search_string" => "e%"}
      conn = post(conn, tag_path(conn, :list_tags_by_normalized, params))
      resp = json_response(conn, 200)
      assert length(resp) == 2

      # search tag
      params = %{"tag_category" => "merge_test001_02", "search_string" => "%"}
      conn = post(conn, tag_path(conn, :list_tags_by_normalized, params))
      resp = json_response(conn, 200)
      assert length(resp) == 1


      #list_tags_by_normalized

      ## 一覧紹介
      #conn_index0 = get(conn_auth, account_path(conn, :index))
      #resp_index0 = json_response(conn_index0, 200)
#
      ## check log
      #params = %{"and" => [%{"req_path" => "/api/accounts"}]}
      #conn = post(conn, conn_log_path(conn, :list_conn_logs_by_params, params))
      #resp = json_response(conn, 200)
      #log = resp
      #|> List.last()
      #assert log == %{
      #  "assigns" => "%{}",
      #  "id" => log["id"],
      #  "inserted_at" => log["inserted_at"],
      #  "owner_pid" => log["owner_pid"],
      #  "remote_ip" => log["remote_ip"],
      #  "req_body_params" => "%{}",
      #  "req_headers" => log["req_headers"],
      #  "req_method" => "GET",
      #  "req_path" => "/api/accounts",
      #  "req_path_params" => "%{}",
      #  "user_agent" => nil,
      #  "user_id" => 1
      #}
    end
  end
end
