defmodule Materia.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset


  schema "accounts" do
    field :external_code, :string
    field :name, :string
    field :start_datetime, :utc_datetime
    field :frozen_datetime, :utc_datetime
    field :expired_datetime, :utc_datetime
    field :descriptions, :string
    field :status, :integer, default: 1
    field :lock_version, :integer, default: 0
    belongs_to :organization ,Materia.Organizations.Organization
    belongs_to :main_user ,Materia.Accounts.User, [foreign_key: :main_user_id]

    timestamps()
  end

  @doc false
  def create_changeset(account, attrs) do
    account
    |> cast(attrs, [:external_code, :name, :start_datetime, :descriptions, :frozen_datetime, :expired_datetime,:status, :organization_id, :main_user_id, :lock_version])
    |> validate_required([:external_code, :start_datetime])
    |> unique_constraint(:code)
  end

  @doc false
  def update_changeset(account, attrs) do
    account
    |> cast(attrs, [:external_code, :name, :start_datetime, :descriptions, :frozen_datetime, :expired_datetime, :status, :organization_id, :main_user_id, :lock_version])
    |> validate_required([:lock_version])
    |> unique_constraint(:code)
    |> optimistic_lock(:lock_version)
  end

  def status() do
    %{
      activated: 1, # アカウント有効
      frozen: 8, # アカウント凍結中
      expired: 9, #アカウント無効
    }
  end
end
