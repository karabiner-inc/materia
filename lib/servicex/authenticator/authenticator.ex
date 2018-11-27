defmodule Servicex.Authenticator do
  @moduledoc false
  use Guardian, otp_app: :servicex

  alias Servicex.Errors.ServicexError

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

  def resource_from_claims(_claims = %{"email" => email}) do
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

  def sign_in(email, password) do
    config = get_config()
    access_token_ttl = config[:access_token_ttl]
    Logger.debug("#{__MODULE__} --- sign_in access_token_ttl:#{inspect(access_token_ttl)}")
    if access_token_ttl == nil do
      raise ServicexError, message: "servicex.Authenticator access_token_ttl config not found."
    end

    claims = %{"email" => email}
    Logger.debug("#{__MODULE__} --- sign_in claims:#{inspect(claims)}")
    with {:ok,  nil} <- resource_from_claims(claims) do
      {:error, "email or password is invalid"}
    else
      {:ok,  resource} ->
         if Comeonin.Bcrypt.checkpw(password, resource.hashed_password) do
          Logger.debug("#{__MODULE__} --- sign_in Comeonin.Bcrypt.checkpw == true")
           with {:ok, access_token, _access_claims} <- encode_and_sign(resource, claims, [token_type: "access", ttl: access_token_ttl]) do
            Logger.debug("#{__MODULE__} --- sign_in Servicex.Authenticator.encode_and_sign ok")
            Logger.debug("#{__MODULE__} --- sign_in access_token:#{access_token}")
            result = %{id: resource.id ,access_token: access_token}
            refresh_token_ttl = config[:refresh_token_ttl]
              Logger.debug("#{__MODULE__} --- sign_in refresh_token_ttl:#{inspect(refresh_token_ttl)}")
            if refresh_token_ttl != nil do
              refresh_token_ttl = config[:refresh_token_ttl]
              Logger.debug("#{__MODULE__} --- sign_in refresh_token_ttl:#{inspect(refresh_token_ttl)}")
              with {:ok, refresh_token, _refresh_claims} <- encode_and_sign(resource, claims, [token_type: "refresh", ttl: refresh_token_ttl]) do
                result = Map.put(result, :refresh_token, refresh_token)
                {:ok, result}
              else
                _ ->
                {:error, "email or password is invalid"}
              end
            else
              {:ok, result}
            end
           else
            _ ->
            {:error, "email or password is invalid"}
           end
         else
          {:error, "email or password is invalid"}
         end
      _ ->
        {:error, "email or password is invalid"}
    end

  end

  def refresh_tokens(refresh_token) do
    config = get_config()
    access_token_ttl = config[:access_token_ttl]
    Logger.debug("#{__MODULE__} --- refresh_tokens access_token_ttl:#{inspect(access_token_ttl)}")
    if access_token_ttl == nil do
      raise ServicexError, message: "servicex.Authenticator access_token_ttl config not found."
    end

    with {:ok, _refresh, new_access} <- exchange(refresh_token, "refresh", "access", [ttl: access_token_ttl]) do
      {token, claims} = new_access
      Logger.debug("#{__MODULE__} --- refresh_tokens new_access_token:#{inspect(token)}")
      with {:ok, _} <-  Guardian.DB.after_encode_and_sign(%{}, "access", claims, token) do
        refresh_token_ttl = config[:refresh_token_ttl]
        Logger.debug("#{__MODULE__} --- refresh_tokens refresh_token_ttl:#{inspect(refresh_token_ttl)}")
        if refresh_token_ttl == nil do
          raise ServicexError, message: "servicex.Authenticator refresh_token_ttl config not found."
        end
        with {:ok, _old_refresh, new_refresh} <- refresh(refresh_token, [ttl: refresh_token_ttl]) do
          {:ok, new_access, new_refresh}
        else
          _ -> {:error, "invalid token"}
        end
      else
        _ -> {:error, "invalid token"}
      end
    else
      _ -> {:error, "invalid token"}
    end

  end

  def get_user_registration_token(email) do
    config = get_config()
    user_registration_token_ttl = config[:user_registration_token_ttl]
    Logger.debug("#{__MODULE__} --- get_user_registration_token user_registration_token_ttl:#{inspect(user_registration_token_ttl)}")
    if user_registration_token_ttl == nil do
      raise ServicexError, message: "servicex.Authenticator user_registration_token_ttl config not found."
    end
    claims = %{"email" => email}
    Logger.debug("#{__MODULE__} --- get_user_registration_token claims:#{inspect(claims)}")
    with {:ok,  nil} <- resource_from_claims(claims) do
      {:error, "user not found by claims"}
    else
      {:ok,  resource} ->
        with {:ok, user_registration_token, _user_claims} <- encode_and_sign(resource, claims, [token_type: "user_registration", ttl: user_registration_token_ttl]) do
          Logger.debug("#{__MODULE__} --- get_user_registration_token Servicex.Authenticator.encode_and_sign ok")
          Logger.debug("#{__MODULE__} --- get_user_registration_token user_registration_token:#{user_registration_token}")
          {:ok, user_registration_token}
        else
          _ -> {:error, "get_user_registration_token failed."}
        end
      _ -> {:error, "get_user_registration_token failed."}
    end

  end

  defp get_config() do
    config = Application.get_env(:servicex, Servicex.Authenticator)
    if config == nil do
      raise ServicexError, message: "servicex.Authenticator config not found."
    else
      config
    end
  end
end
