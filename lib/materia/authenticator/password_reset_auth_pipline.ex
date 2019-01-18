defmodule Materia.PasswordResetAuthPipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline, otp_app: :materia,
                               module: Materia.UserAuthenticator,
                               error_handler: Materia.AuthenticateErrorHandler
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "password_reset"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "password_reset"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
