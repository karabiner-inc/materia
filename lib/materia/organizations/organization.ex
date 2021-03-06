defmodule Materia.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field(:ext_organization_id, :string)
    field(:ext_organization_branch_id, :string)
    field(:back_ground_img_url, :string)
    field(:hp_url, :string)
    field(:name, :string)
    field(:name_p, :string)
    field(:one_line_message, :string)
    field(:profile_img_url, :string)
    field(:phone_number, :string)
    field(:fax_number, :string)
    field(:lock_version, :integer, default: 0)
    field(:status, :integer, default: 1)

    has_many(:users, Materia.Accounts.User)
    has_many(:addresses, Materia.Locations.Address)

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [
      :name,
      :hp_url,
      :profile_img_url,
      :back_ground_img_url,
      :one_line_message,
      :phone_number,
      :status,
      :lock_version,
      :ext_organization_id,
      :ext_organization_branch_id,
      :name_p,
      :fax_number
    ])
    |> validate_required([:name])
    |> optimistic_lock(:lock_version)
  end

  def update_changeset(organization, attrs) do
    organization
    |> cast(attrs, [
      :name,
      :hp_url,
      :profile_img_url,
      :back_ground_img_url,
      :one_line_message,
      :phone_number,
      :status,
      :lock_version,
      :ext_organization_id,
      :ext_organization_branch_id,
      :name_p,
      :fax_number
    ])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end

  def status() do
    %{
      # 有効
      active: 1,
      # 無効
      unactive: 9
    }
  end
end
