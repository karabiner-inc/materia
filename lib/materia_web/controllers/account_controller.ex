defmodule MateriaWeb.AccountController do
  use MateriaWeb, :controller

  alias Materia.Accounts
  alias Materia.Accounts.Account
  alias MateriaWeb.ControllerBase

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, "index.json", accounts: accounts)
  end

  def list_accounts_by_params(conn, params) do
    accounts = Accounts.list_accounts_by_params(params)
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, account_params) do
    with {:ok, %Account{} = account} <-Accounts.create_account(account_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", account_path(conn, :show, account))
      |> render("show.json", account: account)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, "show.json", account: account)
  end

  def show_my_account(conn, _params) do
    id = ControllerBase.get_account_id(conn)
    account = Accounts.get_account!(id)
    render(conn, "show.json", account: account)
  end

  def update(conn, account_params) do
    account = Accounts.get_account!(account_params["id"])
    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, "show.json", account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
