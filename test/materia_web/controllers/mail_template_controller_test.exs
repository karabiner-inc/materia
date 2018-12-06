defmodule MateriaWeb.TemplateControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Mails
  alias Materia.Mails.MailTemplate

  @operator_user_attrs %{
    name: "fugafuga",
    email: "fugafuga@example.com",
    password: "fugafuga",
    role: "operator"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all mail_templates", %{conn: conn} do
      # オペレーターログイン
      token_conn = post(conn, authenticator_path(conn, :sign_in), @operator_user_attrs)
      %{"access_token" => token} = json_response(token_conn, 201)
      conn_auth = put_req_header(conn, "authorization", "Bearer " <> token)

      # 一覧紹介
      conn_index0 = get(conn_auth, mail_template_path(conn, :index))
      resp_index0 = json_response(conn_index0, 200)
      assert length(resp_index0) == 4

      # 登録
      conn =
        post(conn_auth, mail_template_path(conn, :create), %{
          body: "some body",
          mail_template_type: "some type",
          status: 42,
          string: "some string",
          subject: "some subject"
        })

      assert %{"id" => id} = json_response(conn, 201)
      IO.puts(id)

      # 一覧紹介
      conn_index1 = get(conn_auth, mail_template_path(conn, :index))
      resp_index1 = json_response(conn_index1, 200)
      assert length(resp_index1) == 5

      # 更新
      conn_update =
        put(conn_auth, mail_template_path(conn, :update, id), %{
          lock_version: 1,
          body: "some updated body",
          mail_template_type: "some type",
          status: 43,
          string: "some updated string",
          subject: "some updated subject"
        })

        resp_update = json_response(conn_update, 200)

      # 照会
      conn_show = get(conn_auth, mail_template_path(conn, :show, id))
      resp_show = json_response(conn_show, 200)

      assert resp_show |> Map.delete("id") == %{
               "body" => "some updated body",
               "lock_version" => 2,
               "status" => 43,
               "subject" => "some updated subject",
               "mail_template_type" => "some type"
             }

      # 削除
      conn_del = delete(conn_auth, mail_template_path(conn, :delete, id))
      resp_del = response(conn_del, 204)

      conn_index2 = get(conn_auth, mail_template_path(conn, :index))
      resp_index2 = json_response(conn_index2, 200)
      assert length(resp_index2) == 4
    end
  end
end
