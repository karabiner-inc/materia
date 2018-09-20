defmodule ServicexWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ServicexWeb, :controller

  alias Servicex.Errors.ServicexError

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ServicexWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, %MatchError{} = match_error}) do
    call(conn, match_error.term)
  end

  def call(conn, {:error, %ServicexError{} = error}) do
    conn
    |> put_status(:internal_server_error)
    |> ServicexWeb.ErrorView.render_error(error)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(ServicexWeb.ErrorView, :"404")
  end

  def call(conn, error) do
    try do
      throw error
    rescue
      e -> throw e
    after
      conn
      |> put_status(:internal_server_error)
      |> render(ServicexWeb.ErrorView, :"500")
    end
  end
end
