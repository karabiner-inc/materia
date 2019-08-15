defmodule Materia.Repo.Migrations.AddColumnUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :fax_number, :string
    end
  end
end
