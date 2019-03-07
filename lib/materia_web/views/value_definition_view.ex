defmodule MateriaWeb.ValueDefinitionView do
  use MateriaWeb, :view
  alias MateriaWeb.ValueDefinitionView

  def render("index.json", %{value_definitions: value_definitions}) do
    render_many(value_definitions, ValueDefinitionView, "value_definition.json")
  end

  def render("show.json", %{value_definition: value_definition}) do
    render_one(value_definition, ValueDefinitionView, "value_definition.json")
  end

  def render("value_definition.json", %{value_definition: value_definition}) do
    %{
      id: value_definition.id,
      definition_category: value_definition.definition_category,
      definition_name: value_definition.definition_name,
      definition_code: value_definition.definition_code,
      definition_value: value_definition.definition_value,
      definition_abbreviated: value_definition.definition_abbreviated,
      display_sort_no: value_definition.display_sort_no,
      display_discernment_code: value_definition.display_discernment_code,
      language_code: value_definition.language_code,
      status: value_definition.status,
      lock_version: value_definition.lock_version
    }
  end
end
