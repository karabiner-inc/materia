defmodule Materia.Repo.Migrations.AddColumnAddresses do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add(:fax_number, :string)
    end
  end
end
