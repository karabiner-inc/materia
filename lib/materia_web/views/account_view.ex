defmodule MateriaWeb.AccountView do
  use MateriaWeb, :view
  alias MateriaWeb.AccountView

  alias MateriaWeb.OrganizationView
  alias MateriaWeb.UserView

  def render("index.json", %{accounts: accounts}) do
    render_many(accounts, AccountView, "account.json")
  end

  def render("show.json", %{account: account}) do
    render_one(account, AccountView, "account.json")
  end

  def render("account.json", %{account: account}) do
    result_map = %{
      id: account.id,
      external_code: account.external_code,
      name: account.name,
      start_datetime: account.start_datetime,
      frozen_datetime: account.frozen_datetime,
      expired_datetime: account.expired_datetime,
      descriptions: account.descriptions,
      status: account.status,
      lock_version: account.lock_version
    }

    result_map =
      if Map.has_key?(account, :main_user) && Ecto.assoc_loaded?(account.main_user) do
        Map.put(result_map, :main_user, UserView.render("show.json", %{user: account.main_user}))
      else
        Map.put(result_map, :main_user, nil)
      end

    result_map =
      if Map.has_key?(account, :organization) && Ecto.assoc_loaded?(account.organization) do
        Map.put(result_map, :organization, OrganizationView.render("show.json", %{organization: account.organization}))
      else
        Map.put(result_map, :organization, nil)
      end
  end
end
