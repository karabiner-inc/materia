defmodule MateriaWeb.UserView do
  use MateriaWeb, :view
  alias MateriaWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      status: user.status,
      lock_version: user.lock_version,
    }
  end

  def render("show.json", %{tmp_user: tmp_user}) do
    %{
      user: render("user.json", %{user: tmp_user.user}),
      user_registration_token: tmp_user.user_registration_token,
    }
  end
end
