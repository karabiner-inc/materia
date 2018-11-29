defmodule Materia.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :hashed_password, :string
      add :role, :string
      add :status, :integer
      add :lock_version, :bigint

      timestamps()
    end

    create unique_index(:users, [:email])
    create index(:users, [:role, :status])
    create index(:users, [:name])
  end
end
