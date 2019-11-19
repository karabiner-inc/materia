defmodule MateriaWeb.AccountControllerTest do
  use MateriaWeb.ConnCase

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

  # :location, :zip_code, :address1, :address2, :latitude, :longitude, :user_id, :organization_id, :subject, :lock_version]

  describe "Account REST API" do
    test "CRUD test", %{conn: conn} do
      # オペレーターログイン
      token_conn = post(conn, authenticator_path(conn, :sign_in), @admin_user_attrs)
      resp_sgin_in = json_response(token_conn, 201)
      %{"access_token" => token} = resp_sgin_in
      %{"id" => user_id} = resp_sgin_in
      conn_auth = put_req_header(conn, "authorization", "Bearer " <> token)

      # 一覧紹介
      conn_index0 = get(conn_auth, account_path(conn, :index))
      resp_index0 = json_response(conn_index0, 200)
      assert length(resp_index0) == 1

      # 登録
      conn_create =
        post(conn_auth, account_path(conn, :create), %{
          "external_code" => "some external_code",
          "name" => "some name",
          "descriptions" => "some descriptions",
          "organization" => 1,
          "main_user_id" => 1
        })

      resp_create = json_response(conn_create, 201)

      # 照会
      conn_show = get(conn_auth, account_path(conn, :show, resp_create["id"]))

      resp_show = json_response(conn_show, 200)

      assert Map.delete(resp_show, "id") |> Map.delete("start_datetime") == %{
               "descriptions" => "some descriptions",
               "expired_datetime" => nil,
               "external_code" => "some external_code",
               "frozen_datetime" => nil,
               "lock_version" => 0,
               "main_user" => nil,
               "name" => "some name",
               "organization" => nil,
               "status" => 1
             }

      assert resp_create["start_datetime"] != nil

      # 汎用検索
      conn_show1 =
        post(conn_auth, account_path(conn, :list_accounts_by_params), %{
          "and" => [%{"external_code" => "some external_code"}]
        })

      resp_show1 = json_response(conn_show1, 200)
      assert length(resp_show1) == 1

      # 所属組織のアカウントを取得
      conn_show2 = get(conn_auth, account_path(conn, :show_my_account))
      resp_show2 = json_response(conn_show2, 200)
      assert resp_show2["name"] == "hogehoge account"

      # アカウント凍結
      conn_update =
        put(conn_auth, account_path(conn, :update, resp_create["id"]), %{
          "external_code" => "updated external_code",
          "name" => "updated name",
          "descriptions" => "updated descriptions",
          "status" => Account.status().frozen
        })

      resp_update = json_response(conn_update, 200)

      assert resp_update["frozen_datetime"] != nil

      # アカウント閉鎖
      conn_update2 =
        put(conn_auth, account_path(conn, :update, resp_create["id"]), %{
          "status" => Account.status().expired
        })

      resp_update2 = json_response(conn_update2, 200)

      assert resp_update2["expired_datetime"] != nil

      # 削除
      conn_del = delete(conn_auth, account_path(conn, :delete, resp_create["id"]))
      resp_del = response(conn_del, 204)

      # 汎用検索
      conn_show4 =
        post(conn_auth, account_path(conn, :list_accounts_by_params), %{
          "and" => [%{"external_code" => "updated external_code"}]
        })

      resp_show4 = json_response(conn_show4, 200)
      assert resp_show4 == []
      assert length(resp_show4) == 0
    end
  end
end
