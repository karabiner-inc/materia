defmodule ServicexWeb.GrantView do
  use ServicexWeb, :view
  alias ServicexWeb.GrantView

  def render("index.json", %{grants: grants}) do
    render_many(grants, GrantView, "grant.json")
  end

  def render("show.json", %{grant: grant}) do
    render_one(grant, GrantView, "grant.json")
  end

  def render("grant.json", %{grant: grant}) do
    %{id: grant.id,
      role: grant.role,
      method: grant.method,
      request_path: grant.request_path}
  end
end
