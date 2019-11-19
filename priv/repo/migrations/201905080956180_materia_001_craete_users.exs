defmodule Materia.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:organization_id, :bigint)
      add(:name, :string)
      add(:email, :string)
      add(:role, :string)
      add(:status, :integer)
      add(:phone_number, :string)
      add(:back_ground_img_url, :string)
      add(:external_user_id, :string)
      add(:icon_img_url, :string)
      add(:one_line_message, :string)
      add(:descriptions, :string, size: 10000)
      add(:hashed_password, :string)
      add(:lock_version, :bigint)
      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(index(:users, [:role, :status, :name]))
    create(index(:users, [:name, :status]))
    create(index(:users, [:external_user_id, :status]))
    create(index(:users, [:organization_id, :status]))
    create(index(:users, [:phone_number, :status]))
  end
end
