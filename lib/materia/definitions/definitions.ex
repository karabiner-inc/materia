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

  ## Examples

      iex> list_value_definitions()
      [%ValueDefinition{}, ...]

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

  Raises `Ecto.NoResultsError` if the Value definition does not exist.

  ## Examples

      iex> get_value_definition!(123)
      %ValueDefinition{}

      iex> get_value_definition!(456)
      ** (Ecto.NoResultsError)

  """
  def get_value_definition!(id), do: @repo.get!(ValueDefinition, id)

  @doc """
  Creates a value_definition.

  ## Examples

      iex> create_value_definition(%{field: value})
      {:ok, %ValueDefinition{}}

      iex> create_value_definition(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_value_definition(attrs \\ %{}) do
    %ValueDefinition{}
    |> ValueDefinition.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a value_definition.

  ## Examples

      iex> update_value_definition(value_definition, %{field: new_value})
      {:ok, %ValueDefinition{}}

      iex> update_value_definition(value_definition, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_value_definition(%ValueDefinition{} = value_definition, attrs) do
    value_definition
    |> ValueDefinition.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ValueDefinition.

  ## Examples

      iex> delete_value_definition(value_definition)
      {:ok, %ValueDefinition{}}

      iex> delete_value_definition(value_definition)
      {:error, %Ecto.Changeset{}}

  """
  def delete_value_definition(%ValueDefinition{} = value_definition) do
    @repo.delete(value_definition)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking value_definition changes.

  ## Examples

      iex> change_value_definition(value_definition)
      %Ecto.Changeset{source: %ValueDefinition{}}

  """
  def change_value_definition(%ValueDefinition{} = value_definition) do
    ValueDefinition.changeset(value_definition, %{})
  end

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
