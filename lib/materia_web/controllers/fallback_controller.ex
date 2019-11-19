defmodule MateriaWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use MateriaWeb, :controller

  alias Materia.Errors.BusinessError
  alias Ecto.StaleEntryError

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(MateriaWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, %MatchError{} = match_error) do
    call(conn, match_error.term)
  end

  def call(conn, %BusinessError{} = error) do
    IO.inspect(error)

    conn
    |> put_status(:bad_request)
    |> MateriaWeb.ErrorView.render_error(error)
  end

  def call(conn, %StaleEntryError{} = error) do
    conn
    |> put_status(:unprocessable_entity)
    |> MateriaWeb.ErrorView.render_error(error)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(MateriaWeb.ErrorView, :"404")
  end

  def call(conn, error) do
    try do
      IO.puts(Exception.format_stacktrace(System.stacktrace()))
      throw(error)
    rescue
      e -> throw(e)
    after
      conn
      |> put_status(:internal_server_error)
      |> render(MateriaWeb.ErrorView, :"500")
    end
  end
end
