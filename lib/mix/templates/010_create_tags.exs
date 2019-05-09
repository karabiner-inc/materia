defmodule Materia.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :tag_category, :string
      add :label, :string
      add :normalized, :string

      timestamps()
    end
    create index(:tags, [:tag_category, :normalized])
  end
end
