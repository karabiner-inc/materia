defmodule Materia.Repo.Migrations.CreateValueDefinitions do
  use Ecto.Migration

  def change do
    create table(:value_definitions) do
      add :definition_category, :string
      add :definition_name, :string
      add :definition_code, :string
      add :definition_value, :string
      add :definition_abbreviated, :string
      add :display_sort_no, :integer
      add :display_discernment_code, :string
      add :language_code, :string
      add :status, :integer
      add :lock_version, :bigint

      timestamps()
    end

    create index(:value_definitions, [:definition_category])
    create unique_index(:value_definitions, [:definition_category, :definition_code, :language_code])
  end
end
