defmodule Materia.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add(:name, :string)
      add(:hp_url, :string)
      add(:profile_img_url, :string)
      add(:back_ground_img_url, :string)
      add(:one_line_message, :string)
      add(:phone_number, :string)
      add(:lock_version, :bigint)
      add(:status, :integer)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:organizations, [:user_id, :status, :name]))
    create(index(:organizations, [:status, :name]))
  end
end
