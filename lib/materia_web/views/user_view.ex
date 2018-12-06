defmodule MateriaWeb.UserView do
  use MateriaWeb, :view
  alias MateriaWeb.UserView
  alias MateriaWeb.AddressView
  alias MateriaWeb.OrganizationView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    result_map =%{
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      status: user.status,
      back_ground_img_url: user.back_ground_img_url,
      external_user_id: user.external_user_id,
      icon_img_url: user.icon_img_url,
      descriptions: user.descriptions,
      phone_number: user.phone_number,
      lock_version: user.lock_version,
    }
    result_map =
      if Ecto.assoc_loaded?(user.addresses) do
        Map.put(result_map, :addresses, AddressView.render("index.json", %{addresses: user.addresses}))
      else
        Map.put(result_map, :addresses, [])
      end
    result_map =
      if Ecto.assoc_loaded?(user.organization) do
        Map.put(result_map, :organization, OrganizationView.render("show.json", %{organization: user.organization}))
      else
        Map.put(result_map, :organization, [])
      end
  end

  def render("show.json", %{tmp_user: tmp_user}) do
    %{
      user: render("user.json", %{user: tmp_user.user}),
      user_registration_token: tmp_user.user_registration_token,
    }
  end

  def render("show.json", %{user_token: user_token}) do
    %{
      user: render("user.json", %{user: user_token.user}),
      access_token: user_token.access_token,
      refresh_token: user_token.refresh_token,
    }
  end

  def render("show.json", %{password_reset: password_reset}) do
    %{
      password_reset_token: password_reset.password_reset_token,
    }
  end
end
