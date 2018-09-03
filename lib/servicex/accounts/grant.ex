defmodule Servicex.Accounts.Grant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "grants" do
    field :request_path, :string
    field :method, :string
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(grant, attrs) do
    grant
    |> cast(attrs, [:role, :method, :request_path])
    |> validate_required([:role, :method, :request_path])
    #|> unique_constraint([:role, :method, :request_path])
  end

  def method do
    %{ any: "ANY" }
  end

  def role do
    %{ anybody: "anybody" }
  end

end
