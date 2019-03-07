defmodule Materia.Definitions.ValueDefinition do
  use Ecto.Schema
  import Ecto.Changeset


  schema "value_definitions" do
    field :definition_abbreviated, :string
    field :definition_category, :string
    field :definition_code, :string
    field :definition_name, :string
    field :definition_value, :string
    field :display_discernment_code, :string
    field :display_sort_no, :integer
    field :language_code, :string
    field :lock_version, :integer, default: 0
    field :status, :integer, default: 1

    timestamps()
  end

  def changeset(value_definition, attrs) do
    value_definition
    |> cast(attrs, [:definition_category, :definition_name, :definition_code, :definition_value, :definition_abbreviated, :display_sort_no, :display_discernment_code, :language_code, :status, :lock_version])
    |> validate_required([:definition_category, :definition_name, :definition_code, :definition_value, :display_sort_no])
  end

  def update_changeset(value_definition, attrs) do
    value_definition
    |> cast(attrs, [:definition_category, :definition_name, :definition_code, :definition_value, :definition_abbreviated, :display_sort_no, :display_discernment_code, :language_code, :status, :lock_version])
    |> validate_required([:definition_category, :definition_name, :definition_code, :definition_value, :display_sort_no, :lock_version])
    |> optimistic_lock(:lock_version)
  end
end
