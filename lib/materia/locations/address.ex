defmodule Materia.Locations.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field(:address1, :string)
    field(:address1_p, :string)
    field(:address2, :string)
    field(:address2_p, :string)
    field(:address3, :string)
    field(:address3_p, :string)
    field(:phone_number, :string)
    field(:fax_number, :string)
    field(:notation_org_name, :string)
    field(:notation_org_name_p, :string)
    field(:notation_name, :string)
    field(:notation_name_p, :string)
    field(:latitude, :decimal)
    field(:location, :string)
    field(:longitude, :decimal)
    field(:zip_code, :string)
    field(:subject, :string)
    field(:lock_version, :integer, default: 0)
    field(:status, :integer, default: 1)
    field(:area_code, :string)
    belongs_to(:user, Materia.Accounts.User)
    belongs_to(:organization, Materia.Organizations.Organization)

    timestamps()
  end

  @doc false
  def create_changeset(address, attrs) do
    address
    |> cast(attrs, [
      :location,
      :zip_code,
      :address1,
      :address2,
      :latitude,
      :longitude,
      :user_id,
      :organization_id,
      :subject,
      :lock_version,
      :address1_p,
      :address2,
      :address2_p,
      :address3,
      :address3_p,
      :phone_number,
      :notation_org_name,
      :notation_org_name_p,
      :notation_name,
      :notation_name_p,
      :fax_number,
      :status,
      :area_code
    ])
    |> validate_required([:subject])
  end

  def update_changeset(address, attrs) do
    address
    |> cast(attrs, [
      :location,
      :zip_code,
      :address1,
      :address2,
      :latitude,
      :longitude,
      :user_id,
      :organization_id,
      :subject,
      :lock_version,
      :address1_p,
      :address2,
      :address2_p,
      :address3,
      :address3_p,
      :phone_number,
      :notation_org_name,
      :notation_org_name_p,
      :notation_name,
      :notation_name_p,
      :fax_number,
      :status,
      :area_code
    ])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end
end
