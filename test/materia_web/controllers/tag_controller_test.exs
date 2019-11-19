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
    end
  end
end
