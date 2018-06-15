defmodule ServicexWeb.GrantControllerTest do
  use ServicexWeb.ConnCase

  alias Servicex.Accounts
  alias Servicex.Accounts.Grant

  @create_attrs %{request_path: "some request_path", role: "some role"}
  @update_attrs %{request_path: "some updated request_path", role: "some updated role"}
  @invalid_attrs %{request_path: nil, role: nil}

  def fixture(:grant) do
    {:ok, grant} = Accounts.create_grant(@create_attrs)
    grant
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all grants", %{conn: conn} do
      conn = get conn, grant_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create grant" do
    test "renders grant when data is valid", %{conn: conn} do
      conn = post conn, grant_path(conn, :create), grant: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, grant_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "request_path" => "some request_path",
        "role" => "some role"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, grant_path(conn, :create), grant: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update grant" do
    setup [:create_grant]

    test "renders grant when data is valid", %{conn: conn, grant: %Grant{id: id} = grant} do
      conn = put conn, grant_path(conn, :update, grant), grant: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, grant_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "request_path" => "some updated request_path",
        "role" => "some updated role"}
    end

    test "renders errors when data is invalid", %{conn: conn, grant: grant} do
      conn = put conn, grant_path(conn, :update, grant), grant: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete grant" do
    setup [:create_grant]

    test "deletes chosen grant", %{conn: conn, grant: grant} do
      conn = delete conn, grant_path(conn, :delete, grant)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, grant_path(conn, :show, grant)
      end
    end
  end

  defp create_grant(_) do
    grant = fixture(:grant)
    {:ok, grant: grant}
  end
end
