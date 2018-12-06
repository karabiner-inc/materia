defmodule Materia.Mail.MailClientStub do
  @behaviour Materia.Mails.MailClient

  def send_mail(from, to, subject, body_text, from_name \\ nil) do
    if to == "error@test.com" do
      reason = "MailClientStub error."
      {:error, reason}
    else
      result = %{from: from, to: to, subject: subject, body_text: body_text, from_name: from_name}
      {:ok, result}
    end
  end
end
