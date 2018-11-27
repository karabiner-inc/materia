defmodule Servicex.Mails.SendgridMailClient do
  @doc """
  Send mail by SendGrid
  """
  require Logger

  alias SendGrid.{Mailer, Email}

  @spec send_mail(%{from: String.t, name: String.t}, String.t, String.t, String.t) :: :ok | {:error, String.t} | {:error, list(String.t)}
  def send_mail(%{from: from, name: name}, to, subject, body_text) do
    
    result = Email.build()
    |> Email.add_to(to)
    |> Email.put_from(from, name)
    |> Email.put_text(body_text)
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