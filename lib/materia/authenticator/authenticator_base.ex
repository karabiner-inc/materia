defmodule Materia.AuthenticatorBase do
  @moduledoc false

  alias Materia.Errors.BusinessError
  alias Materia.Accounts.User

  require Logger

  @callback encode_and_sign_cb(any(), Guardian.Token.claims(), List) ::
              {:ok, Guardian.Token.token(), Guardian.Token.claims()} | {:error, any()}
  @callback exchange_cb(
              Guardian.Token.token(),
              String.t() | [String.t(), ...],
              String.t(),
              List
            ) ::
              {:ok, {Guardian.Token.token(), Guardian.Token.claims()},
               {Guardian.Token.token(), Guardian.Token.claims()}}
              | {:error, any()}

  @callback refresh_cb(Guardian.Token.token(), List) ::
              {:ok, {Guardian.Token.token(), Guardian.Token.claims()},
               {Guardian.Token.token(), Guardian.Token.claims()}}
              | {:error, any()}

  defmacro __using__(_opts) do
    quote do
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

          "refresh" ->
            Logger.debug("---  #{__MODULE__} claimes[type] == refresh --------------")

          _ ->
            raise BusinessError, message: @msg_err_invalid_token
        end

        with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
          {:ok, claims}
        end
      end

      def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
        Logger.debug("---  #{__MODULE__} on_refresh --------------")

        # with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
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

      def on_refresh({old_token, old_claims}, {new_token, new_claims}) do
        Guardian.DB.on_revoke(old_claims, old_token)
        Guardian.DB.after_encode_and_sign(%{}, new_claims["typ"], new_claims, new_token)

        {:ok, {old_token, old_claims}, {new_token, new_claims}}
      end

      def get_user_registration_token(email) do
        config = get_config()
        user_registration_token_ttl = config[:user_registration_token_ttl]

        Logger.debug(
          "#{__MODULE__} --- get_user_registration_token user_registration_token_ttl:#{
            inspect(user_registration_token_ttl)
          }"
        )

        if user_registration_token_ttl == nil do
          raise BusinessError, message: "materia.Authenticator user_registration_token_ttl config not found."
        end

        get_custom_token(email, "user_registration", user_registration_token_ttl)
      end

      def get_password_reset_token(email) do
        Logger.debug("#{__MODULE__} get_password_reset_token -------")
        config = get_config()
        password_reset_token_ttl = config[:password_reset_token_ttl]

        Logger.debug(
          "#{__MODULE__} --- get_password_reset_token password_reset_token_ttl:#{inspect(password_reset_token_ttl)}"
        )

        if password_reset_token_ttl == nil do
          raise BusinessError, message: "materia.Authenticator password_reset_token_ttl config not found."
        end

        get_custom_token(email, "password_reset", password_reset_token_ttl)
      end

      def get_user_id_from_claims(claims) do
        Logger.debug("#{__MODULE__} get_user_id_from_claims -------")

        _user_id =
          try do
            sub = claims["sub"]
            {:ok, sub} = Poison.decode(sub)
            user_id = sub["user_id"]
          rescue
            _e in KeyError ->
              Logger.debug("#{__MODULE__} conn.private.guardian_default_claims is not found. anonymus operation!")

              raise BusinessError,
                message:
                  "conn.private.guardian_default_claims is not found. anonymus operation!\rthis endpoint need Materia.UserAuthPipeline. check your app's router.ex"
          end
      end

      @doc false
      def get_custom_token(email, token_type, token_ttl) do
        Logger.debug("#{__MODULE__} get_custom_token -------")
        claims = %{"email" => email}
        Logger.debug("#{__MODULE__} --- get_custom_token start. claims:#{inspect(claims)}")

        with {:ok, nil} <- resource_from_claims(claims) do
          {:error, "user not found by claims"}
        else
          {:ok, resource} ->
            # Materia.AuthenticatorBase.encode_and_sign_cb(
            with {:ok, user_registration_token, _user_claims} <-
                   encode_and_sign_cb(
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

      def refresh_tokens(refresh_token) do
        Logger.debug("#{__MODULE__} refresh_tokens -------")
        config = get_config()
        access_token_ttl = config[:access_token_ttl]
        Logger.debug("#{__MODULE__} --- refresh_tokens access_token_ttl:#{inspect(access_token_ttl)}")

        if access_token_ttl == nil do
          raise BusinessError, message: "materia.Authenticator access_token_ttl config not found."
        end

        # Materia.AuthenticatorBase.exchange_cb(refresh_token, "refresh", "access", ttl: access_token_ttl) do
        with {:ok, _refresh, new_access} <- exchange_cb(refresh_token, "refresh", "access", ttl: access_token_ttl) do
          {token, claims} = new_access
          Logger.debug("#{__MODULE__} --- refresh_tokens new_access_token:#{inspect(token)}")

          with {:ok, _} <- Guardian.DB.after_encode_and_sign(%{}, "access", claims, token) do
            refresh_token_ttl = config[:refresh_token_ttl]

            Logger.debug("#{__MODULE__} --- refresh_tokens refresh_token_ttl:#{inspect(refresh_token_ttl)}")

            if refresh_token_ttl == nil do
              raise BusinessError, message: "materia.Authenticator refresh_token_ttl config not found."
            end

            with {:ok, _old_refresh, new_refresh} <- refresh_cb(refresh_token, ttl: refresh_token_ttl) do
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

      def get_config() do
        Logger.debug("#{__MODULE__} get_config -------")
        config = Application.get_env(:materia, Materia.Authenticator)

        if config == nil do
          raise BusinessError, message: "materia.Authenticator config not found."
        else
          config
        end
      end
    end
  end
end
