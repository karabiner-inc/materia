defmodule Materia.AccountAuthenticator do
  @moduledoc false

  require Logger

  use Guardian, otp_app: :materia

  # use Materia.AuthenticatorBase, except: [subject_for_token: 2, resource_from_claims: 1,on_verify: 3]
  use Materia.AuthenticatorBase, except: [subject_for_token: 2, resource_from_claims: 1, on_verify: 3]

  alias Materia.Errors.BusinessError
  alias Materia.Accounts.User
  alias Materia.Accounts.Account

  alias Materia.Accounts

  @msg_err_invalid_token "invalid token"
  @msg_err_invalid_email_or_pass "account or email or password is invalid"

  def subject_for_token(resource, _claims) do
    # Override Materia.Authenticator
    Logger.debug("---  #{__MODULE__} subject_for_token --------------")
    {:ok, sub} = Poison.encode(%{user_id: resource.user.id, account_id: resource.account.id})
  end

  def subject_for_token(_, _) do
    Logger.debug("---  #{__MODULE__} subject_for_token reason_for_error--------------")
    {:error, :reason_for_error}
  end

  def resource_from_claims(_claims = %{"email" => email, "account" => account}) do
    # Override Materia.Authenticator
    Logger.debug("---  #{__MODULE__} resource_from_claims by email--------------")
    user = Materia.Accounts.get_user_by_email(email)

    if user.organization_id == nil do
      {:error, "account #{account} not found."}
    else
      org_accounts = Accounts.list_accounts_by_params(%{"and" => [%{"organization_id" => user.organization_id}]})
      org_account = Enum.find(org_accounts, fn org_account -> org_account.external_code === account end)

      if org_account == nil do
        {:error, "account #{account} not found."}
      else
        resource = %{user: user, account: org_account}
        {:ok, resource}
      end
    end
  end

  def resource_from_claims(_claims) do
    Logger.debug("---  #{__MODULE__} resource_from_claims by other--------------")
    {:error, :reason_for_error}
  end

  def on_verify(claims, token, _options) do
    Logger.debug("---  #{__MODULE__} on_verify --------------")

    user = Materia.Accounts.get_user!(get_user_id_from_claims(claims))

    case claims["typ"] do
      "access" ->
        if user.status != User.status().activated do
          raise BusinessError, message: @msg_err_invalid_token
        end

      "user_registration" ->
        if user.status != User.status().unactivated do
          raise BusinessError, message: @msg_err_invalid_token
        end

      "password_reset" ->
        if user.status != User.status().activated do
          raise BusinessError, message: @msg_err_invalid_token
        end

      _ ->
        raise BusinessError, message: @msg_err_invalid_token
    end

    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def sign_in(account, email, password) do
    config = get_config()
    access_token_ttl = config[:access_token_ttl]
    Logger.debug("#{__MODULE__} --- sign_in access_token_ttl:#{inspect(access_token_ttl)}")

    if access_token_ttl == nil do
      raise BusinessError, message: "materia.Authenticator access_token_ttl config not found."
    end

    claims = %{"email" => email, "account" => account}
    Logger.debug("#{__MODULE__} --- sign_in claims:#{inspect(claims)}")

    with {:ok, nil} <- resource_from_claims(claims) do
      {:error, @msg_err_invalid_email_or_pass}
    else
      {:ok, resource} ->
        if resource.user.status != User.status().activated or resource.account.status != Account.status().activated do
          {:error, @msg_err_invalid_email_or_pass}
        else
          if Comeonin.Bcrypt.checkpw(password, resource.user.hashed_password) do
            Logger.debug("#{__MODULE__} --- sign_in Comeonin.Bcrypt.checkpw == true")

            with {:ok, access_token, _access_claims} <-
                   encode_and_sign(resource, claims, token_type: "access", ttl: access_token_ttl) do
              Logger.debug("#{__MODULE__} --- sign_in Materia.Authenticator.encode_and_sign ok")
              Logger.debug("#{__MODULE__} --- sign_in access_token:#{access_token}")
              result = %{id: resource.user.id, access_token: access_token}
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

  #  def refresh_tokens(refresh_token) do
  #    config = get_config()
  #    access_token_ttl = config[:access_token_ttl]
  #    Logger.debug("#{__MODULE__} --- refresh_tokens access_token_ttl:#{inspect(access_token_ttl)}")
  #
  #    if access_token_ttl == nil do
  #      raise BusinessError, message: "materia.Authenticator access_token_ttl config not found."
  #    end
  #
  #    with {:ok, _refresh, new_access} <-
  #           exchange(refresh_token, "refresh", "access", ttl: access_token_ttl) do
  #      {token, claims} = new_access
  #      Logger.debug("#{__MODULE__} --- refresh_tokens new_access_token:#{inspect(token)}")
  #
  #      with {:ok, _} <- Guardian.DB.after_encode_and_sign(%{}, "access", claims, token) do
  #        refresh_token_ttl = config[:refresh_token_ttl]
  #
  #        Logger.debug(
  #          "#{__MODULE__} --- refresh_tokens refresh_token_ttl:#{inspect(refresh_token_ttl)}"
  #        )
  #
  #        if refresh_token_ttl == nil do
  #          raise BusinessError,
  #            message: "materia.Authenticator refresh_token_ttl config not found."
  #        end
  #
  #        with {:ok, _old_refresh, new_refresh} <- refresh(refresh_token, ttl: refresh_token_ttl) do
  #          {:ok, new_access, new_refresh}
  #        else
  #          _ -> {:error, @msg_err_invalid_token}
  #        end
  #      else
  #        _ -> {:error, @msg_err_invalid_token}
  #      end
  #    else
  #      _ -> {:error, @msg_err_invalid_token}
  #    end
  #  end

  def get_account_id_from_claims(claims) do
    _account_code =
      try do
        sub = claims["sub"]
        {:ok, sub} = Poison.decode(sub)
        user_id = sub["account_id"]
      rescue
        _e in KeyError ->
          Logger.debug("#{__MODULE__} conn.private.guardian_default_claims is not found. anonymus operation!")

          raise BusinessError,
            message:
              "conn.private.guardian_default_claims is not found. anonymus operation!\rthis endpoint need Materia.AccountAuthPipeline. check your app's router.ex"
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
