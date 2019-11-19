defmodule Materia.Logs.ConnLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conn_logs" do
    field(:assigns, :string)
    field(:owner_pid, :string)
    field(:remote_ip, :string)
    field(:req_body_params, :string)
    field(:req_headers, :string)
    field(:req_method, :string)
    field(:req_path, :string)
    field(:req_path_params, :string)
    field(:user_agent, :string)
    field(:user_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(conn_log, attrs) do
    conn_log
    |> cast(attrs, [
      :user_id,
      :remote_ip,
      :user_agent,
      :owner_pid,
      :req_headers,
      :req_method,
      :req_path,
      :req_path_params,
      :req_body_params,
      :assigns
    ])
  end
end
