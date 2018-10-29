defmodule ServicexWeb.AuthenticatorView do
  use ServicexWeb, :view
  alias ServicexWeb.AuthenticatorView

  def render("index.json", %{authenticator: authenticator}) do
    render_many(authenticator, AuthenticatorView, "authenticator.json")
  end

  def render("show.json", %{authenticator: authenticator}) do
    render_one(authenticator, AuthenticatorView, "authenticator.json")
  end

  def render("authenticator.json", %{authenticator: authenticator}) do
    result = %{id: authenticator.id,
      access_token: authenticator.access_token,
    }
    if authenticator.refresh_token != nil do
      Map.put(result, :refresh_token, authenticator.refresh_token)
    else
      result
    end
  end

  def render("401.json", %{ message: message }) do
    [
      %{
        id: "UNAUTHORIZED",
        title: "401 Unauthorized",
        detail: message,
        status: 401
      }
    ]

  end

  def render("403.json", %{ message: message }) do
    [
      %{
        id: "FORBIDDEN",
        title: "403 Forbidden",
        detail: message,
        status: 403
      }
    ]
  end

  def render("delete.json", _) do
    %{
        ok: true
     }
  end

end
