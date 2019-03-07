defmodule MateriaWeb.ValueDefinitionController do
  use MateriaWeb, :controller

  alias Materia.Definitions
  alias Materia.Definitions.ValueDefinition

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    value_definitions = Definitions.list_value_definitions()
    render(conn, "index.json", value_definitions: value_definitions)
  end

  def create(conn, %{"value_definition" => value_definition_params}) do
    with {:ok, %ValueDefinition{} = value_definition} <- Definitions.create_value_definition(value_definition_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", value_definition_path(conn, :show, value_definition))
      |> render("show.json", value_definition: value_definition)
    end
  end

  def show(conn, %{"id" => id}) do
    value_definition = Definitions.get_value_definition!(id)
    render(conn, "show.json", value_definition: value_definition)
  end

  def update(conn, %{"id" => id, "value_definition" => value_definition_params}) do
    value_definition = Definitions.get_value_definition!(id)

    with {:ok, %ValueDefinition{} = value_definition} <- Definitions.update_value_definition(value_definition, value_definition_params) do
      render(conn, "show.json", value_definition: value_definition)
    end
  end

  def delete(conn, %{"id" => id}) do
    value_definition = Definitions.get_value_definition!(id)
    with {:ok, %ValueDefinition{}} <- Definitions.delete_value_definition(value_definition) do
      send_resp(conn, :no_content, "")
    end
  end

  def list_definitions_by_params(conn, value_definition_params) do
    value_definitions = Definitions.list_value_definitions_by_params(value_definition_params)
    render(conn, "index.json", value_definitions: value_definitions)
  end
end
