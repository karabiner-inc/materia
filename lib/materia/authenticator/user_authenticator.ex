defmodule Materia.UserAuthenticator do
  @moduledoc false

  require Logger

  use Guardian, otp_app: :materia

  use Materia.AuthenticatorBase

  alias Materia.Errors.BusinessError

  @behaviour Materia.AuthenticatorBase

  @msg_err_invalid_token "invalid token"
  @msg_err_invalid_email_or_pass "email or password is invalid"

  def subject_for_token(resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    Logger.debug("---  #{__MODULE__} subject_for_token --------------")
    # sub = to_string(resource.id)
    {:ok, sub} = Poison.encode(%{user_id: resource.id})
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    Logger.debug("---  #{__MODULE__} subject_for_token reason_for_error--------------")
    {:error, :reason_for_error}
  end

  def resource_from_claims(_claims = %{"email" => email}) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    Logger.debug("---  #{__MODULE__} resource_from_claims by email--------------")
    resource = Materia.Accounts.get_user_by_email(email)
    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    Logger.debug("---  #{__MODULE__} resource_from_claims by other--------------")
    {:error, :reason_for_error}
  end

  def sign_in(email, password) do
    config = get_config()
    access_token_ttl = config[:access_token_ttl]
    Logger.debug("#{__MODULE__} --- sign_in access_token_ttl:#{inspect(access_token_ttl)}")

    if access_token_ttl == nil do
      raise BusinessError, message: "materia.Authenticator access_token_ttl config not found."
    end

    claims = %{"email" => email}
    Logger.debug("#{__MODULE__} --- sign_in claims:#{inspect(claims)}")

    with {:ok, nil} <- resource_from_claims(claims) do
      {:error, @msg_err_invalid_email_or_pass}
    else
      {:ok, resource} ->
        if resource.status != Materia.Accounts.User.status().activated do
          {:error, @msg_err_invalid_email_or_pass}
        else
          if Comeonin.Bcrypt.checkpw(password, resource.hashed_password) do
            Logger.debug("#{__MODULE__} --- sign_in Comeonin.Bcrypt.checkpw == true")

            with {:ok, access_token, _access_claims} <-
                   encode_and_sign_cb(resource, claims, token_type: "access", ttl: access_token_ttl) do
              Logger.debug("#{__MODULE__} --- sign_in Materia.Authenticator.encode_and_sign ok")
              Logger.debug("#{__MODULE__} --- sign_in access_token:#{access_token}")
              result = %{id: resource.id, access_token: access_token}
              refresh_token_ttl = config[:refresh_token_ttl]

              Logger.debug("#{__MODULE__} --- sign_in refresh_token_ttl:#{inspect(refresh_token_ttl)}")

              if refresh_token_ttl != nil do
                refresh_token_ttl = config[:refresh_token_ttl]

                Logger.debug("#{__MODULE__} --- sign_in refresh_token_ttl:#{inspect(refresh_token_ttl)}")

                with {:ok, refresh_token, _refresh_claims} <-
                       encode_and_sign(
                         resource,
                         claims,
                         token_type: "refresh",
                         ttl: refresh_token_ttl
                       ) do
                  result = Map.put(result, :refresh_token, refresh_token)
                  {:ok, result}
                else
                  _ ->
                    {:error, @msg_err_invalid_email_or_pass}
                end
              else
                {:ok, result}
              end
            else
              _ ->
                {:error, @msg_err_invalid_email_or_pass}
            end
          else
            {:error, @msg_err_invalid_email_or_pass}
          end
        end

      _ ->
        {:error, @msg_err_invalid_email_or_pass}
    end
  end

  def encode_and_sign_cb(resource, claims, options) do
    encode_and_sign(resource, claims, options)
  end

  def exchange_cb(old_token, from_type, to_type, options) do
    exchange(old_token, from_type, to_type, options)
  end

  def refresh_cb(refresh_token, options) do
    refresh(refresh_token, options)
  end
end
