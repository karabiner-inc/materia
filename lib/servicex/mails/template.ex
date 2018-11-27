defmodule Servicex.Mails.Template do
  use Ecto.Schema
  import Ecto.Changeset


  schema "templates" do
    field :body, :string
    field :lock_version, :integer, default: 1
    field :status, :integer, default: 1
    field :subject, :string

    timestamps()
  end

  @doc false
  def changeset_create(template, attrs) do
    template
    |> cast(attrs, [:subject, :body, :status, :lock_version])
    |> validate_required([:subject, :body])
  end

  @doc false
  def changeset_update(template, attrs) do
    template
    |> cast(attrs, [:subject, :body, :status, :lock_version])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end

  def status() do
    %{
      active: 1, # 有効
      inactive: 2, # 無効
    }
  end
end
