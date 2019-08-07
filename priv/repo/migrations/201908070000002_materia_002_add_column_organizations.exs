defmodule Materia.Repo.Migrations.AddColumnOrganizations do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :phonetic, :string
      add :ext_organization_id, :string
      add :ext_organization_branch_id, :string
    end
  end
end
