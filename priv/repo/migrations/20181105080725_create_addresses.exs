defmodule Materia.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :location, :string
      add :zip_code, :string
      add :address1, :string
      add :address2, :string
      add :latitud, :decimal
      add :longitude, :decimal
      add :subject, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:addresses, [:user_id, :subject])
  end
end
