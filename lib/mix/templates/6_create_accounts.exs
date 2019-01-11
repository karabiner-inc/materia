defmodule Materia.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :external_code, :string
      add :name, :string
      add :start_datetime, :utc_datetime
      add :frozen_datetime, :utc_datetime
      add :expired_datetime, :utc_datetime
      add :descriptions, :string, size: 1000
      add :organization_id, references(:organizations, on_delete: :nothing)
      add :main_user_id, references(:users, on_delete: :nothing)
      add :status, :integer
      add :lock_version, :bigint

      timestamps()
    end

    create unique_index(:accounts, [:external_code])
    create index(:accounts, [:name])
    create index(:accounts, [:organization_id])
    create index(:accounts, [:status, :start_datetime])
  end
end
