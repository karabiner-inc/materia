defmodule MateriaWeb.MailTemplateController do
  use MateriaWeb, :controller

  alias Materia.Mails
  alias Materia.Mails.MailTemplate

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    mail_templates = Mails.list_mail_templates()
    render(conn, "index.json", mail_templates: mail_templates)
  end

  def create(conn, mail_template_params) do
    with {:ok, %MailTemplate{} = mail_template} <- Mails.create_mail_template(mail_template_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", mail_template_path(conn, :show, mail_template))
      |> render("show.json", mail_template: mail_template)
    end
  end

  def show(conn, %{"id" => id}) do
    mail_template = Mails.get_mail_template!(id)
    render(conn, "show.json", mail_template: mail_template)
  end

  def update(conn, mail_template_params) do
    mail_template = Mails.get_mail_template!(mail_template_params["id"])

    with {:ok, %MailTemplate{} = mail_template} <- Mails.update_mail_template(mail_template, mail_template_params) do
      render(conn, "show.json", mail_template: mail_template)
    end
  end

  def delete(conn, %{"id" => id}) do
    mail_template = Mails.get_mail_template!(id)
    with {:ok, %MailTemplate{}} <- Mails.delete_mail_template(mail_template) do
      send_resp(conn, :no_content, "")
    end
  end
end
