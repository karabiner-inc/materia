defmodule Servicex.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :hashed_password, :string
      add :role, :string
      add :status, :integer

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
