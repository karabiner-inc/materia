defmodule MateriaWeb.AddressController do
  use MateriaWeb, :controller

  alias Materia.Locations
  alias Materia.Locations.Address
  alias MateriaWeb.ControllerBase

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    addresses = Locations.list_addresses()
    render(conn, "index.json", addresses: addresses)
  end

  def create(conn, address_params) do
    with {:ok, %Address{} = address} <- Locations.create_address(address_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", address_path(conn, :show, address))
      |> render("show.json", address: address)
    end
  end

  def create_my_address(conn, address_params) do
    #id = String.to_integer(conn.private.guardian_default_claims["sub"])
    id = ControllerBase.get_user_id(conn)
    address_params =
      address_params |> Map.put("user_id", id)
    with {:ok, %Address{} = address} <- Locations.create_address(address_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", address_path(conn, :show, address))
      |> render("show.json", address: address)
    end
  end

  def show(conn, %{"id" => id}) do
    address = Locations.get_address!(id)
    render(conn, "show.json", address: address)
  end

  def update(conn, address_params) do
    address = Locations.get_address!(address_params["id"])

    with {:ok, %Address{} = address} <- Locations.update_address(address, address_params) do
      render(conn, "show.json", address: address)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = Locations.get_address!(id)
    with {:ok, %Address{}} <- Locations.delete_address(address) do
      send_resp(conn, :no_content, "")
    end
  end
end
