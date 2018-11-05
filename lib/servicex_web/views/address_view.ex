defmodule ServicexWeb.AddressView do
  use ServicexWeb, :view
  alias ServicexWeb.AddressView

  def render("index.json", %{addresses: addresses}) do
    %{data: render_many(addresses, AddressView, "address.json")}
  end

  def render("show.json", %{address: address}) do
    %{data: render_one(address, AddressView, "address.json")}
  end

  def render("address.json", %{address: address}) do
    %{id: address.id,
      location: address.location,
      zip_code: address.zip_code,
      address1: address.address1,
      address2: address.address2,
      latitud: address.latitud,
      longitude: address.longitude}
  end
end
