defmodule Materia.Repo.Migrations.CreateConnLogs do
  use Ecto.Migration

  def change do
    create table(:conn_logs) do
      add :user_id, :bigint
      add :remote_ip, :string
      add :user_agent, :string
      add :owner_pid, :string
      add :req_headers, :string, size: 3000
      add :req_method, :string
      add :req_path, :string, size: 3000
      add :req_path_params, :string, size: 3000
      add :req_body_params, :string, size: 10000
      add :assigns, :string, size: 3000

      timestamps()
    end

    create index(:conn_logs, [:user_id, :inserted_at])
    create index(:conn_logs, [:inserted_at, :user_id])
    create index(:conn_logs, [:remote_ip, :user_id, :inserted_at])
    create index(:conn_logs, [:req_path, :user_id, :inserted_at])

  end
end
