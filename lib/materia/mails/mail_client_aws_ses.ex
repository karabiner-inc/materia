defmodule Materia.Mails.MailClientAwsSes do
  alias Materia.Errors.BusinessError

  require Logger

  @behaviour Materia.Mails.MailClient

  @spec send_mail(String.t(), String.t(), String.t(), String.t(), String.t()) ::
          :ok | {:error, String.t()} | {:error, list(String.t())}
  def send_mail(from, to, subject, body_text, from_name \\ nil) do
    config = Application.get_env(:materia, Materia.Mails.MailClient)
    region = config[:mail_ses_region]

    if region == nil do
      raise BusinessError, message: "config :materia, Materia.MailClient, mail_ses_region not found."
    end

    Logger.debug("#{__MODULE__} send_mail. start. config:#{inspect(config)}")

    ses_send_params = [
      "--region",
      region,
      "ses",
      "send-email",
      "--to",
      to,
      "--from",
      from,
      "--subject",
      subject,
      "--text",
      body_text
    ]

    {result, return_code} = System.cmd("aws", ses_send_params)

    if return_code != 0 do
      raise BusinessError, message: "ses_send_mail error. return_code:#{return_code} result:#{inspect(result)}"
    end

    {:ok, json_result} = Poison.decode(result)

    if return_code != 0 do
      Logger.error("#{__MODULE__} send_mail. error. return_code:#{return_code} result:#{result}")
      {:error, json_result}
    else
      Logger.info("#{__MODULE__} send_mail. succcess. return_code:#{return_code} result:#{result}")
      {:ok, json_result}
    end
  end
end
