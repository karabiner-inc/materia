defmodule Materia.Logs.ClientLog do
  use Ecto.Schema
  import Ecto.Changeset


  schema "client_logs" do
    field :client_ip, :string
    field :evidence_url, :string
    field :log_datetime, :utc_datetime
    field :routing_path, :string
    field :trace_log, :string
    field :user_agent, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(client_log, attrs) do
    client_log
    |> cast(attrs, [:log_datetime, :user_id, :client_ip, :user_agent, :routing_path, :evidence_url, :trace_log])
  end
end
