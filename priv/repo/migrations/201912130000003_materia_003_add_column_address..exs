defmodule Materia.Repo.Migrations.AddColumnAddresses do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add(:status, :integer)
      add(:area_code, :string)
    end
  end
end
