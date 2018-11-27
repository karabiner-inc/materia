defmodule Servicex.MailClient do

  require Logger

  def send_mail(from, to, subject, body_text) do

    config = Application.get_env(:servicex, Servicex.MailClient)
    region = config[:mail_ses_region]
    if region == nil do
      raise ServicexError, message: "config :servicex, Servicex.MailClient, mail_ses_region not found."
    end

    Logger.debug("#{__MODULE__} send_mail. start. config:#{inspect(config)}")

    ses_send_params = [
      "--region", region,
      "ses", "send-email",
      "--to", to,
      "--from", from,
      "--subject", subject,
      "--text", body_text
    ]

    {result, return_code} = System.cmd("aws", ses_send_params)

    if return_code != 0 do
      raise ServicexError, message: "ses_send_mail error. return_code:#{return_code} result:#{inspect(result)}"
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
