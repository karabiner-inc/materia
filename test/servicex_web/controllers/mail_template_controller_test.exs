defmodule MateriaWeb.TemplateControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Mails
  alias Materia.Mails.MailTemplate

  @create_attrs %{body: "some body", lock_version: 42, status: 42, string: "some string", subject: "some subject"}
  @update_attrs %{body: "some updated body", lock_version: 43, status: 43, string: "some updated string", subject: "some updated subject"}
  @invalid_attrs %{body: nil, lock_version: nil, status: nil, string: nil, subject: nil}

  def fixture(:mail_template) do
    {:ok, mail_template} = Mails.create_mail_template(@create_attrs)
    mail_template
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all mail_templates", %{conn: conn} do
      conn = get conn, mail_template_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create mail_template" do
    test "renders mail_template when data is valid", %{conn: conn} do
      conn = post conn, mail_template_path(conn, :create), mail_template: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, mail_template_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => "some body",
        "lock_version" => 42,
        "status" => 42,
        "string" => "some string",
        "subject" => "some subject"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, mail_template_path(conn, :create), mail_template: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update mail_template" do
    setup [:create_mail_template]

    test "renders mail_template when data is valid", %{conn: conn, mail_template: %MailTemplate{id: id} = mail_template} do
      conn = put conn, mail_template_path(conn, :update, mail_template), mail_template: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, mail_template_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => "some updated body",
        "lock_version" => 43,
        "status" => 43,
        "string" => "some updated string",
        "subject" => "some updated subject"}
    end

    test "renders errors when data is invalid", %{conn: conn, mail_template: mail_template} do
      conn = put conn, mail_template_path(conn, :update, mail_template), mail_template: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete mail_template" do
    setup [:create_mail_template]

    test "deletes chosen mail_template", %{conn: conn, mail_template: mail_template} do
      conn = delete conn, mail_template_path(conn, :delete, mail_template)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, mail_template_path(conn, :show, mail_template)
      end
    end
  end

  defp create_mail_template(_) do
    mail_template = fixture(:mail_template)
    {:ok, mail_template: mail_template}
  end
end
