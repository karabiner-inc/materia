defmodule MateriaWeb.HealthCheckController do
  @moduledoc """
  """
  use MateriaWeb, :controller

  alias MateriaUtils.Ecto.EctoUtil

  action_fallback(MateriaWeb.FallbackController)

  require Logger

  def health_check(conn, _params) do
    repo = Application.get_env(:materia, :repo)
    Logger.debug("#{__MODULE__} health_check. -----------------")

    try do
      [%{result: "OK"}] = EctoUtil.query(repo, "select 'OK' as result", [])
      Logger.debug("#{__MODULE__} health_check. health check ok")
      send_resp(conn, 200, "{\"message\":\"health_check_ok\"}")
    catch
      _, e ->
        Logger.error("#{__MODULE__} health_check. catch unexpected error.")
        Logger.info(inspect(e))
        IO.puts(Exception.format_stacktrace(System.stacktrace()))

        conn
        |> halt()
        |> send_resp(500, "{\"message\":\"health_check_ng\"}")
    end
  end
end
