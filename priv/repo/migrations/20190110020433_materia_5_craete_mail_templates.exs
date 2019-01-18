defmodule Materia.Repo.Migrations.CreateMailTemplates do
  use Ecto.Migration

  def change do
    create table(:mail_templates) do
      add(:mail_template_type, :string)
      add(:subject, :string)
      add(:body, :string, size: 10000)
      add(:status, :integer)
      add(:lock_version, :bigint)

      timestamps()
    end

    create(index(:mail_templates, [:mail_template_type, :status]))
    create(index(:mail_templates, [:status, :mail_template_type]))
  end
end
