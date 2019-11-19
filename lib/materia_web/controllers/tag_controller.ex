defmodule MateriaWeb.TagController do
  use MateriaWeb, :controller

  alias Materia.Tags
  alias Materia.Tags.Tag

  action_fallback(MateriaWeb.FallbackController)

  def list_tags_by_normalized(conn, %{"tag_category" => tag_category, "search_string" => search_string}) do
    tags = Tags.list_tags_by_normalized(tag_category, search_string)
    render(conn, "index.json", tags: tags)
  end

  def merge(conn, %{"tag_category" => tag_category, "label" => label}) do
    MateriaWeb.ControllerBase.transaction_flow(conn, :tag, Materia.Tags, :merge_tag, [tag_category, label])
  end
end
