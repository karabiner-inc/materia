defmodule Materia.Repo.Migrations.CreateClientLogs do
  use Ecto.Migration

  def change do
    create table(:client_logs) do
      add(:log_datetime, :utc_datetime)
      add(:user_id, :bigint)
      add(:client_ip, :string)
      add(:user_agent, :string)
      add(:routing_path, :string, size: 3000)
      add(:evidence_url, :string, size: 3000)
      add(:trace_log, :text)

      timestamps()
    end

    create(index(:client_logs, [:log_datetime, :user_id]))
    create(index(:client_logs, [:routing_path, :log_datetime, :user_id]))
    create(index(:client_logs, [:user_id, :log_datetime, :routing_path]))
  end
end
