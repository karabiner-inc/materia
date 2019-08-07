defmodule MateriaWeb.AddressView do
  use MateriaWeb, :view
  alias MateriaWeb.AddressView
  alias MateriaWeb.UserView
  alias MateriaWeb.OrganizationView

  def render("index.json", %{addresses: addresses}) do
    render_many(addresses, AddressView, "address.json")
  end

  def render("show.json", %{address: address}) do
    render_one(address, AddressView, "address.json")
  end

  def render("address.json", %{address: address}) do
    result_map = %{id: address.id,
      location: address.location,
      zip_code: address.zip_code,
      address1: address.address1,
      address1_phonetic: address.address1_phonetic,
      address2: address.address2,
      address2_phonetic: address.address2_phonetic,
      address3: address.address3,
      address3_phonetic: address.address3_phonetic,
      phone_number: address.phone_number,
      notation_org_name: address.notation_org_name,
      notation_org_phonetic: address.notation_org_phonetic,
      notation_name: address.notation_name,
      notation_phonetic: address.notation_phonetic,
      latitude: address.latitude,
      longitude: address.longitude,
      subject: address.subject,
      lock_version: address.lock_version,
    }
    result_map =
      if Ecto.assoc_loaded?(address.user) do
        Map.put(result_map, :user, UserView.render("show.json", %{user: address.user}))
      else
        Map.put(result_map, :user, [])
      end
    result_map =
      if Ecto.assoc_loaded?(address.organization) do
        Map.put(result_map, :organization, OrganizationView.render("show.json", %{organization: address.organization}))
      else
        Map.put(result_map, :organization, nil)
      end
  end
end
