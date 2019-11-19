defmodule Materia.Repo.Migrations.CreateGrants do
  use Ecto.Migration

  def change do
    create table(:grants) do
      add(:role, :string)
      add(:method, :string)
      add(:request_path, :string)

      timestamps()
    end

    create(unique_index(:grants, [:role, :method, :request_path]))
  end
end
