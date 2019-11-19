defmodule Materia.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field(:tag_category, :string)
    field(:label, :string)
    field(:normalized, :string)

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:tag_category, :label, :normalized])
    |> validate_required([:tag_category, :label, :normalized])
  end
end
