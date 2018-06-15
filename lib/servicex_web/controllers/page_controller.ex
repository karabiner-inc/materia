defmodule ServicexWeb.PageController do
  use ServicexWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
