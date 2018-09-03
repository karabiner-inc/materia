defmodule Servicex.Authenticator do
  @moduledoc false
  use Guardian, otp_app: :servicex

  require Logger

  def subject_for_token(resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    Logger.debug("---  #{__MODULE__} subject_for_token --------------")
    sub = to_string(resource.id)
    {:ok, sub}
  end
  def subject_for_token(_, _) do
    Logger.debug("---  #{__MODULE__} subject_for_token --------------")
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims = %{"email" => email}) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    Logger.debug("---  #{__MODULE__} resource_from_claims by email--------------")
    resource = Servicex.Accounts.get_user_by_email!(email)
    {:ok,  resource}
  end
  def resource_from_claims(_claims) do
    Logger.debug("---  #{__MODULE__} resource_from_claims by other--------------")
    {:error, :reason_for_error}
  end
  def after_encode_and_sign(resource, claims, token, _options) do
    Logger.debug("---  #{__MODULE__} after_encode_and_sign --------------")
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      Logger.debug("---  #{__MODULE__} Guardian.DB.after_encode_and_sign ok --------------")
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    Logger.debug("---  #{__MODULE__} on_verify --------------")
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    Logger.debug("---  #{__MODULE__} on_refresh --------------")
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  def on_revoke(claims, token, _options) do
    Logger.debug("---  #{__MODULE__} on_revoke --------------")
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end
