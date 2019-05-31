defmodule Materia.Mails.MailClientSendGrid do
  @doc """
  Send mail by SendGrid

  need configure

  ```
  config :sendgrid,
    api_key: "your sendgrid api key"
  ```

  """
  require Logger

  alias SendGrid.{Mailer, Email}

  @spec send_mail(String.t, String.t, String.t, String.t, String.t) :: :ok | {:error, String.t} | {:error, list(String.t)}
  def send_mail(from, to, subject, body_text, from_name \\ nil ) do

    result = Email.build()
    |> Email.add_to(to)
    |> Email.put_from(from, from_name)
    |> Email.put_text(body_text)
    |> Email.put_html(String.replace(body_text, "\n", "<br/>"))
    |> Email.put_subject(subject)
    |> Mailer.send()

    with :ok <- result do
      Logger.info("#{__MODULE__} send_mail. succcess.")
      {:ok, "success"}
    else
      {:error, error} ->
        Logger.error("#{__MODULE__} send_mail. error. result:#{error}")
        {:error, error}
    end
  end

end
