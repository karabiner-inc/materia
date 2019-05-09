defmodule MateriaWeb.TagView do
  use MateriaWeb, :view
  alias MateriaWeb.TagView

  def render("index.json", %{tags: tags}) do
    render_many(tags, TagView, "tag.json")
  end

  def render("show.json", %{tag: tag}) do
    render_one(tag, TagView, "tag.json")
  end

  def render("tag.json", %{tag: tag}) do
    %{
      id: tag.id,
      tag_category: tag.tag_category,
      label: tag.label,
      normalized: tag.normalized,
    }
  end
end
