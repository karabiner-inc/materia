defmodule Materia.Repo.Migrations.AddColumnUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name_phonetic, :string
    end
  end
end
