defmodule Materia.Repo.Migrations.CreateMailTemplates do
  use Ecto.Migration

  def change do
    create table(:mail_templates) do
      add :subject, :string
      add :body, :string, size: 10000
      add :status, :integer
      add :lock_version, :bigint

      timestamps()
    end

  end

end
