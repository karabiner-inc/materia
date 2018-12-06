defmodule MateriaWeb.OrganizationControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Organizations
  alias Materia.Organizations.Organization

  @operator_user_attrs %{
    name: "fugafuga",
    email: "fugafuga@example.com",
    password: "fugafuga",
    role: "operator"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # :name, :hp_url, :profile_img_url, :back_ground_img_url, :one_line_message, :phone_number, :status, :lock_version

  describe "Organizations REST API" do
    test "CRUD test", %{conn: conn} do
      # オペレーターログイン
      token_conn = post(conn, authenticator_path(conn, :sign_in), @operator_user_attrs)
      %{"access_token" => token} = json_response(token_conn, 201)
      conn_auth = put_req_header(conn, "authorization", "Bearer " <> token)

      # 一覧紹介
      conn_index0 = get(conn_auth, organization_path(conn, :index))
      resp_index0 = json_response(conn_index0, 200)
      assert length(resp_index0) == 1

      # 登録
      conn =
        post(conn_auth, organization_path(conn, :create), %{
          "name" => "some name",
          "hp_url" => "some hp_url",
          "profile_img_url" => "some profile_img_url",
          "back_ground_img_url" => "some back_ground_img_url",
          "one_line_message" => "some one_line_message",
          "phone_number" => "some phone_number",
          "status" => Organization.status.active,
        })

      assert %{"id" => id} = json_response(conn, 201)

      # 一覧紹介
      conn_index1 = get(conn_auth, organization_path(conn, :index))
      resp_index1 = json_response(conn_index1, 200)
      assert length(resp_index1) == 2

      # 更新
      conn_update =
        put(conn_auth, organization_path(conn, :update, id), %{
          "name" => "updated name",
          "hp_url" => "updated hp_url",
          "profile_img_url" => "updated profile_img_url",
          "back_ground_img_url" => "updated back_ground_img_url",
          "one_line_message" => "updated one_line_message",
          "phone_number" => "updated phone_number",
          "status" => Organization.status.unactive,
          "lock_version" => 1
        })

        resp_update = json_response(conn_update, 200)

      # 照会
      conn_show = get(conn_auth, organization_path(conn, :show, id))
      resp_show = json_response(conn_show, 200)

      assert resp_show["lock_version"]  == 2

      # 削除
      conn_del = delete(conn_auth, organization_path(conn, :delete, id))
      resp_del = response(conn_del, 204)

      conn_index2 = get(conn_auth, organization_path(conn, :index))
      resp_index2 = json_response(conn_index2, 200)
      assert length(resp_index2) == 1
    end
  end
end
