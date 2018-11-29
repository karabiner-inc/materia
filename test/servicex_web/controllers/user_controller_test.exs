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
      %{"token" => token } = json_response(token_conn, 201)
      #IO.puts(token)
      conn = put_req_header(conn, "authorization", "Bearer " <> token)

      # show self info
      show_me_conn = get conn, user_path(conn, :show_me)
      assert json_response(show_me_conn, 200) == %{
        "email" => "hogehoge@example.com",
        "id" => 1,
        "name" => "hogehoge",
        "role" => "admin"
      }

      # show user list (allow anybody)
      users_conn = get conn, user_path(conn, :index)
      assert json_response(users_conn, 200) == [
        %{
          "email" => "hogehoge@example.com",
          "id" => 1,
          "name" => "hogehoge",
          "role" => "admin"
        },
        %{
          "email" => "fugafuga@example.com",
          "id" => 2,
          "name" => "fugafuga",
          "role" => "operator"
        }
      ]

      # show other user info (allow anybody)
      user_conn = get conn, user_path(conn, :show, 2)
      assert json_response(user_conn, 200) == %{
        "email" => "fugafuga@example.com",
        "id" => 2,
        "name" => "fugafuga",
        "role" => "operator"
      }

     # show role grant list (allow anybody)
     role_grant_conn = post conn, grant_path(conn, :get_by_role), %{"role" => "admin"}
     assert json_response(role_grant_conn, 200) == [
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
     assert json_response(role_all_conn, 200) == [%{"id" => 1, "method" => "ANY", "request_path" => "/api/ops/users", "role" => "anybody"}, %{"id" => 2, "request_path" => "/api/ops/grants", "role" => "admin", "method" => "ANY"}, %{"id" => 3, "method" => "GET", "request_path" => "/api/ops/grants", "role" => "operator"}]

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
      %{"token" => token } = json_response(token_conn, 201)
      #IO.puts(token)
      conn = put_req_header(conn, "authorization", "Bearer " <> token)

      # show self info
      show_me_conn = get conn, user_path(conn, :show_me)
      assert json_response(show_me_conn, 200) == %{
        "email" => "fugafuga@example.com",
        "id" => 2,
        "name" => "fugafuga",
        "role" => "operator"
      }

      # show user list (allow only administrator)
      users_conn = get conn, user_path(conn, :index)
      #assert response(users_conn, 401) == "{\"message\":\"invalid_token\"}"
      assert json_response(users_conn, 200) == [
        %{
          "email" => "hogehoge@example.com",
          "id" => 1,
          "name" => "hogehoge",
          "role" => "admin"
        },
        %{
          "email" => "fugafuga@example.com",
          "id" => 2,
          "name" => "fugafuga",
          "role" => "operator"
        }
      ]

      # show other user info (allow anybody)
      user_conn = get conn, user_path(conn, :show, 1)
      #assert response(user_conn, 401) == "{\"message\":\"invalid_token\"}"
      assert json_response(user_conn, 200) == %{
        "email" => "hogehoge@example.com",
        "id" => 1,
        "name" => "hogehoge",
        "role" => "admin"
      }

     # show role grant list (allow anybody)
     role_grant_conn = post conn, grant_path(conn, :get_by_role), %{"role" => "admin"}
     assert json_response(role_grant_conn, 200) == [
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
     assert json_response(role_all_conn, 200) == [%{"id" => 1, "method" => "ANY", "request_path" => "/api/ops/users", "role" => "anybody"}, %{"id" => 2, "request_path" => "/api/ops/grants", "role" => "admin", "method" => "ANY"}, %{"id" => 3, "method" => "GET", "request_path" => "/api/ops/grants", "role" => "operator"}]

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
      %{"token" => token } = json_response(token_conn, 201)
      conn = put_req_header(conn, "authorization", "Bearer " <> token)

    # create user
    create_conn = post conn, user_path(conn, :create), @other_user_attrs
    assert json_response(create_conn, 201) == %{
      "email" => "ugauga@example.com",
      "id" => 3,
      "name" => "ugauga",
      "role" => "operator"
    }

    # update user
    update_conn = put conn, user_path(conn, :update, 3), @update_user_attrs
    assert json_response(update_conn, 200) == %{
      "email" => "ageage@example.com",
      "id" => 3,
      "name" => "ageage",
      "role" => "admin"
    }

    # delete user
    delete_conn = delete conn, user_path(conn, :delete, 3)
    assert response(delete_conn, 204) == ""

    # IO.inspect(response(unauth_conn, 401))
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

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
