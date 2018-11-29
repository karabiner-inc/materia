defmodule Materia.AuthenticatePipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline, otp_app: :materia,
                               module: Materia.Authenticator,
                               error_handler: Materia.AuthenticateErrorHandler
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  #plug Materia.Plug.Debug
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  #plug Materia.Plug.Debug
  plug Guardian.Plug.EnsureAuthenticated
  #plug Materia.Plug.Debug
  plug Guardian.Plug.LoadResource, allow_blank: true
  #plug Materia.Plug.Debug
end
