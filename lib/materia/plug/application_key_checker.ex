defmodule Materia.Plug.ApplicationKeyChecker do
  @doc """

  check other application server request authenticate.

  application who request must contain app_key in request parameter or "Authentication" in http header.

  eg:
  ```
  GET {{url}}/app/is_valid_app?app_key=your_app_key
  ```
  or
  ```
  GET {{url}}/app/is_valid_app
  Authorization: your_app_key
  ```
  server who recive request must configure app_key in phoenix config file.

  eg:

  ```
  config :materia, Materia.Plug.ApplicationKeyChecker,
    app_key: "your_app_key"
  ```

  recomend you generate complex app_key by "mix phx.gen.secret" command.

  and add  pipline in router.ex

  eg:
  ```
  pipeline :application_auth do
    conf = Application.get_env(:materia, Materia.Plug.ApplicationKeyChecker)
    plug Materia.Plug.ApplicationKeyChecker, conf: conf
  end

  scope "/app", MateriaWeb do
    pipe_through :application_auth
    get "/your-endpoint", YourController, :your_function
  end

  ```


  """
  import Plug.Conn

  require Logger

  def init(opts) do
    Logger.debug("#{__MODULE__}--- init---------------------")
    opts
  end

  def call(conn, opts) do
    Logger.debug("#{__MODULE__}--- call ---------------------")

    app_key =
      if conn.params["app_key"] == nil do
        authorization =
          conn.req_headers
          |> Enum.find(fn {k, v} -> String.downcase(k) == "authorization" end)

        if authorization == nil do
          nil
        else
          {k, v} = authorization
          v
        end
      else
        conn.params["app_key"]
      end

    Logger.debug("#{__MODULE__}--- call opt:#{opts[:conf][:app_key]}")
    Logger.debug("#{__MODULE__}--- call request app_key:#{app_key}")

    if app_key != nil && app_key == opts[:conf][:app_key] do
      Logger.debug("#{__MODULE__}--- call app_key is valid ---------------------")
      # remove api_key in params
      removed_params =
        conn.params
        |> Map.delete("app_key")

      conn
      |> Map.put(:params, removed_params)
    else
      Logger.debug("#{__MODULE__}--- call app_key is invalid ---------------------")

      conn
      |> halt()
      |> send_resp(401, Poison.encode!(%{message: "invalid_token"}))
    end
  end
end
