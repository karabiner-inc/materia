defmodule MateriaWeb.UserControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Accounts
  alias Materia.Accounts.User

  @create_attrs %{email: "some email", hashed_password: "some hashed_password", name: "some name", role: "some role"}
  @update_attrs %{email: "some updated email", hashed_password: "some updated hashed_password", name: "some updated name", role: "some updated role"}
  @invalid_attrs %{email: nil, hashed_password: nil, name: nil, role: nil}

  @admin_user_attrs %{
    "name": "hogehoge",
    "email": "hogehoge@example.com",
    "password": "hogehoge",
    "role": "admin"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "admin_user" do
    test "admin user ligin cycle", %{conn: conn} do
      token_conn = post conn, authenticator_path(conn, :sign_in), @admin_user_attrs
      %{"access_token" => token } = json_response(token_conn, 201)
      #IO.puts(token)
      conn = put_req_header(conn, "authorization", "Bearer " <> token)

      # show self info
      show_me_conn = get conn, user_path(conn, :show_me)
      assert json_response(show_me_conn, 200) == %{
               "email" => "hogehoge@example.com",
               "id" => 1,
               "name" => "hogehoge",
               "role" => "admin",
               "addresses" => [
                 %{
                   "address1" => "福岡市中央区",
                   "address2" => "大名 x-x-xx",
                   "id" => 2,
                   "latitude" => nil,
                   "location" => "福岡県",
                   "lock_version" => 0,
                   "longitude" => nil,
                   "organization" => nil,
                   "subject" => "billing",
                   "user" => [],
                   "zip_code" => "810-ZZZZ",
                   "address1_p" => "address1_p",
                   "address2_p" => "address2_p",
                   "address3" => "address3",
                   "address3_p" => "address3_p",
                   "notation_name" => "notation_name",
                   "notation_org_name" => "notation_org_name",
                   "notation_org_name_p" => "notation_org_name_p",
                   "notation_name_p" => "notation_name_p",
                   "phone_number" => "phone_number",
                   "fax_number" => "fax_number",
                 },
                 %{
                   "address1" => "福岡市中央区",
                   "address2" => "港 x-x-xx",
                   "id" => 1,
                   "latitude" => nil,
                   "location" => "福岡県",
                   "lock_version" => 0,
                   "longitude" => nil,
                   "organization" => nil,
                   "subject" => "living",
                   "user" => [],
                   "zip_code" => "810-ZZZZ",
                   "address1_p" => "address1_p",
                   "address2_p" => "address2_p",
                   "address3" => "address3",
                   "address3_p" => "address3_p",
                   "notation_name" => "notation_name",
                   "notation_org_name" => "notation_org_name",
                   "notation_org_name_p" => "notation_org_name_p",
                   "notation_name_p" => "notation_name_p",
                   "phone_number" => "phone_number",
                   "fax_number" => "fax_number",
                 }
               ],
               "back_ground_img_url" => nil,
               "descriptions" => nil,
               "external_user_id" => nil,
               "icon_img_url" => nil,
               "lock_version" => 2,
               "organization" => %{
                 "addresses" => [],
                 "back_ground_img_url" => "https://hogehoge.com/ib_img.jpg",
                 "hp_url" => "https://hogehoge.inc",
                 "id" => 1,
                 "lock_version" => 1,
                 "name" => "hogehoge.inc",
                 "one_line_message" => "let's do this.",
                 "phone_number" => nil,
                 "fax_number" => "fax_number",
                 "profile_img_url" => "https://hogehoge.com/prof_img.jpg",
                 "status" => 1,
                 "users" => [],
                 "ext_organization_branch_id" => "ext_organization_branch_id",
                 "ext_organization_id" => "ext_organization_id",
                 "name_p" => "name_p"
               },
               "phone_number" => nil,
               "fax_number" => "fax_number",
               "status" => 1,
               "name_p" => "name_p"
             }

      # show user list (allow anybody)
      users_conn = get conn, user_path(conn, :index)
      assert json_response(users_conn, 200) == [
               %{
                 "email" => "fugafuga@example.com",
                 "id" => 2,
                 "name" => "fugafuga",
                 "role" => "operator",
                 "addresses" => [],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "lock_version" => 1,
                 "organization" => nil,
                 "phone_number" => nil,
                 "fax_number" => "fax_number",
                 "status" => 1,
                 "name_p" => "name_p"
               },
               %{
                 "email" => "hogehoge@example.com",
                 "id" => 1,
                 "name" => "hogehoge",
                 "role" => "admin",
                 "addresses" => [
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "港 x-x-xx",
                     "id" => 1,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "living",
                     "user" => [],
                     "zip_code" => "810-ZZZZ",
                     "address1_p" => "address1_p",
                     "address2_p" => "address2_p",
                     "address3" => "address3",
                     "address3_p" => "address3_p",
                     "notation_name" => "notation_name",
                     "notation_org_name" => "notation_org_name",
                     "notation_org_name_p" => "notation_org_name_p",
                     "notation_name_p" => "notation_name_p",
                     "phone_number" => "phone_number",
                     "fax_number" => "fax_number",
                   },
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "大名 x-x-xx",
                     "id" => 2,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "billing",
                     "user" => [],
                     "zip_code" => "810-ZZZZ",
                     "address1_p" => "address1_p",
                     "address2_p" => "address2_p",
                     "address3" => "address3",
                     "address3_p" => "address3_p",
                     "notation_name" => "notation_name",
                     "notation_org_name" => "notation_org_name",
                     "notation_org_name_p" => "notation_org_name_p",
                     "notation_name_p" => "notation_name_p",
                     "phone_number" => "phone_number",
                     "fax_number" => "fax_number",
                   }
                 ],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "lock_version" => 2,
                 "organization" => %{
                   "addresses" => [],
                   "back_ground_img_url" => "https://hogehoge.com/ib_img.jpg",
                   "hp_url" => "https://hogehoge.inc",
                   "id" => 1,
                   "lock_version" => 1,
                   "name" => "hogehoge.inc",
                   "one_line_message" => "let's do this.",
                   "phone_number" => nil,
                   "fax_number" => "fax_number",
                   "profile_img_url" => "https://hogehoge.com/prof_img.jpg",
                   "status" => 1,
                   "users" => [],
                   "ext_organization_branch_id" => "ext_organization_branch_id",
                   "ext_organization_id" => "ext_organization_id",
                   "name_p" => "name_p"
                 },
                 "phone_number" => nil,
                 "fax_number" => "fax_number",
                 "status" => 1,
                 "name_p" => "name_p"
               }
             ]

      # show other user info (allow anybody)
      user_conn = get conn, user_path(conn, :show, 2)
      assert json_response(user_conn, 200) == %{
               "email" => "fugafuga@example.com",
               "id" => 2,
               "name" => "fugafuga",
               "role" => "operator",
               "addresses" => [],
               "back_ground_img_url" => nil,
               "descriptions" => nil,
               "external_user_id" => nil,
               "icon_img_url" => nil,
               "lock_version" => 1,
               "organization" => nil,
               "phone_number" => nil,
               "fax_number" => "fax_number",
               "status" => 1,
               "name_p" => "name_p"
             }

     # show role grant list (allow anybody)
     role_grant_conn = post conn, grant_path(conn, :get_by_role), %{"role" => "admin"}
     assert json_response(role_grant_conn, 200) |> Enum.chunk_every(2) |> List.first() == [
      %{
        "id" => 1,
        "method" => "ANY",
        "request_path" => "/api/ops/users",
        "role" => "anybody"
      },
      %{
        "id" => 2,
        "method" => "ANY",
        "request_path" => "/api/ops/grants",
        "role" => "admin"
      }
    ]

     # show all grant list (allow only administrator)
     role_all_conn = get conn, grant_path(conn, :index)
     assert json_response(role_all_conn, 200) |> Enum.chunk_every(2) |> List.first() == [%{"id" => 1, "method" => "ANY", "request_path" => "/api/ops/users", "role" => "anybody"}, %{"id" => 2, "request_path" => "/api/ops/grants", "role" => "admin", "method" => "ANY"}]

    # show grant info (allow only administrator)
    grant_conn = get conn, grant_path(conn, :show, 2)
    assert json_response(grant_conn, 200) == %{
      "id" => 2,
      "method" => "ANY",
      "request_path" => "/api/ops/grants",
      "role" => "admin"
    }

    # logout
    sign_out_conn = post conn, authenticator_path(conn, :sign_out), @admin_user_attrs
    assert json_response(sign_out_conn, 200) == %{"ok" => true}

    # show self info (only login user)
    unauth_conn = get conn, user_path(conn, :show_me)
    assert response(unauth_conn, 401) == "{\"message\":\"invalid_token\"}"
      #IO.inspect(response(unauth_conn, 401))
    end
  end

  @operator_user_attrs %{
    "name": "fugafuga",
    "email": "fugafuga@example.com",
    "password": "fugafuga",
    "role": "operator"
  }

  describe "operator_user" do
    test "operator user ligin cycle", %{conn: conn} do
      token_conn = post conn, authenticator_path(conn, :sign_in), @operator_user_attrs
      %{"access_token" => token } = json_response(token_conn, 201)
      #IO.puts(token)
      conn = put_req_header(conn, "authorization", "Bearer " <> token)

      # show self info
      show_me_conn = get conn, user_path(conn, :show_me)
      assert json_response(show_me_conn, 200) == %{
               "email" => "fugafuga@example.com",
               "id" => 2,
               "name" => "fugafuga",
               "role" => "operator",
               "addresses" => [],
               "back_ground_img_url" => nil,
               "descriptions" => nil,
               "external_user_id" => nil,
               "icon_img_url" => nil,
               "lock_version" => 1,
               "organization" => nil,
               "phone_number" => nil,
               "fax_number" => "fax_number",
               "status" => 1,
               "name_p" => "name_p"
             }

      # show user list (allow only administrator)
      users_conn = get conn, user_path(conn, :index)
      #assert response(users_conn, 401) == "{\"message\":\"invalid_token\"}"
      assert json_response(users_conn, 200) == [
               %{
                 "email" => "fugafuga@example.com",
                 "id" => 2,
                 "name" => "fugafuga",
                 "role" => "operator",
                 "addresses" => [],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "lock_version" => 1,
                 "organization" => nil,
                 "phone_number" => nil,
                 "fax_number" => "fax_number",
                 "status" => 1,
                 "name_p" => "name_p"
               },
               %{
                 "email" => "hogehoge@example.com",
                 "id" => 1,
                 "name" => "hogehoge",
                 "role" => "admin",
                 "addresses" => [
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "港 x-x-xx",
                     "id" => 1,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "living",
                     "user" => [],
                     "zip_code" => "810-ZZZZ",
                     "address1_p" => "address1_p",
                     "address2_p" => "address2_p",
                     "address3" => "address3",
                     "address3_p" => "address3_p",
                     "notation_name" => "notation_name",
                     "notation_org_name" => "notation_org_name",
                     "notation_org_name_p" => "notation_org_name_p",
                     "notation_name_p" => "notation_name_p",
                     "phone_number" => "phone_number",
                     "fax_number" => "fax_number",
                   },
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "大名 x-x-xx",
                     "id" => 2,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "billing",
                     "user" => [],
                     "zip_code" => "810-ZZZZ",
                     "address1_p" => "address1_p",
                     "address2_p" => "address2_p",
                     "address3" => "address3",
                     "address3_p" => "address3_p",
                     "notation_name" => "notation_name",
                     "notation_org_name" => "notation_org_name",
                     "notation_org_name_p" => "notation_org_name_p",
                     "notation_name_p" => "notation_name_p",
                     "phone_number" => "phone_number",
                     "fax_number" => "fax_number",
                   }
                 ],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "lock_version" => 2,
                 "organization" => %{
                   "addresses" => [],
                   "back_ground_img_url" => "https://hogehoge.com/ib_img.jpg",
                   "hp_url" => "https://hogehoge.inc",
                   "id" => 1,
                   "lock_version" => 1,
                   "name" => "hogehoge.inc",
                   "one_line_message" => "let's do this.",
                   "phone_number" => nil,
                   "fax_number" => "fax_number",
                   "profile_img_url" => "https://hogehoge.com/prof_img.jpg",
                   "status" => 1,
                   "users" => [],
                   "ext_organization_branch_id" => "ext_organization_branch_id",
                   "ext_organization_id" => "ext_organization_id",
                   "name_p" => "name_p"
                 },
                 "phone_number" => nil,
                 "fax_number" => "fax_number",
                 "status" => 1,
                 "name_p" => "name_p"
               }
             ]

      # show other user info (allow anybody)
      user_conn = get conn, user_path(conn, :show, 1)
      #assert response(user_conn, 401) == "{\"message\":\"invalid_token\"}"
      assert json_response(user_conn, 200) == %{
               "email" => "hogehoge@example.com",
               "id" => 1,
               "name" => "hogehoge",
               "role" => "admin",
               "addresses" => [
                 %{
                   "address1" => "福岡市中央区",
                   "address2" => "大名 x-x-xx",
                   "id" => 2,
                   "latitude" => nil,
                   "location" => "福岡県",
                   "lock_version" => 0,
                   "longitude" => nil,
                   "organization" => nil,
                   "subject" => "billing",
                   "user" => [],
                   "zip_code" => "810-ZZZZ",
                   "address1_p" => "address1_p",
                   "address2_p" => "address2_p",
                   "address3" => "address3",
                   "address3_p" => "address3_p",
                   "notation_name" => "notation_name",
                   "notation_org_name" => "notation_org_name",
                   "notation_org_name_p" => "notation_org_name_p",
                   "notation_name_p" => "notation_name_p",
                   "phone_number" => "phone_number",
                   "fax_number" => "fax_number",
                 },
                 %{
                   "address1" => "福岡市中央区",
                   "address2" => "港 x-x-xx",
                   "id" => 1,
                   "latitude" => nil,
                   "location" => "福岡県",
                   "lock_version" => 0,
                   "longitude" => nil,
                   "organization" => nil,
                   "subject" => "living",
                   "user" => [],
                   "zip_code" => "810-ZZZZ",
                   "address1_p" => "address1_p",
                   "address2_p" => "address2_p",
                   "address3" => "address3",
                   "address3_p" => "address3_p",
                   "notation_name" => "notation_name",
                   "notation_org_name" => "notation_org_name",
                   "notation_org_name_p" => "notation_org_name_p",
                   "notation_name_p" => "notation_name_p",
                   "phone_number" => "phone_number",
                   "fax_number" => "fax_number",
                 }
               ],
               "back_ground_img_url" => nil,
               "descriptions" => nil,
               "external_user_id" => nil,
               "icon_img_url" => nil,
               "lock_version" => 2,
               "organization" => %{
                 "addresses" => [],
                 "back_ground_img_url" => "https://hogehoge.com/ib_img.jpg",
                 "hp_url" => "https://hogehoge.inc",
                 "id" => 1,
                 "lock_version" => 1,
                 "name" => "hogehoge.inc",
                 "one_line_message" => "let's do this.",
                 "phone_number" => nil,
                 "fax_number" => "fax_number",
                 "profile_img_url" => "https://hogehoge.com/prof_img.jpg",
                 "status" => 1,
                 "users" => [],
                 "ext_organization_branch_id" => "ext_organization_branch_id",
                 "ext_organization_id" => "ext_organization_id",
                 "name_p" => "name_p"
               },
               "phone_number" => nil,
               "fax_number" => "fax_number",
               "status" => 1,
               "name_p" => "name_p"
             }

     # show role grant list (allow anybody)
     role_grant_conn = post conn, grant_path(conn, :get_by_role), %{"role" => "admin"}
     assert json_response(role_grant_conn, 200) |> Enum.chunk_every(2) |> List.first() == [
      %{
        "id" => 1,
        "method" => "ANY",
        "request_path" => "/api/ops/users",
        "role" => "anybody"
      },
      %{
        "id" => 2,
        "method" => "ANY",
        "request_path" => "/api/ops/grants",
        "role" => "admin"
      }
    ]

     # show all grant list (allow anyboby)
     role_all_conn = get conn, grant_path(conn, :index)
     assert json_response(role_all_conn, 200) |> Enum.chunk_every(2) |> List.first() == [%{"id" => 1, "method" => "ANY", "request_path" => "/api/ops/users", "role" => "anybody"}, %{"id" => 2, "request_path" => "/api/ops/grants", "role" => "admin", "method" => "ANY"}]

    # show grant info (allow anybody)
    grant_conn = get conn, grant_path(conn, :show, 2)
    assert json_response(grant_conn, 200) == %{
      "id" => 2,
      "method" => "ANY",
      "request_path" => "/api/ops/grants",
      "role" => "admin"
    }


    # logout
    sign_out_conn = post conn, authenticator_path(conn, :sign_out), @operator_user_attrs
    assert json_response(sign_out_conn, 200) == %{"ok" => true}

    # show self info (only login user)
    unauth_conn = get conn, user_path(conn, :show_me)
    assert response(unauth_conn, 401) == "{\"message\":\"invalid_token\"}"
    # IO.inspect(response(unauth_conn, 401))
    end
  end

  @other_user_attrs %{
    "name": "ugauga",
    "email": "ugauga@example.com",
    "password": "ugauga",
    "role": "operator"
  }

  @update_user_attrs %{
    "name": "ageage",
    "email": "ageage@example.com",
    "password": "ageage",
    "role": "admin"
  }

  describe "user CRUD" do
    test "usr life cycle", %{conn: conn} do
      token_conn = post conn, authenticator_path(conn, :sign_in), @operator_user_attrs
      %{"access_token" => token } = json_response(token_conn, 201)
      conn = put_req_header(conn, "authorization", "Bearer " <> token)

    # create user
    create_conn = post conn, user_path(conn, :create), @other_user_attrs
    create_resp = json_response(create_conn, 201)
    assert create_resp |> Map.delete("id") == %{
             "email" => "ugauga@example.com",
             "name" => "ugauga",
             "role" => "operator",
             "addresses" => [],
             "back_ground_img_url" => nil,
             "descriptions" => nil,
             "external_user_id" => nil,
             "icon_img_url" => nil,
             "lock_version" => 1,
             "organization" => nil,
             "phone_number" => nil,
             "status" => 1,
             "name_p" => nil,
             "fax_number" => nil,
           }

    # update user
    update_conn = put conn, user_path(conn, :update, create_resp["id"]), @update_user_attrs
    assert json_response(update_conn, 200) |> Map.delete("id") == %{
             "email" => "ageage@example.com",
             "name" => "ageage",
             "role" => "admin",
             "addresses" => [],
             "back_ground_img_url" => nil,
             "descriptions" => nil,
             "external_user_id" => nil,
             "icon_img_url" => nil,
             "lock_version" => 2,
             "organization" => nil,
             "phone_number" => nil,
             "status" => 1,
             "name_p" => nil,
             "fax_number" => nil,
           }

    # delete user
    delete_conn = delete conn, user_path(conn, :delete, create_resp["id"])
    assert response(delete_conn, 204) == ""

    end
  end


  describe "tmp_user life cycle" do

    test "tmp_user registration flow", %{conn: conn} do

      # 仮登録する
      tmp_conn1 = post conn, user_path(conn, :registration_tmp_user), %{"email" => "tmp_user_test001@example.com", "role" => "customer"}
      resp1 = json_response(tmp_conn1, 201)

      # 同じユーザーで２度登録しても上書きされてエラーにならない
      tmp_conn2 = post conn, user_path(conn, :registration_tmp_user), %{"email" => "tmp_user_test001@example.com", "role" => "customer"}
      resp2 = json_response(tmp_conn2, 201)
      assert resp1["user"]["id"] == resp2["user"]["id"]
      assert resp2["user"]["lock_version"] == resp1["user"]["lock_version"] + 1

      # この時点ではtokenはどちらもvalid
      conn1 = put_req_header(conn, "authorization", "Bearer " <> resp1["user_registration_token"])
      conn_valid1 = get conn1, authenticator_path(conn, :is_varid_token)
      resp_valid1 = response(conn_valid1, 200)
      assert resp_valid1 == "{\"message\":\"authenticated\"}"

      conn2 = put_req_header(conn, "authorization", "Bearer " <> resp2["user_registration_token"])
      conn_valid2 = get conn2, authenticator_path(conn, :is_varid_token)
      resp_valid2 = response(conn_valid1, 200)
      assert resp_valid2 == "{\"message\":\"authenticated\"}"

      #本登録する(tokenがなければエラー)
      reg_conn1 = post conn, user_path(conn, :registration_user), %{"name" => "tmp_user_test001@example.com", "password" => "password"}
      resp_error = response(reg_conn1, 401)
      assert resp_error == "{\"message\":\"unauthenticated\"}"

      #本登録する(不正なtokenならばエラー)
      conn = put_req_header(conn, "authorization", "Bearer " <> "hogehoge")
      reg_conn1 = post conn, user_path(conn, :registration_user), %{"name" => "tmp_user_test001@example.com", "password" => "password"}
      resp_error = response(reg_conn1, 401)
      assert resp_error == "{\"message\":\"invalid_token\"}"

      #本登録する(名前なしはエラー)
      conn = put_req_header(conn, "authorization", "Bearer " <> resp2["user_registration_token"])
      reg_conn1 = post conn, user_path(conn, :registration_user), %{"name" => "", "password" => "password"}
      resp_error = json_response(reg_conn1, 422)
      assert resp_error == %{"errors" => %{"name" => ["can't be blank"]}}

      #本登録する(パスワードなしはエラー)
      conn = put_req_header(conn, "authorization", "Bearer " <> resp2["user_registration_token"])
      reg_conn1 = post conn, user_path(conn, :registration_user), %{"name" => "tmp_user_test001 username", "password" => ""}
      resp_error = json_response(reg_conn1, 422)
      assert resp_error == %{"errors" => %{"password" => ["can't be blank"]}}

      #本登録する
      conn = put_req_header(conn, "authorization", "Bearer " <> resp2["user_registration_token"])
      reg_conn1 = post conn, user_path(conn, :registration_user), %{"name" => "tmp_user_test001 username", "password" => "password"}
      assert resp_reg_user = json_response(reg_conn1, 201)

      #同じtokenは使えない
      conn = put_req_header(conn, "authorization", "Bearer " <> resp2["user_registration_token"])
      reg_conn3 = post conn, user_path(conn, :registration_user), %{"name" => "tmp_user_test001 username", "password" => "password"}
      resp_error = response(reg_conn3, 401)
      assert resp_error == "{\"message\":\"invalid_token\"}"

      conn = put_req_header(conn, "authorization", "Bearer " <> resp1["user_registration_token"])
      reg_conn3 = post conn, user_path(conn, :registration_user), %{"name" => "tmp_user_test001 username", "password" => "password"}
      resp_error = response(reg_conn3, 401)
      assert resp_error == "{\"message\":\"invalid_token\"}"

      # 本登録後に同じメールアドレスで登録した場合エラー
      tmp_conn3 = post conn, user_path(conn, :registration_tmp_user), %{"email" => "tmp_user_test001@example.com", "role" => "customer"}
      resp_error = response(tmp_conn3, 400)
      assert resp_error = "this email address was already registered."


    end

    test "tmp user registration invalid status", %{conn: conn} do

      # 仮登録する
      tmp_conn1 = post conn, user_path(conn, :registration_tmp_user), %{"email" => "tmp_user_test002@example.com", "role" => "customer"}
      resp1 = json_response(tmp_conn1, 201)


      # オペレーターログイン
      token_conn = post conn, authenticator_path(conn, :sign_in), @operator_user_attrs
      %{"access_token" => token } = json_response(token_conn, 201)
      conn_auth = put_req_header(conn, "authorization", "Bearer " <> token)

      # ユーザーを凍結
      conn_update1 = put conn_auth, user_path(conn_auth, :update, resp1["user"]["id"]), %{"status" => User.status.frozen}
      resp_update1 = json_response(conn_update1, 200)

      #凍結済みのユーザーでは本登録できない
      conn = put_req_header(conn, "authorization", "Bearer " <> resp1["user_registration_token"])
      reg_conn1 = post conn, user_path(conn, :registration_user), %{"name" => "tmp_user_test001 username", "password" => "password"}
      resp_error = response(reg_conn1, 401)
      assert resp_error == "{\"message\":\"invalid_token\"}"

      # ユーザーを失効
      conn_update2 = put conn_auth, user_path(conn_auth, :update, resp1["user"]["id"]), %{"status" => User.status.expired}
      resp_update2 = json_response(conn_update2, 200)

      #失効済みのユーザーでは本登録できない
      conn = put_req_header(conn, "authorization", "Bearer " <> resp1["user_registration_token"])
      reg_conn2 = post conn, user_path(conn, :registration_user), %{"name" => "tmp_user_test001 username", "password" => "password"}
      resp_error = response(reg_conn2, 401)
      assert resp_error == "{\"message\":\"invalid_token\"}"


    end
  end

  describe "password reset flow" do

    test "password reset cycle" , %{conn: conn} do
      # オペレーターログイン
      token_conn = post conn, authenticator_path(conn, :sign_in), @operator_user_attrs
      %{"access_token" => token } = json_response(token_conn, 201)
      conn_auth = put_req_header(conn, "authorization", "Bearer " <> token)

      # ユーザー登録 :create
      conn_create1 = post conn_auth, user_path(conn_auth, :create), %{"name" => "pw_reset0001 user", "email" => "pw_reset0001@example.com", "role" => "customer", "password" => "password"}
      resp_create1 = json_response(conn_create1, 201)

      # ログインできる
      token_conn = post conn, authenticator_path(conn, :sign_in), %{"email" => "pw_reset0001@example.com", "password" => "password"}
      %{"access_token" => token } = json_response(token_conn, 201)

      # パスワードリセット要求
      conn_reset1 = post conn, user_path(conn, :request_password_reset), %{"email" => "pw_reset0001@example.com"}
      resp_reset1 = json_response(conn_reset1, 201)

      # パスワードリセット要求　同じメールアドレスで申請しても問題ない
      conn_reset2 = post conn, user_path(conn, :request_password_reset), %{"email" => "pw_reset0001@example.com"}
      resp_reset2 = json_response(conn_reset2, 201)

      # パスワードリセット要求(存在しないユーザーの場合表面上正常終了させる)
      conn_err = post conn, user_path(conn, :request_password_reset), %{"email" => "not_exist@example.com"}
      resp_error = response(conn_err, 201)
      assert resp_error == "{\"password_reset_token\":\"\"}"

      # パスワードリセット要求(メールアドレス指定なし)
      conn_err = post conn, user_path(conn, :request_password_reset), %{"email" => ""}
      resp_error = response(conn_err, 201)
      assert resp_error == "{\"password_reset_token\":\"\"}"

      # token検証
      #conn1 = put_req_header(conn, "authorization", "Bearer " <> resp_reset1["password_reset_token"])
      #conn_valid1 = get conn1, authenticator_path(conn1, :is_varid_token)
      #resp_valid1 = response(conn_valid1, 200)
      #assert resp_valid1 == "{\"message\":\"authenticated\"}"
#
      #conn2 = put_req_header(conn, "authorization", "Bearer " <> resp_reset2["password_reset_token"])
      #conn_valid2 = get conn2, authenticator_path(conn2, :is_varid_token)
      #resp_valid2 = response(conn_valid1, 200)
      #assert resp_valid2 == "{\"message\":\"authenticated\"}"

      # パスワードリセット
      conn_auth2 = put_req_header(conn, "authorization", "Bearer " <> resp_reset1["password_reset_token"])
      conn_reset4 = post conn_auth2, user_path(conn, :reset_my_password), %{"password" => "resetedpassword"}
      resp_reset4 = json_response(conn_reset4, 201)

      # 旧パスワードでログインできない
      token_conn = post conn, authenticator_path(conn, :sign_in), %{"email" => "pw_reset0001@example.com", "password" => "password"}
      resp_err = response(token_conn, 401)
      assert resp_err == "[{\"title\":\"401 Unauthorized\",\"status\":401,\"id\":\"UNAUTHORIZED\",\"detail\":\"email or password is invalid\"}]"

      # 新パスワードでログインできる
      token_conn = post conn, authenticator_path(conn, :sign_in), %{"email" => "pw_reset0001@example.com", "password" => "resetedpassword"}
      %{"access_token" => token } = json_response(token_conn, 201)

      # 発行済みの２つ目のtokenでもう一度リセットしても問題ない
      conn_auth3 = put_req_header(conn, "authorization", "Bearer " <> resp_reset2["password_reset_token"])
      conn_reset4 = post conn_auth3, user_path(conn, :reset_my_password), %{"password" => "resetedpassword2"}

      # 旧パスワードでログインできない
      token_conn = post conn, authenticator_path(conn, :sign_in), %{"email" => "pw_reset0001@example.com", "password" => "resetedpassword"}
      resp_err = response(token_conn, 401)
      assert resp_err == "[{\"title\":\"401 Unauthorized\",\"status\":401,\"id\":\"UNAUTHORIZED\",\"detail\":\"email or password is invalid\"}]"

      # 新パスワードでログインできる
      token_conn = post conn, authenticator_path(conn, :sign_in), %{"email" => "pw_reset0001@example.com", "password" => "resetedpassword2"}
      %{"access_token" => token } = json_response(token_conn, 201)

      # パスワードリセット要求
      conn_reset3 = post conn, user_path(conn, :request_password_reset), %{"email" => "pw_reset0001@example.com"}
      resp_reset3 = json_response(conn_reset3, 201)

      # ユーザーを凍結
      conn_update1 = put conn_auth, user_path(conn_auth, :update, resp_create1["id"]), %{"status" => User.status.frozen}
      resp_update1 = json_response(conn_update1, 200)

      # 凍結済みのユーザーではパスワードリセットできない
      conn_auth3 = put_req_header(conn, "authorization", "Bearer " <> resp_reset3["password_reset_token"])
      conn_reset5 = post conn_auth3, user_path(conn, :reset_my_password), %{"password" => "resetedpassword"}
      resp_reset5 = response(conn_reset5, 401)
      assert resp_reset5 == "{\"message\":\"invalid_token\"}"

      # ユーザーを失効
      conn_update2 = put conn_auth, user_path(conn_auth, :update, resp_create1["id"]), %{"status" => User.status.expired}
      resp_update2 = json_response(conn_update2, 200)

      # 失効済みのユーザーではパスワードリセットできない
      conn_auth4 = put_req_header(conn, "authorization", "Bearer " <> resp_reset3["password_reset_token"])
      conn_reset6 = post conn_auth4, user_path(conn, :reset_my_password), %{"password" => "resetedpassword"}
      resp_reset6 = response(conn_reset6, 401)
      assert resp_reset6 == "{\"message\":\"invalid_token\"}"

    end

  end



#
  #def fixture(:user) do
  #  {:ok, user} = Accounts.create_user(@create_attrs)
  #  user
  #end
#

  #describe "index" do
  #  test "admin user ligin cycle", %{conn: conn} do
  #    conn = get conn, user_path(conn, :index)
  #    assert json_response(conn, 200)["data"] == []
  #  end
  #end
#
  #describe "create user" do
  #  test "renders user when data is valid", %{conn: conn} do
  #    conn = post conn, user_path(conn, :create), user: @create_attrs
  #    assert %{"id" => id} = json_response(conn, 201)["data"]
#
  #    conn = get conn, user_path(conn, :show, id)
  #    assert json_response(conn, 200)["data"] == %{
  #      "id" => id,
  #      "email" => "some email",
  #      "hashed_password" => "some hashed_password",
  #      "name" => "some name",
  #      "role" => "some role"}
  #  end
#
  #  test "renders errors when data is invalid", %{conn: conn} do
  #    conn = post conn, user_path(conn, :create), user: @invalid_attrs
  #    assert json_response(conn, 422)["errors"] != %{}
  #  end
  #end
#
  #describe "update user" do
  #  setup [:create_user]
#
  #  test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
  #    conn = put conn, user_path(conn, :update, user), user: @update_attrs
  #    assert %{"id" => ^id} = json_response(conn, 200)["data"]
#
  #    conn = get conn, user_path(conn, :show, id)
  #    assert json_response(conn, 200)["data"] == %{
  #      "id" => id,
  #      "email" => "some updated email",
  #      "hashed_password" => "some updated hashed_password",
  #      "name" => "some updated name",
  #      "role" => "some updated role"}
  #  end
#
  #  test "renders errors when data is invalid", %{conn: conn, user: user} do
  #    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
  #    assert json_response(conn, 422)["errors"] != %{}
  #  end
  #end
#
  #describe "delete user" do
  #  setup [:create_user]
#
  #  test "deletes chosen user", %{conn: conn, user: user} do
  #    conn = delete conn, user_path(conn, :delete, user)
  #    assert response(conn, 204)
  #    assert_error_sent 404, fn ->
  #      get conn, user_path(conn, :show, user)
  #    end
  #  end
  #end

#  defp create_user(_) do
#    user = fixture(:user)
#    {:ok, user: user}
#  end
end
