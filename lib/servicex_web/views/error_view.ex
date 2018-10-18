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
    message = error.message
    |> gettext_message()
    |> encode_message()
    Plug.Conn.send_resp(conn, 500, message)
  end

  def render_error(conn, %StaleEntryError{} = error) do
    Logger.error("#{__MODULE__} render_error/2. error:#{inspect(error)}")
    # StaleEntryErrorのmessageはスキーマの全情報が含まれる。隠匿の為固定メッセージでエラー送出する
    message = "attempted to update a stale struct"
    |> gettext_message()
    |> encode_message()
    Plug.Conn.send_resp(conn, :unprocessable_entity, message)
  end

  def render_error(conn, error) do
    Logger.error("#{__MODULE__} render_error/2. error:#{inspect(error)}")
    # errorによってどのような項目が含まれているか異なる為、隠匿の為固定メッセージでエラー送出する
    message = "Internal Server Error"
    |> gettext_message()
    |> encode_message()
    Plug.Conn.send_resp(conn, 500, message)
  end

  def gettext_message(message) when is_binary(message) do
    gettext = Application.get_env(:servicex, :gettext)
    Gettext.gettext(gettext, message)
  end

  def gettext_message(message) do
    message
  end

  def encode_message(message) do

    with {:ok, json_message} <- Poison.encode(message) do
      json_message
    else
      {:error, reason} ->
        "\"#{__MODULE__} encode_message. error message encode failed. reason:#{inspect(reason)}\""
    end
  end
end
