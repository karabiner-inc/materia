defmodule Materia.Repo.Migrations.AddColumnOrganizations do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :fax_number, :string
    end
  end
end
