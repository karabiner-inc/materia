defmodule ServicexWeb.GrantController do
  use ServicexWeb, :controller

  alias Servicex.Accounts
  alias Servicex.Accounts.Grant

  action_fallback ServicexWeb.FallbackController

  def index(conn, _params) do
    grants = Accounts.list_grants()
    render(conn, "index.json", grants: grants)
  end

  def get_by_role(conn, params) do
    grants = Accounts.get_grant_by_role(params["role"])
    render(conn, "index.json", grants: grants)
  end

  def create(conn, grant_params) do
    with {:ok, %Grant{} = grant} <- Accounts.create_grant(grant_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", grant_path(conn, :show, grant))
      |> render("show.json", grant: grant)
    end
  end

  def show(conn, %{"id" => id}) do
    grant = Accounts.get_grant!(id)
    render(conn, "show.json", grant: grant)
  end

  def update(conn, grant_params) do
    grant = Accounts.get_grant!(grant_params["id"])

    with {:ok, %Grant{} = grant} <- Accounts.update_grant(grant, grant_params) do
      render(conn, "show.json", grant: grant)
    end
  end

  def delete(conn, %{"id" => id}) do
    grant = Accounts.get_grant!(id)
    with {:ok, %Grant{}} <- Accounts.delete_grant(grant) do
      send_resp(conn, :no_content, "")
    end
  end
end
