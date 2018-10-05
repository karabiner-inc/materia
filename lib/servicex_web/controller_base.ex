defmodule Servicex.ControllerBase do

  alias Ecto.Multi
  alias Servicex.Errors.ServicexError

  require Logger

  def get_user_id(conn) do
    _user_id =
      try do
        conn.private.guardian_default_claims["sub"]
      rescue
        _e in KeyError ->
          Logger.debug("#{__MODULE__} conn.private.guardian_default_claims[\"sub\"] is not found. anonymus operation!")
          raise ServicexError, message: "conn.private.guardian_default_claims[\"sub\"] is not found. anonymus operation!\rthis endpoint need Servicex.AuthenticatePipeline. check your app's router.ex"
      end
  end

  def transaction_flow(conn, controler_atom, module, function_atom, attr \\ [%{}]) do
    repo = Application.get_env(:servicex, :repo)

    try do
      with {:ok, result} <- Multi.new
      |> Multi.run(function_atom, module, function_atom, attr)
      |> repo.transaction() do
        result_map = Map.new([{controler_atom, result[function_atom]}])
        conn
        |> Plug.Conn.put_status(:created)
        |> Phoenix.Controller.render("show.json", result_map)
      else
        {:error, reason} ->
          Logger.debug("#{__MODULE__} transaction_flow. Ecto.Multi transaction was failed.")
          IO.inspect(reason)
      end
    rescue
      e -> e
    end
  end

end
