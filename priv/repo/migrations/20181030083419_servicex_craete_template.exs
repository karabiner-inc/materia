defmodule Servicex.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :subject, :string
      add :body, :string, size: 10000
      add :status, :integer
      add :lock_version, :bigint

      timestamps()
    end

  end

end
