defmodule MateriaWeb.ValueDefinitionControllerTest do
  use MateriaWeb.ConnCase

  alias Materia.Definitions
  alias Materia.Definitions.ValueDefinition

  @create_attrs %{definition_abbreviated: "some definition_abbreviated", definition_category: "some definition_category", definition_code: "some definition_code", definition_name: "some definition_name", definition_value: "some definition_value", display_discernment_code: "some display_discernment_code", display_sort_no: 42, language_code: "some language_code", lock_version: 42, status: 42}
  @update_attrs %{definition_abbreviated: "some updated definition_abbreviated", definition_category: "some updated definition_category", definition_code: "some updated definition_code", definition_name: "some updated definition_name", definition_value: "some updated definition_value", display_discernment_code: "some updated display_discernment_code", display_sort_no: 43, language_code: "some updated language_code", lock_version: 43, status: 43}
  @invalid_attrs %{definition_abbreviated: nil, definition_category: nil, definition_code: nil, definition_name: nil, definition_value: nil, display_discernment_code: nil, display_sort_no: nil, language_code: nil, lock_version: nil, status: nil}

  @admin_user_attrs %{
    "name": "hogehoge",
    "email": "hogehoge@example.com",
    "password": "hogehoge",
    "role": "admin"
  }

  def fixture(:value_definition) do
    {:ok, value_definition} = Definitions.create_value_definition(@create_attrs)
    value_definition
  end

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    token_conn = post conn, authenticator_path(conn, :sign_in), @admin_user_attrs
    %{"access_token" => token } = json_response(token_conn, 201)
    {:ok, conn: put_req_header(conn, "authorization", "Bearer " <> token)}
  end

  describe "index" do
    test "lists all value_definitions", %{conn: conn} do
      conn = get conn, value_definition_path(conn, :index)
      assert json_response(conn, 200) != []
    end
  end

  describe "create value_definition" do
    test "renders value_definition when data is valid", %{conn: conn} do
      result_conn = post conn, value_definition_path(conn, :create), value_definition: @create_attrs
      assert %{"id" => id} = json_response(result_conn, 201)

      conn = get conn, value_definition_path(conn, :show, id)
      assert json_response(conn, 200) == %{
        "id" => id,
        "definition_abbreviated" => "some definition_abbreviated",
        "definition_category" => "some definition_category",
        "definition_code" => "some definition_code",
        "definition_name" => "some definition_name",
        "definition_value" => "some definition_value",
        "display_discernment_code" => "some display_discernment_code",
        "display_sort_no" => 42,
        "language_code" => "some language_code",
        "lock_version" => 42,
        "status" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, value_definition_path(conn, :create), value_definition: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update value_definition" do
    setup [:create_value_definition]

    test "renders value_definition when data is valid", %{conn: conn, value_definition: %ValueDefinition{id: id} = value_definition} do
      result_conn = put conn, value_definition_path(conn, :update, value_definition), value_definition: @update_attrs
      assert %{"id" => ^id} = json_response(result_conn, 200)

      conn = get conn, value_definition_path(conn, :show, id)
      assert json_response(conn, 200) == %{
        "id" => id,
        "definition_abbreviated" => "some updated definition_abbreviated",
        "definition_category" => "some updated definition_category",
        "definition_code" => "some updated definition_code",
        "definition_name" => "some updated definition_name",
        "definition_value" => "some updated definition_value",
        "display_discernment_code" => "some updated display_discernment_code",
        "display_sort_no" => 43,
        "language_code" => "some updated language_code",
        "lock_version" => 43,
        "status" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, value_definition: value_definition} do
      conn = put conn, value_definition_path(conn, :update, value_definition), value_definition: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete value_definition" do
    setup [:create_value_definition]

    test "deletes chosen value_definition", %{conn: conn, value_definition: value_definition} do
      result_conn = delete conn, value_definition_path(conn, :delete, value_definition)
      assert response(result_conn, 204)
      assert_error_sent 404, fn ->
        get conn, value_definition_path(conn, :show, value_definition)
      end
    end
  end

  describe "search_definitions_by_params" do
    test "all_definitions" , %{conn: conn} do
      conn = post conn, value_definition_path(conn, :list_definitions_by_params), nil
      assert json_response(conn, 200)
             |> Enum.count() == 8
    end

    test "definitions" , %{conn: conn} do
      conn = post conn, value_definition_path(conn, :list_definitions_by_params),
                  %{
                    "and" => [%{"language_code" => "JP"}],
                    "or" => [%{"definition_code" => "Test_1_01"}, %{"definition_code" => "Test_2_02"}]
                  }
      assert json_response(conn, 200)
             |> Enum.map(
                  fn result ->
                    assert result["status"] == 1
                    assert result["language_code"] == "JP"
                    cond do
                      result["definition_code"] == "Test_1_01" ->
                        assert result["display_sort_no"] == 1
                        assert result["definition_abbreviated"] == "1_1"
                        assert result["definition_value"] == "定義値1_1"
                        assert result["definition_category"] == "Test1"
                        assert result["definition_name"] == "定義1"
                      result["definition_code"] == "Test_2_02" ->
                        assert result["display_sort_no"] == 2
                        assert result["definition_abbreviated"] == "2_2"
                        assert result["definition_value"] == "定義値2_2"
                        assert result["definition_category"] == "Test2"
                        assert result["definition_name"] == "定義2"
                      true -> assert false
                    end
                  end
                )
    end
  end

  defp create_value_definition(_) do
    value_definition = fixture(:value_definition)
    {:ok, value_definition: value_definition}
  end
end
