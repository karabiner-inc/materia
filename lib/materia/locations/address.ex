defmodule Materia.Locations.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :naive_datetime_usec] # timestamps() の型

  schema "addresses" do
    field :address1, :string
    field :address2, :string
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
    |> cast(attrs, [:location, :zip_code, :address1, :address2, :latitude, :longitude, :user_id, :organization_id, :subject, :lock_version])
    |> validate_required([:subject])
  end

  def update_changeset(address, attrs) do
    address
    |> cast(attrs, [:location, :zip_code, :address1, :address2, :latitude, :longitude, :user_id, :organization_id, :subject, :lock_version])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end
end
