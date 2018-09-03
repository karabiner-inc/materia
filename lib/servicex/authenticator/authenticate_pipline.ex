defmodule Servicex.AuthenticatePipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline, otp_app: :servicex,
                               module: Servicex.Authenticator,
                               error_handler: Servicex.AuthenticateErrorHandler
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  #plug Servicex.Plug.Debug
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  #plug Servicex.Plug.Debug
  plug Guardian.Plug.EnsureAuthenticated
  #plug Servicex.Plug.Debug
  plug Guardian.Plug.LoadResource, allow_blank: true
  #plug Servicex.Plug.Debug
end
