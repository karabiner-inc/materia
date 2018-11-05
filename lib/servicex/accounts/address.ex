defmodule Servicex.Accounts.Address do
  use Ecto.Schema
  import Ecto.Changeset


  schema "addresses" do
    field :address1, :string
    field :address2, :string
    field :latitud, :decimal
    field :location, :string
    field :longitude, :decimal
    field :zip_code, :string
    belongs_to :user, Servicex.Accounts.Users

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:location, :zip_code, :address1, :address2, :latitud, :longitude, :user_id])
    # |> validate_required([:location, :zip_code, :address1, :address2, :latitud, :longitude])
  end
end
