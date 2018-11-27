defmodule ServicexWeb.TemplateView do
  use ServicexWeb, :view
  alias ServicexWeb.TemplateView

  def render("index.json", %{templates: templates}) do
    %{data: render_many(templates, TemplateView, "template.json")}
  end

  def render("show.json", %{template: template}) do
    %{data: render_one(template, TemplateView, "template.json")}
  end

  def render("template.json", %{template: template}) do
    %{id: template.id,
      string: template.string,
      subject: template.subject,
      body: template.body,
      status: template.status,
      lock_version: template.lock_version}
  end
end
