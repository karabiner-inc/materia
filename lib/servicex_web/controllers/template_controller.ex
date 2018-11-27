defmodule ServicexWeb.TemplateController do
  use ServicexWeb, :controller

  alias Servicex.Mails
  alias Servicex.Mails.Template

  action_fallback ServicexWeb.FallbackController

  def index(conn, _params) do
    templates = Mails.list_templates()
    render(conn, "index.json", templates: templates)
  end

  def create(conn, %{"template" => template_params}) do
    with {:ok, %Template{} = template} <- Mails.create_template(template_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", template_path(conn, :show, template))
      |> render("show.json", template: template)
    end
  end

  def show(conn, %{"id" => id}) do
    template = Mails.get_template!(id)
    render(conn, "show.json", template: template)
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    template = Mails.get_template!(id)

    with {:ok, %Template{} = template} <- Mails.update_template(template, template_params) do
      render(conn, "show.json", template: template)
    end
  end

  def delete(conn, %{"id" => id}) do
    template = Mails.get_template!(id)
    with {:ok, %Template{}} <- Mails.delete_template(template) do
      send_resp(conn, :no_content, "")
    end
  end
end
