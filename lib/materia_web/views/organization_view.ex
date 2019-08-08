defmodule MateriaWeb.OrganizationView do
  use MateriaWeb, :view
  alias MateriaWeb.OrganizationView

  alias MateriaWeb.UserView
  alias MateriaWeb.AddressView

  def render("index.json", %{organizations: organizations}) do
    render_many(organizations, OrganizationView, "organization.json")
  end

  def render("show.json", %{organization: organization}) do
    render_one(organization, OrganizationView, "organization.json")
  end

  def render("organization.json", %{organization: organization}) do
    result_map = %{
      id: organization.id,
      ext_organization_id: organization.ext_organization_id,
      ext_organization_branch_id: organization.ext_organization_branch_id,
      name: organization.name,
      name_phonetic: organization.name_phonetic,
      hp_url: organization.hp_url,
      profile_img_url: organization.profile_img_url,
      back_ground_img_url: organization.back_ground_img_url,
      one_line_message: organization.one_line_message,
      phone_number: organization.phone_number,
      lock_version: organization.lock_version,
      status: organization.status,
    }
    result_map =
      if Ecto.assoc_loaded?(organization.users) do
        Map.put(result_map, :users, UserView.render("index.json", %{users: organization.users}))
      else
        Map.put(result_map, :users, [])
      end
    result_map =
      if Ecto.assoc_loaded?(organization.addresses) do
        Map.put(result_map, :addresses, AddressView.render("index.json", %{addresses: organization.addresses}))
      else
        Map.put(result_map, :addresses, [])
      end
  end
end
