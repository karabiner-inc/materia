defmodule Materia.Repo.Migrations.AddColumnUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :phonetic, :string
    end
  end
end
