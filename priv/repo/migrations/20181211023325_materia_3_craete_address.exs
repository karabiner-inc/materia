defmodule Materia.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :location, :string
      add :zip_code, :string
      add :address1, :string
      add :address2, :string
      add :latitude, :decimal
      add :longitude, :decimal
      add :subject, :string
      add :lock_version, :bigint
      add :user_id, references(:users, on_delete: :delete_all)
      add :organization_id, references(:organizations, on_delete: :delete_all)

      timestamps()
    end

    create index(:addresses, [:user_id, :subject])
    create index(:addresses, [:organization_id, :subject])
    create index(:addresses, [:subject, :location])
  end

end
