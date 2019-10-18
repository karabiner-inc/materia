defmodule MateriaWeb.GrantControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Accounts
  alias Materia.Accounts.Grant

  @create_attrs %{request_path: "some request_path", method: "ANY", role: "some role"}
  @update_attrs %{request_path: "some updated request_path", method: "GET", role: "some updated role"}

  @admin_user_attrs %{
    name: "hogehoge",
    email: "hogehoge@example.com",
    password: "hogehoge",
    role: "admin"
  }

  defp log_in(_) do
    token_conn = post(conn, authenticator_path(conn, :sign_in), @admin_user_attrs)
    %{"access_token" => token} = json_response(token_conn, 201)
    {:ok, token: token}
  end

  describe "grant CRUD" do
    setup [:log_in]

    test "create grant", %{conn: conn, token: token} do
      conn = put_req_header(conn, "authorization", "Bearer " <> token)
      create_conn = post(conn, grant_path(conn, :create), @create_attrs)

      assert json_response(create_conn, 201) |> Map.delete("id") == %{
               "role" => "some role",
               "method" => "ANY",
               "request_path" => "some request_path"
             }
    end

    test "update grant", %{conn: conn, token: token} do
      conn = put_req_header(conn, "authorization", "Bearer " <> token)
      update_conn = put(conn, grant_path(conn, :update, 3), @update_attrs)

      assert json_response(update_conn, 200) |> Map.delete("id") == %{
               "role" => "some updated role",
               "method" => "GET",
               "request_path" => "some updated request_path"
             }
    end

    test "delete grant", %{conn: conn, token: token} do
      conn = put_req_header(conn, "authorization", "Bearer " <> token)
      delete_conn = delete(conn, grant_path(conn, :delete, 3))
      assert response(delete_conn, 204) == ""
    end
  end
end
