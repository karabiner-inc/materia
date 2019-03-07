defmodule Materia.Definitions do
  @moduledoc """
  The Definitions context.
  """

  import Ecto.Query, warn: false

  alias MateriaUtils.Ecto.EctoUtil
  alias Materia.Definitions.ValueDefinition

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of value_definitions.

  iex(1)> results = Materia.Definitions.list_value_definitions()
  iex(2)> view = MateriaWeb.ValueDefinitionView.render("index.json", %{value_definitions: results})
  iex(3)> view = view |> Enum.map(fn x -> x = Map.delete(x, :id) end)
  iex(4)> Enum.count(view)
  8
  """
  def list_value_definitions do
    @repo.all(ValueDefinition)
    |> Enum.sort(
         fn x, y ->
           x.definition_category < y.definition_category or (
             x.definition_category == y.definition_category and
             x.display_sort_no < y.display_sort_no)
         end
       )
  end

  @doc """
  Gets a single value_definition.

  iex(1)> results = Materia.Definitions.get_value_definition!(1)
  iex(2)> view = MateriaWeb.ValueDefinitionView.render("show.json", %{value_definition: results})
  iex(3)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id) end) |> List.first
  %{
  definition_abbreviated: "1_1",
  definition_category: "Test1",
  definition_code: "Test_1_01",
  definition_name: "定義1",
  definition_value: "定義値1_1",
  display_discernment_code: nil,
  display_sort_no: 1,
  language_code: "JP",
  lock_version: 0,
  status: 1
  }
  """
  def get_value_definition!(id), do: @repo.get!(ValueDefinition, id)

  @doc """
  Creates a value_definition.

  iex(1)> attrs = %{"definition_category" => "Test1", "definition_name" => "定義1", "definition_code" => "Test_1_03", "definition_value" => "定義値", "display_sort_no" => 3}
  iex(2)> {:ok, results} = Materia.Definitions.create_value_definition(attrs)
  iex(3)> view = MateriaWeb.ValueDefinitionView.render("show.json", %{value_definition: results})
  iex(4)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id) end) |> List.first
  %{
  definition_abbreviated: nil,
  definition_category: "Test1",
  definition_code: "Test_1_03",
  definition_name: "定義1",
  definition_value: "定義値",
  display_discernment_code: nil,
  display_sort_no: 3,
  language_code: nil,
  lock_version: 0,
  status: 1
  }
  """
  def create_value_definition(attrs \\ %{}) do
    %ValueDefinition{}
    |> ValueDefinition.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a value_definition.

  iex(1)> attrs = %{"definition_category" => "Test1", "definition_name" => "定義1", "definition_code" => "Test_1_03", "definition_value" => "定義値", "display_sort_no" => 3}
  iex(2)> value_definition = Materia.Definitions.get_value_definition!(1)
  iex(3)> {:ok, results} = Materia.Definitions.update_value_definition(value_definition, attrs)
  iex(4)> view = MateriaWeb.ValueDefinitionView.render("show.json", %{value_definition: results})
  iex(5)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id) end) |> List.first
  %{
  definition_abbreviated: "1_1",
  definition_category: "Test1",
  definition_code: "Test_1_03",
  definition_name: "定義1",
  definition_value: "定義値",
  display_discernment_code: nil,
  display_sort_no: 3,
  language_code: "JP",
  lock_version: 1,
  status: 1
  }
  """
  def update_value_definition(%ValueDefinition{} = value_definition, attrs) do
    value_definition
    |> ValueDefinition.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ValueDefinition.

  iex(1)> value_definition = Materia.Definitions.get_value_definition!(1)
  iex(2)> {:ok, results} = Materia.Definitions.delete_value_definition(value_definition)
  iex(3)> Materia.Definitions.list_value_definitions() |> Enum.filter(fn x -> x.id == 1 end)
  []
  """
  def delete_value_definition(%ValueDefinition{} = value_definition) do
    @repo.delete(value_definition)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking value_definition changes.
  """
  def change_value_definition(%ValueDefinition{} = value_definition) do
    ValueDefinition.changeset(value_definition, %{})
  end

  @doc """
  汎用検索用エンドポイント

  iex(1)> params = %{"and" => [%{"language_code" => "JP"}], "or" => [%{"definition_code" => "Test_1_01"}, %{"definition_code" => "Test_2_02"}]}
  iex(1)> results = Materia.Definitions.list_value_definitions_by_params(params)
  iex(2)> view = MateriaWeb.ValueDefinitionView.render("index.json", %{value_definitions: results})
  iex(3)> view = view |> Enum.map(fn x -> x = Map.delete(x, :id) end)
    %{
    definition_abbreviated: "1_1",
    definition_category: "Test1",
    definition_code: "Test_1_01",
    definition_name: "定義1",
    definition_value: "定義値1_1",
    display_discernment_code: nil,
    display_sort_no: 1,
    language_code: "JP",
    lock_version: 0,
    status: 1
  },
  %{
    definition_abbreviated: "2_2",
    definition_category: "Test2",
    definition_code: "Test_2_02",
    definition_name: "定義2",
    definition_value: "定義値2_2",
    display_discernment_code: nil,
    display_sort_no: 2,
    language_code: "JP",
    lock_version: 0,
    status: 1
  }
  ]
  """
  def list_value_definitions_by_params(params) do
    EctoUtil.select_by_param(@repo, ValueDefinition, params)
    |> Enum.sort(
         fn x, y ->
           x.definition_category < y.definition_category or (
             x.definition_category == y.definition_category and
             x.display_sort_no < y.display_sort_no)
         end
       )
  end
end
