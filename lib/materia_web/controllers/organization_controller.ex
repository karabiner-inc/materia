defmodule MateriaWeb.OrganizationController do
  use MateriaWeb, :controller

  alias Materia.Organizations
  alias Materia.Organizations.Organization

  action_fallback(MateriaWeb.FallbackController)

  def index(conn, _params) do
    organizations = Organizations.list_organizations()
    render(conn, "index.json", organizations: organizations)
  end

  def create(conn, organization_params) do
    with {:ok, %Organization{} = organization} <- Organizations.create_organization(organization_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", organization_path(conn, :show, organization))
      |> render("show.json", organization: organization)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)
    render(conn, "show.json", organization: organization)
  end

  def update(conn, organization_params) do
    organization = Organizations.get_organization!(organization_params["id"])

    with {:ok, %Organization{} = organization} <- Organizations.update_organization(organization, organization_params) do
      render(conn, "show.json", organization: organization)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)

    with {:ok, %Organization{}} <- Organizations.delete_organization(organization) do
      send_resp(conn, :no_content, "")
    end
  end
end
