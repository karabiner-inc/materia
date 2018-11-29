defmodule MateriaWeb.AddressController do
  use MateriaWeb, :controller

  alias Materia.Accounts
  alias Materia.Accounts.Address

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    addresses = Accounts.list_addresses()
    render(conn, "index.json", addresses: addresses)
  end

  def my_addresses(conn, _params) do
    id = String.to_integer(conn.private.guardian_default_claims["sub"])
    addresses = Accounts.list_my_addresses(id)
    render(conn, "index.json", addresses: addresses)
  end

  def create(conn, %{"address" => address_params}) do
    id = String.to_integer(conn.private.guardian_default_claims["sub"])
    address_params =
      address_params |> Map.put("user_id", id)
    with {:ok, %Address{} = address} <- Accounts.create_address(address_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", address_path(conn, :show, address))
      |> render("show.json", address: address)
    end
  end

  def show(conn, %{"id" => id}) do
    address = Accounts.get_address!(id)
    render(conn, "show.json", address: address)
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    address = Accounts.get_address!(id)

    with {:ok, %Address{} = address} <- Accounts.update_address(address, address_params) do
      render(conn, "show.json", address: address)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = Accounts.get_address!(id)
    with {:ok, %Address{}} <- Accounts.delete_address(address) do
      send_resp(conn, :no_content, "")
    end
  end
end
