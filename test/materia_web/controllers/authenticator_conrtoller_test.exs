defmodule MateriaWeb.AuthenticatorControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Accounts

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign-in by user " do
    test "sign-in life cycle by user", %{conn: conn} do

    attr = %{
      "email" => "fugafuga@example.com",
      "password" => "fugafuga",
    }
    token_conn = post(conn, authenticator_path(conn, :sign_in), attr)
    resp_token = json_response(token_conn, 201)
    access_token = resp_token["access_token"]
    conn_auth = put_req_header(conn, "authorization", "Bearer " <> access_token)

    conn_show_me = get(conn_auth, user_path(conn, :show_me))
    resp_show_me = json_response(conn_show_me, 200)
    assert resp_show_me == %{
      "addresses" => [],
      "back_ground_img_url" => nil,
      "descriptions" => nil,
      "email" => "fugafuga@example.com",
      "external_user_id" => nil,
      "icon_img_url" => nil,
      "id" => 2,
      "lock_version" => 1,
      "name" => "fugafuga",
      "organization" => nil,
      "phone_number" => nil,
      "role" => "operator",
      "status" => 1
    }

    conn_valid = get(conn_auth, authenticator_path(conn, :is_authenticated))
    resp_valid = response(conn_valid, 200)
    assert resp_valid == "{\"message\":\"authenticated\"}"

    # refresh token
    refresh_token = resp_token["refresh_token"]
    conn_refresh = post(conn, authenticator_path(conn, :refresh), %{"refresh_token" => refresh_token})
    resp_refresh = json_response(conn_refresh, 201)
    assert resp_refresh["access_token"] != access_token

    conn_auth2 = put_req_header(conn, "authorization", "Bearer " <> access_token)

    conn_show_me2 = get(conn_auth2, user_path(conn, :show_me))
    resp_show_me2 = json_response(conn_show_me2, 200)
    assert resp_show_me2 == %{
      "addresses" => [],
      "back_ground_img_url" => nil,
      "descriptions" => nil,
      "email" => "fugafuga@example.com",
      "external_user_id" => nil,
      "icon_img_url" => nil,
      "id" => 2,
      "lock_version" => 1,
      "name" => "fugafuga",
      "organization" => nil,
      "phone_number" => nil,
      "role" => "operator",
      "status" => 1
    }

    # sign-out
    conn_sign_out = post(conn_auth2, authenticator_path(conn, :sign_out))
    resp_sing_out = response(conn_sign_out, 200)
    assert resp_sing_out == "{\"ok\":true}"

    conn_valid3 = get(conn_auth2, authenticator_path(conn, :is_authenticated))
    resp_valid3 = response(conn_valid3, 401)
    assert resp_valid3 == "{\"message\":\"invalid_token\"}"


    end
  end

  describe "sign-in by account and user" do
    test "sign-in life cycle by account and user", %{conn: conn} do

      attr = %{
        "account" => "hogehoge_code",
        "email" => "hogehoge@example.com",
        "password" => "hogehoge",
      }
    token_conn = post(conn, authenticator_path(conn, :sign_in), attr)
    resp_token = json_response(token_conn, 201)
    access_token = resp_token["access_token"]
    conn_auth = put_req_header(conn, "authorization", "Bearer " <> access_token)

    conn_show_me = get(conn_auth, user_path(conn, :show_me))
    resp_show_me = json_response(conn_show_me, 200)
    assert resp_show_me == %{
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
          "zip_code" => "810-ZZZZ"
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
          "zip_code" => "810-ZZZZ"
        }
      ],
      "back_ground_img_url" => nil,
      "descriptions" => nil,
      "email" => "hogehoge@example.com",
      "external_user_id" => nil,
      "icon_img_url" => nil,
      "id" => 1,
      "lock_version" => 2,
      "name" => "hogehoge",
      "organization" => %{
        "addresses" => [],
        "back_ground_img_url" => "https://hogehoge.com/ib_img.jpg",
        "hp_url" => "https://hogehoge.inc",
        "id" => 1,
        "lock_version" => 1,
        "name" => "hogehoge.inc",
        "one_line_message" => "let's do this.",
        "phone_number" => nil,
        "profile_img_url" => "https://hogehoge.com/prof_img.jpg",
        "status" => 1,
        "users" => []
      },
      "phone_number" => nil,
      "role" => "admin",
      "status" => 1
    }

    conn_show_my_account = get(conn_auth, account_path(conn, :show_my_account))
    resp_show_my_account = json_response(conn_show_my_account, 200)
    assert resp_show_my_account == %{
      "descriptions" => nil,
      "expired_datetime" => nil,
      "external_code" => "hogehoge_code",
      "frozen_datetime" => nil,
      "id" => 1,
      "lock_version" => 0,
      "main_user" => nil,
      "name" => "hogehoge account",
      "organization" => nil,
      "start_datetime" => "2019-01-10T10:03:50.293740Z",
      "status" => 1
    }

    conn_valid = get(conn_auth, authenticator_path(conn, :is_authenticated))
    resp_valid = response(conn_valid, 200)
    assert resp_valid == "{\"message\":\"authenticated\"}"

    # refresh token
    refresh_token = resp_token["refresh_token"]
    conn_refresh = post(conn, authenticator_path(conn, :refresh), %{"refresh_token" => refresh_token})
    resp_refresh = json_response(conn_refresh, 201)
    assert resp_refresh["access_token"] != access_token

    conn_auth2 = put_req_header(conn, "authorization", "Bearer " <> access_token)

    conn_show_my_account2 = get(conn_auth2, account_path(conn, :show_my_account))
    resp_show_my_account2 = json_response(conn_show_my_account2, 200)
    assert resp_show_my_account2 == %{
      "descriptions" => nil,
      "expired_datetime" => nil,
      "external_code" => "hogehoge_code",
      "frozen_datetime" => nil,
      "id" => 1,
      "lock_version" => 0,
      "main_user" => nil,
      "name" => "hogehoge account",
      "organization" => nil,
      "start_datetime" => "2019-01-10T10:03:50.293740Z",
      "status" => 1
    }

     # sign-out
     conn_sign_out = post(conn_auth2, authenticator_path(conn, :sign_out))
     resp_sing_out = response(conn_sign_out, 200)
     assert resp_sing_out == "{\"ok\":true}"

     conn_valid3 = get(conn_auth2, authenticator_path(conn, :is_authenticated))
     resp_valid3 = response(conn_valid3, 401)
     assert resp_valid3 == "{\"message\":\"invalid_token\"}"

    end
  end

end
