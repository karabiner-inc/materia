defmodule Materia.DefinitionsTest do
  use Materia.DataCase

  doctest Materia.Accounts
  alias Materia.Definitions

  describe "value_definitions" do
    alias Materia.Definitions.ValueDefinition

    @valid_attrs %{definition_abbreviated: "some definition_abbreviated", definition_category: "some definition_category", definition_code: "some definition_code", definition_name: "some definition_name", definition_value: "some definition_value", display_discernment_code: "some display_discernment_code", display_sort_no: 42, language_code: "some language_code", lock_version: 42, status: 42}
    @update_attrs %{definition_abbreviated: "some updated definition_abbreviated", definition_category: "some updated definition_category", definition_code: "some updated definition_code", definition_name: "some updated definition_name", definition_value: "some updated definition_value", display_discernment_code: "some updated display_discernment_code", display_sort_no: 43, language_code: "some updated language_code", lock_version: 43, status: 43}
    @invalid_attrs %{definition_abbreviated: nil, definition_category: nil, definition_code: nil, definition_name: nil, definition_value: nil, display_discernment_code: nil, display_sort_no: nil, language_code: nil, lock_version: nil, status: nil}

    def value_definition_fixture(attrs \\ %{}) do
      {:ok, value_definition} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Definitions.create_value_definition()

      value_definition
    end

    test "list_value_definitions/0 returns all value_definitions" do
      value_definition = value_definition_fixture()
      assert Definitions.list_value_definitions() != []
    end

    test "get_value_definition!/1 returns the value_definition with given id" do
      value_definition = value_definition_fixture()
      assert Definitions.get_value_definition!(value_definition.id) == value_definition
    end

    test "create_value_definition/1 with valid data creates a value_definition" do
      assert {:ok, %ValueDefinition{} = value_definition} = Definitions.create_value_definition(@valid_attrs)
      assert value_definition.definition_abbreviated == "some definition_abbreviated"
      assert value_definition.definition_category == "some definition_category"
      assert value_definition.definition_code == "some definition_code"
      assert value_definition.definition_name == "some definition_name"
      assert value_definition.definition_value == "some definition_value"
      assert value_definition.display_discernment_code == "some display_discernment_code"
      assert value_definition.display_sort_no == 42
      assert value_definition.language_code == "some language_code"
      assert value_definition.lock_version == 42
      assert value_definition.status == 42
    end

    test "create_value_definition/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Definitions.create_value_definition(@invalid_attrs)
    end

    test "update_value_definition/2 with valid data updates the value_definition" do
      value_definition = value_definition_fixture()
      assert {:ok, value_definition} = Definitions.update_value_definition(value_definition, @update_attrs)
      assert %ValueDefinition{} = value_definition
      assert value_definition.definition_abbreviated == "some updated definition_abbreviated"
      assert value_definition.definition_category == "some updated definition_category"
      assert value_definition.definition_code == "some updated definition_code"
      assert value_definition.definition_name == "some updated definition_name"
      assert value_definition.definition_value == "some updated definition_value"
      assert value_definition.display_discernment_code == "some updated display_discernment_code"
      assert value_definition.display_sort_no == 43
      assert value_definition.language_code == "some updated language_code"
      assert value_definition.lock_version == 43
      assert value_definition.status == 43
    end

    test "update_value_definition/2 with invalid data returns error changeset" do
      value_definition = value_definition_fixture()
      assert {:error, %Ecto.Changeset{}} = Definitions.update_value_definition(value_definition, @invalid_attrs)
      assert value_definition == Definitions.get_value_definition!(value_definition.id)
    end

    test "delete_value_definition/1 deletes the value_definition" do
      value_definition = value_definition_fixture()
      assert {:ok, %ValueDefinition{}} = Definitions.delete_value_definition(value_definition)
      assert_raise Ecto.NoResultsError, fn -> Definitions.get_value_definition!(value_definition.id) end
    end

    test "change_value_definition/1 returns a value_definition changeset" do
      value_definition = value_definition_fixture()
      assert %Ecto.Changeset{} = Definitions.change_value_definition(value_definition)
    end

    test "list_value_definitions_by_params/1 and returns list_value_definition" do
      params = %{"and" => [%{"definition_category" => "Test1"}, %{"language_code" => "JP"}]}
      results = Definitions.list_value_definitions_by_params(params)
      results
      |> Enum.map(
           fn result ->
             assert result.status == 1
             assert result.language_code == "JP"
             assert result.definition_category == "Test1"
             assert result.definition_name == "定義1"
             cond do
               result.definition_code == "Test_1_01" ->
                 assert result.display_sort_no == 1
                 assert result.definition_abbreviated == "1_1"
                 assert result.definition_value == "定義値1_1"
               result.definition_code == "Test_1_02" ->
                 assert result.display_sort_no == 2
                 assert result.definition_abbreviated == "1_2"
                 assert result.definition_value == "定義値1_2"
               true -> assert false
             end
           end
         )
    end

    test "list_value_definitions_by_params/1 and or returns list_value_definition" do
      params = %{"and" => [%{"language_code" => "JP"}], "or" => [%{"definition_code" => "Test_1_01"}, %{"definition_code" => "Test_2_02"}]}
      results = Definitions.list_value_definitions_by_params(params)
      results
      |> Enum.map(
           fn result ->
             assert result.status == 1
             assert result.language_code == "JP"
             cond do
               result.definition_code == "Test_1_01" ->
                 assert result.display_sort_no == 1
                 assert result.definition_abbreviated == "1_1"
                 assert result.definition_value == "定義値1_1"
                 assert result.definition_category == "Test1"
                 assert result.definition_name == "定義1"
               result.definition_code == "Test_2_02" ->
                 assert result.display_sort_no == 2
                 assert result.definition_abbreviated == "2_2"
                 assert result.definition_value == "定義値2_2"
                 assert result.definition_category == "Test2"
                 assert result.definition_name == "定義2"
               true -> assert false
             end
           end
         )
    end
  end
end
