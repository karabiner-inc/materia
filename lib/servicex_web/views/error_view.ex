defmodule ServicexWeb.ErrorView do
  use ServicexWeb, :view

  alias Servicex.Errors.ServicexError
  alias Ecto.StaleEntryError

  require Logger

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render_error(conn, %ServicexError{} = error) do
    gettext = Application.get_env(:servicex, :gettext)
    message = error.message
    Plug.Conn.send_resp(conn, 500, Gettext.gettext(gettext, message))
  end

  def render_error(conn, %StaleEntryError{} = error) do
    gettext = Application.get_env(:servicex, :gettext)
    # StaleEntryErrorのmessageはスキーマの全情報が含まれる。隠匿の為固定メッセージでエラー送出する
    Plug.Conn.send_resp(conn, :unprocessable_entity, Gettext.gettext(gettext, "attempted to update a stale struct"))
  end

  def render_error(conn, error) do
    gettext = Application.get_env(:servicex, :gettext)
    Logger.error("#{__MODULE__} render_error/2. error.message:#{inspect(error.message)}")
    # errorによってどのような項目が含まれているか異なる為、隠匿の為固定メッセージでエラー送出する
    Plug.Conn.send_resp(conn, 500, Gettext.gettext(gettext, "Internal Server Error"))
  end
end
