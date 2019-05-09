defmodule Materia.Tags do
  @moduledoc """
  The Tags context.

　Provide functions for the purpose of tag master management
　Tags are managed for each tag_category, and the same tag can be registered between different tag_categories.
　New tag registration is always done using merge / 2.
　When the same tag is already registered, the existing registration data is returned without newly registering.
　
　normalize * 1 label entered at the time of registration in merge, and save.
　When searching for a tag candidate, list_tags_by_normalized / 2 is used, and the possibility of being registered with different character strings of already registered tags is reduced by performing the candidate search.
　
　It is possible to register the same normalized tag with different strings because the identity in merge / 2 is judged by the exact match of label.
　
　* 1 normalize
　- Uppercase->Lowercase
　- Hiragana->Katakana
　- Full size->Half size
　- Delete space

  """

  import Ecto.Query, warn: false

  alias Materia.Tags.Tag
  @repo Application.get_env(:materia, :repo)

  alias MateriaUtils.Ecto.EctoUtil
  alias MateriaUtils.String.StringUtil


  @doc """
  Returns the list of tags.

  iex(1)> Materia.Tags.list_tags() |> length()
  6

  """
  def list_tags, do: @repo.all(Tag)

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

  iex(1)> tag = Materia.Tags.get_tag!(1)
  iex(2)> tag.label
  "car"

  """
  def get_tag!(id), do: @repo.get!(Tag, id)

  @doc """
  Creates a tag.

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a tag.

  iex(1)> {:ok, tag} = Materia.Tags.create_tag(%{tag_category: "update_tag", label: "some label", normalized: "somelabel"})
  iex(2)> {:ok, updated_tag} = Materia.Tags.update_tag(tag, %{tag_category: "update_tag", label: "some updated label", normalized: "someupdatedlabel"})
  iex(3)> updated_tag.label
  "some updated label"

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a Tag.

  iex(1)> {:ok, tag} = Materia.Tags.create_tag(%{tag_category: "delete_tag", label: "some label", normalized: "somelabel"})
  iex(2)> {:ok, tag} = Materia.Tags.delete_tag(tag)
  iex(3)> Materia.Tags.list_tags_by_normalized("delete_tag", "%")
  []

  """
  def delete_tag(%Tag{} = tag) do
    @repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end

  @doc """

  get tag by label

  perfect match

  iex(1)> tag = Materia.Tags.get_tag_by_label("skills", "Elixir")
  iex(2)> tag.label
  "Elixir"

  """
  def get_tag_by_label(tag_category, label) do
    @repo.get_by(Tag, [{:tag_category, tag_category}, {:label, label}])
  end

  @doc """

  Search for tags by normalized

  Perform SQL Like search for specified search string

  iex(1)> Materia.Tags.merge_tag(%{}, "catA", "あイ０A")
  iex(2)> Materia.Tags.merge_tag(%{}, "catA", "アxxx x")
  iex(3)> tags = Materia.Tags.list_tags_by_normalized("catA", "ｱ   %")
  iex(4)> length(tags)
  2
  iex(5)> tags = Materia.Tags.list_tags_by_normalized("catA", "ｱい%")
  iex(6)> length(tags)
  1

  """
  def list_tags_by_normalized(tag_category, search_string) do
    normalized = search_string
    |> StringUtil.japanese_normalize()
    query = "select * from tags where tag_category = $1::varchar and normalized like $2::varchar"
    EctoUtil.query(@repo, query, [tag_category, normalized])
  end

  @doc """

  Merge tags

　If it is an unregistered label without the set tag_categry, register new
　If the label is already registered, reply the existing registration contents without registering
　Identity of registration is judged by perfect match of label

  iex(1)> {:ok, tag} = Materia.Tags.merge_tag(%{}, "merge_tag_001", "TagA")
  iex(2)> {:ok, tag} = Materia.Tags.merge_tag(%{}, "merge_tag_001", "Taga")
  iex(3)> tags = Materia.Tags.list_tags_by_normalized("merge_tag_001", "%")
  iex(4)> length(tags)
  2
  iex(5)> {:ok, tag} = Materia.Tags.merge_tag(%{}, "merge_tag_001", "TagA")
  iex(6)> length(tags)
  2

  """
  def merge_tag(%{}, tag_category, label) do
    tag = get_tag_by_label(tag_category, label)
    tag =
    if tag == nil do

      normalized = StringUtil.japanese_normalize(label)
      {:ok, tag}  = create_tag(%{tag_category: tag_category, label: label, normalized: normalized})
    else
      {:ok, tag}
    end
  end

end
