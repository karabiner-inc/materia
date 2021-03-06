defmodule Materia.UserRegistrationAuthPipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline,
    otp_app: :materia,
    module: Materia.UserAuthenticator,
    error_handler: Materia.AuthenticateErrorHandler

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "user_registration"})
  # plug Materia.Plug.Debug
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "user_registration"})
  # plug Materia.Plug.Debug
  plug(Guardian.Plug.EnsureAuthenticated)
  # plug Materia.Plug.Debug
  plug(Guardian.Plug.LoadResource, allow_blank: true)
  # plug Materia.Plug.Debug
end
