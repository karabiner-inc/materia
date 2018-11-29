defmodule MateriaWeb.MailTemplateView do
  use MateriaWeb, :view
  alias MateriaWeb.MailTemplateView

  def render("index.json", %{mail_mail_templates: mail_mail_templates}) do
    %{data: render_many(mail_mail_templates, TemplateView, "mail_template.json")}
  end

  def render("show.json", %{mail_template: mail_template}) do
    %{data: render_one(mail_template, MailTemplateView, "mail_template.json")}
  end

  def render("mail_template.json", %{mail_template: mail_template}) do
    %{id: mail_template.id,
      string: mail_template.string,
      subject: mail_template.subject,
      body: mail_template.body,
      status: mail_template.status,
      lock_version: mail_template.lock_version}
  end
end
