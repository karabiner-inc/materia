defmodule Materia.Authenticator do
  @moduledoc false
  use Guardian, otp_app: :materia

  alias Materia.Errors.BusinessError
  alias Materia.Accounts.User

  require Logger

  @msg_err_invalid_token "invalid token"
  @msg_err_invalid_email_or_pass "email or password is invalid"

  def subject_for_token(resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    Logger.debug("---  #{__MODULE__} subject_for_token --------------")
    #sub = to_string(resource.id)
    {:ok, sub} =  Poison.encode(%{user_id: resource.id})
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
    resource = Materia.Accounts.get_user_by_email(email)
    {:ok, resource}
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

    user = Materia.Accounts.get_user!(get_user_id_from_claims(claims))

    case claims["typ"] do
      "access" ->
        if user.status != User.status.activated do
          raise BusinessError, message: @msg_err_invalid_token
        end
      "user_registration" ->
        if user.status != User.status.unactivated do
          raise BusinessError, message: @msg_err_invalid_token
        end
      "password_reset" ->
        if user.status != User.status.activated do
          raise BusinessError, message: @msg_err_invalid_token
        end
      _ ->
        raise BusinessError, message: @msg_err_invalid_token
    end

    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    Logger.debug("---  #{__MODULE__} on_refresh --------------")

    #with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
    with {:ok, _, _} <- on_refresh({old_token, old_claims}, {new_token, new_claims}) do

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
                   encode_and_sign(resource, claims, token_type: "access", ttl: access_token_ttl) do
              Logger.debug("#{__MODULE__} --- sign_in Materia.Authenticator.encode_and_sign ok")
              Logger.debug("#{__MODULE__} --- sign_in access_token:#{access_token}")
              result = %{id: resource.id, access_token: access_token}
              refresh_token_ttl = config[:refresh_token_ttl]

              Logger.debug(
                "#{__MODULE__} --- sign_in refresh_token_ttl:#{inspect(refresh_token_ttl)}"
              )

              if refresh_token_ttl != nil do
                refresh_token_ttl = config[:refresh_token_ttl]

                Logger.debug(
                  "#{__MODULE__} --- sign_in refresh_token_ttl:#{inspect(refresh_token_ttl)}"
                )

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

  def refresh_tokens(refresh_token) do
    config = get_config()
    access_token_ttl = config[:access_token_ttl]
    Logger.debug("#{__MODULE__} --- refresh_tokens access_token_ttl:#{inspect(access_token_ttl)}")

    if access_token_ttl == nil do
      raise BusinessError, message: "materia.Authenticator access_token_ttl config not found."
    end

    with {:ok, _refresh, new_access} <-
           exchange(refresh_token, "refresh", "access", ttl: access_token_ttl) do
      {token, claims} = new_access
      Logger.debug("#{__MODULE__} --- refresh_tokens new_access_token:#{inspect(token)}")

      with {:ok, _} <- Guardian.DB.after_encode_and_sign(%{}, "access", claims, token) do
        refresh_token_ttl = config[:refresh_token_ttl]

        Logger.debug(
          "#{__MODULE__} --- refresh_tokens refresh_token_ttl:#{inspect(refresh_token_ttl)}"
        )

        if refresh_token_ttl == nil do
          raise BusinessError,
            message: "materia.Authenticator refresh_token_ttl config not found."
        end

        with {:ok, _old_refresh, new_refresh} <- refresh(refresh_token, ttl: refresh_token_ttl) do
          {:ok, new_access, new_refresh}
        else
          _ -> {:error, @msg_err_invalid_token}
        end
      else
        _ -> {:error, @msg_err_invalid_token}
      end
    else
      _ -> {:error, @msg_err_invalid_token}
    end
  end

  def get_user_registration_token(email) do
    config = get_config()
    user_registration_token_ttl = config[:user_registration_token_ttl]

    Logger.debug("#{__MODULE__} --- get_user_registration_token user_registration_token_ttl:#{inspect(user_registration_token_ttl)}")

    if user_registration_token_ttl == nil do
      raise BusinessError, message: "materia.Authenticator user_registration_token_ttl config not found."
    end

    get_custom_token(email, "user_registration", user_registration_token_ttl)

  end

  def get_password_reset_token(email) do
    config = get_config()
    password_reset_token_ttl = config[:password_reset_token_ttl]

    Logger.debug("#{__MODULE__} --- get_password_reset_token password_reset_token_ttl:#{inspect(password_reset_token_ttl)}")

    if password_reset_token_ttl == nil do
      raise BusinessError, message: "materia.Authenticator password_reset_token_ttl config not found."
    end

    get_custom_token(email, "password_reset", password_reset_token_ttl)

  end

  def get_user_id_from_claims(claims) do
    {:ok, sub} = Poison.decode(claims["sub"])
    user_id = sub["user_id"]
  end

  @doc false
  defp get_custom_token(email, token_type, token_ttl) do
    claims = %{"email" => email}
    Logger.debug("#{__MODULE__} --- get_custom_token start. claims:#{inspect(claims)}")

    with {:ok, nil} <- resource_from_claims(claims) do
      {:error, "user not found by claims"}
    else
      {:ok, resource} ->
        with {:ok, user_registration_token, _user_claims} <-
               encode_and_sign(
                 resource,
                 claims,
                 token_type: token_type,
                 ttl: token_ttl
               ) do
          Logger.debug("#{__MODULE__} --- get_custom_token Materia.Authenticator.encode_and_sign ok")
          Logger.debug("#{__MODULE__} --- get_custom_token user_registration_token:#{user_registration_token}")

          {:ok, user_registration_token}
        else
          _ -> {:error, "get_custom_token failed."}
        end

      _ ->
        {:error, "get_custom_token failed."}
    end

  end

  defp get_config() do
    config = Application.get_env(:materia, Materia.Authenticator)

    if config == nil do
      raise BusinessError, message: "materia.Authenticator config not found."
    else
      config
    end
  end

  defp on_refresh({old_token, old_claims}, {new_token, new_claims}) do
    Guardian.DB.on_revoke(old_claims, old_token)
    Guardian.DB.after_encode_and_sign(%{}, new_claims["typ"], new_claims, new_token)

    {:ok, {old_token, old_claims}, {new_token, new_claims}}
  end

end
