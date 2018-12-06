defmodule Materia.Mail.MailClient do

  @callback send_mail(String.t, String.t, String.t, String.t, String.t) :: :ok | {:error, String.t} | {:error, list(String.t)}

end


