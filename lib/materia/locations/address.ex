defmodule Materia.Locations.Address do
  use Ecto.Schema
  import Ecto.Changeset


  schema "addresses" do
    field :address1, :string
    field :address1_phonetic, :string
    field :address2, :string
    field :address2_phonetic, :string
    field :address3, :string
    field :address3_phonetic, :string
    field :phone_number, :string
    field :fax_number, :string
    field :notation_org_name, :string
    field :notation_org_name_phonetic, :string
    field :notation_name, :string
    field :notation_name_phonetic, :string
    field :latitude, :decimal
    field :location, :string
    field :longitude, :decimal
    field :zip_code, :string
    field :subject, :string
    field :lock_version, :integer, default: 0
    belongs_to :user, Materia.Accounts.User
    belongs_to :organization, Materia.Organizations.Organization

    timestamps()
  end

  @doc false
  def create_changeset(address, attrs) do
    address
    |> cast(attrs, [:location, :zip_code, :address1, :address2, :latitude, :longitude, :user_id, :organization_id, :subject, :lock_version, :address1_phonetic, :address2, :address2_phonetic, :address3, :address3_phonetic, :phone_number, :notation_org_name, :notation_org_name_phonetic, :notation_name, :notation_name_phonetic, :fax_number])
    |> validate_required([:subject])
  end

  def update_changeset(address, attrs) do
    address
    |> cast(attrs, [:location, :zip_code, :address1, :address2, :latitude, :longitude, :user_id, :organization_id, :subject, :lock_version, :address1_phonetic, :address2, :address2_phonetic, :address3, :address3_phonetic, :phone_number, :notation_org_name, :notation_org_name_phonetic, :notation_name, :notation_name_phonetic, :fax_number])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end
end
