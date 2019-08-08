defmodule Materia.Repo.Migrations.AddColumnAddresses do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add :phone_number, :string
      add :notation_org_name, :string
      add :notation_org_name_phonetic, :string
      add :notation_name, :string
      add :notation_name_phonetic, :string
      add :address1_phonetic, :string
      add :address2_phonetic, :string
      add :address3, :string
      add :address3_phonetic, :string
    end
  end
end
