defmodule MateriaWeb.AddressControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Accounts
  alias Materia.Accounts.Address

  @operator_user_attrs %{
    name: "fugafuga",
    email: "fugafuga@example.com",
    password: "fugafuga",
    role: "operator"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # :location, :zip_code, :address1, :address2, :latitude, :longitude, :user_id, :organization_id, :subject, :lock_version]

  describe "Address REST API" do
    test "CRUD test", %{conn: conn} do
      # オペレーターログイン
      token_conn = post(conn, authenticator_path(conn, :sign_in), @operator_user_attrs)
      %{"access_token" => token} = json_response(token_conn, 201)
      conn_auth = put_req_header(conn, "authorization", "Bearer " <> token)

      # 一覧紹介
      conn_index0 = get(conn_auth, address_path(conn, :index))
      resp_index0 = json_response(conn_index0, 200)
      assert length(resp_index0) == 4

      # 登録
      conn_create =
        post(conn_auth, address_path(conn, :create), %{
          "location" => "some location",
          "zip_code" => "some zip_code",
          "address1" => "some address1",
          "address2" => "some address2",
          "latitude" => 0.1,
          "user_id" => 1,
          "organization_id" => 1,
          "subject" => "some subject"
        })

      assert %{"id" => id} = json_response(conn_create, 201)

      # 一覧紹介
      conn_index1 = get(conn_auth, address_path(conn, :index))
      resp_index1 = json_response(conn_index1, 200)
      assert length(resp_index1) == 5

      # 更新
      conn_update =
        put(conn_auth, address_path(conn, :update, id), %{
          "location" => "updated location",
          "zip_code" => "updated zip_code",
          "address1" => "updated address1",
          "address2" => "updated address2",
          "latitude" => 0.2,
          "user_id" => 2,
          "organization_id" => 1,
          "subject" => "updated subject",
          "lock_version" => 0
        })

      resp_update = json_response(conn_update, 200)

      # 照会
      conn_show = get(conn_auth, address_path(conn, :show, id))
      resp_show = json_response(conn_show, 200)

      assert resp_show["lock_version"] == 1

      # 削除
      conn_del = delete(conn_auth, address_path(conn, :delete, id))
      resp_del = response(conn_del, 204)

      conn_index2 = get(conn_auth, address_path(conn, :index))
      resp_index2 = json_response(conn_index2, 200)
      assert length(resp_index2) == 4
    end

    test "create my_address test", %{conn: conn} do
      # オペレーターログイン
      token_conn = post(conn, authenticator_path(conn, :sign_in), @operator_user_attrs)
      resp_token = json_response(token_conn, 201)
      token = resp_token["access_token"]
      ope_id = resp_token["id"]
      conn_auth = put_req_header(conn, "authorization", "Bearer " <> token)

      # 一覧紹介
      conn_index0 = get(conn_auth, address_path(conn, :index))
      resp_index0 = json_response(conn_index0, 200)
      assert length(resp_index0) == 4

      # 登録
      conn_create =
        post(conn_auth, address_path(conn, :create_my_address), %{
          "location" => "some location",
          "zip_code" => "some zip_code",
          "address1" => "some address1",
          "address2" => "some address2",
          "latitude" => 0.1,
          "user_id" => 999_999,
          "subject" => "some subject"
        })

      assert %{"id" => id} = json_response(conn_create, 201)

      # 紹介(認証者本人のアドレスが登録された)
      conn_show = get(conn_auth, address_path(conn, :show, id))
      resp_show = json_response(conn_show, 200)
      assert resp_show["user"]["id"] == ope_id

      # 削除
      conn_del = delete(conn_auth, address_path(conn, :delete, id))
      resp_del = response(conn_del, 204)

      conn_index2 = get(conn_auth, address_path(conn, :index))
      resp_index2 = json_response(conn_index2, 200)
      assert length(resp_index2) == 4
    end
  end
end
