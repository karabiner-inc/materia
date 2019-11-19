defmodule MateriaWeb.ControllerBase do
  alias Ecto.Multi
  alias Materia.Errors.BusinessError

  alias Materia.UserAuthenticator
  alias Materia.AccountAuthenticator

  require Logger

  def get_user_id(conn) do
    _user_id =
      try do
        clames = conn.private.guardian_default_claims
        UserAuthenticator.get_user_id_from_claims(clames)
      rescue
        _e in KeyError ->
          Logger.debug("#{__MODULE__} conn.private.guardian_default_claims is not found. anonymus operation!")

          raise BusinessError,
            message:
              "conn.private.guardian_default_claims is not found. anonymus operation!\rthis endpoint need Materia.UserAuthPipeline. check your app's router.ex"
      end
  end

  def get_account_id(conn) do
    _account_code =
      try do
        clames = conn.private.guardian_default_claims
        AccountAuthenticator.get_account_id_from_claims(clames)
      rescue
        _e in KeyError ->
          Logger.debug("#{__MODULE__} conn.private.guardian_default_claims is not found. anonymus operation!")

          raise BusinessError,
            message:
              "conn.private.guardian_default_claims is not found. anonymus operation!\rthis endpoint need Materia.AccountAuthPipeline. check your app's router.ex"
      end
  end

  def transaction_flow(conn, controler_atom, module, function_atom, attr \\ [%{}]) do
    repo = Application.get_env(:materia, :repo)

    try do
      with {:ok, result} <-
             Multi.new()
             |> Multi.run(function_atom, module, function_atom, attr)
             |> repo.transaction() do
        result_map = Map.new([{controler_atom, result[function_atom]}])

        conn
        |> Plug.Conn.put_status(:created)
        |> Phoenix.Controller.render("show.json", result_map)
      else
        {:error, reason} ->
          Logger.debug("#{__MODULE__} transaction_flow. Ecto.Multi transaction was failed. #{inspect(reason)}")

          raise BusinessError,
            message: "Ecto.Multi transaction was failed. module:#{inspect(module)} function:#{function_atom}"
      end
    rescue
      e ->
        Logger.debug("#{__MODULE__} transaction_flow. exception occured.")
        e
    end
  end
end
