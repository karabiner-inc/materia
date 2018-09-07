defmodule Servicex.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :name, :string
    field :role, :string
    field :status, :integer, defalut: 1

    timestamps()
  end

  @doc false
  def changeset_create(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :role, :status])
    |> validate_required([:name, :email, :password, :role])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :role, :status])
    |> unique_constraint(:email)
    |> put_password_hash()
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
      unactivated: 1, # アカウント有効化前
      activated: 2, # アカウント有効中
      frozen: 8, # アカウント凍結中
      expired: 9, #アカウント無効
    }
  end

end
