defmodule Materia.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :name, :string
    field :role, :string
    field :back_ground_img_url, :string
    field :external_user_id, :string
    field :icon_img_url, :string
    field :one_line_message, :string
    field :descriptions, :string
    field :phone_number, :string
    field :status, :integer, default: 1
    field :lock_version, :integer, default: 0

    belongs_to :organization ,Materia.Organizations.Organization
    has_many :addresses, Materia.Locations.Address

    timestamps()
  end

  @doc false
  def changeset_tmp_registration(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :role, :status, :external_user_id, :back_ground_img_url, :icon_img_url, :one_line_message, :descriptions, :phone_number, :lock_version])
    |> put_change(:status, status.unactivated)
    |> validate_required([:email, :role, :status])
    |> unique_constraint(:email)
    |> optimistic_lock(:lock_version)
  end

  @doc false
  def changeset_registration(user, attrs) do
    user
    |> cast(attrs, [:name, :password, :role, :status, :external_user_id, :back_ground_img_url, :icon_img_url, :one_line_message, :descriptions, :phone_number, :lock_version])
    |> put_change(:status, status.activated)
    |> validate_required([:name, :password, :role])
    |> put_password_hash()
    |> optimistic_lock(:lock_version)
  end

  @doc false
  def changeset_create(user, attrs) do
    user
    |> cast(attrs, [:organization_id, :name, :email, :password, :role, :status, :external_user_id, :back_ground_img_url, :icon_img_url, :one_line_message, :descriptions, :phone_number, :lock_version])
    |> validate_required([:name, :email, :password, :role])
    |> unique_constraint(:email)
    |> put_password_hash()
    |> optimistic_lock(:lock_version)
  end

  @doc false
  def changeset_update(user, attrs) do
    user
    |> cast(attrs, [:organization_id, :name, :email, :password, :role, :status, :external_user_id, :back_ground_img_url, :icon_img_url, :one_line_message, :descriptions, :phone_number, :lock_version])
    |> validate_required([:lock_version])
    |> unique_constraint(:email)
    |> put_password_hash()
    |> optimistic_lock(:lock_version)
  end

  def changeset_authentication(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    changeset =
    case changeset do
      %Ecto.Changeset{ valid?: true, changes: %{ password: pass }} ->
        put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(pass))
      _ ->
        changeset
    end
  end

  def status() do
    %{
      unactivated: 0, # アカウント有効化前
      activated: 1, # アカウント有効中
      frozen: 8, # アカウント凍結中
      expired: 9, #アカウント無効
    }
  end

end
