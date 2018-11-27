defmodule ServicexWeb.TemplateControllerTest do
  use ServicexWeb.ConnCase

  alias Servicex.Mails
  alias Servicex.Mails.Template

  @create_attrs %{body: "some body", lock_version: 42, status: 42, string: "some string", subject: "some subject"}
  @update_attrs %{body: "some updated body", lock_version: 43, status: 43, string: "some updated string", subject: "some updated subject"}
  @invalid_attrs %{body: nil, lock_version: nil, status: nil, string: nil, subject: nil}

  def fixture(:template) do
    {:ok, template} = Mails.create_template(@create_attrs)
    template
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all templates", %{conn: conn} do
      conn = get conn, template_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create template" do
    test "renders template when data is valid", %{conn: conn} do
      conn = post conn, template_path(conn, :create), template: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, template_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => "some body",
        "lock_version" => 42,
        "status" => 42,
        "string" => "some string",
        "subject" => "some subject"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, template_path(conn, :create), template: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update template" do
    setup [:create_template]

    test "renders template when data is valid", %{conn: conn, template: %Template{id: id} = template} do
      conn = put conn, template_path(conn, :update, template), template: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, template_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => "some updated body",
        "lock_version" => 43,
        "status" => 43,
        "string" => "some updated string",
        "subject" => "some updated subject"}
    end

    test "renders errors when data is invalid", %{conn: conn, template: template} do
      conn = put conn, template_path(conn, :update, template), template: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete template" do
    setup [:create_template]

    test "deletes chosen template", %{conn: conn, template: template} do
      conn = delete conn, template_path(conn, :delete, template)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, template_path(conn, :show, template)
      end
    end
  end

  defp create_template(_) do
    template = fixture(:template)
    {:ok, template: template}
  end
end
