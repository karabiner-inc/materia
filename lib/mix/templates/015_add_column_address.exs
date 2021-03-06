defmodule Materia.Repo.Migrations.AddColumnAddresses do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add(:phone_number, :string)
      add(:notation_org_name, :string)
      add(:notation_org_name_p, :string)
      add(:notation_name, :string)
      add(:notation_name_p, :string)
      add(:address1_p, :string)
      add(:address2_p, :string)
      add(:address3, :string)
      add(:address3_p, :string)
    end
  end
end
