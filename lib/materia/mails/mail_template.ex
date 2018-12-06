defmodule Materia.Mails.MailTemplate do
  use Ecto.Schema
  import Ecto.Changeset


  schema "mail_templates" do
    field :body, :string
    field :lock_version, :integer, default: 1
    field :status, :integer, default: 1
    field :subject, :string
    field :mail_template_type, :string

    timestamps()
  end

  @doc false
  def changeset_create(mail_template, attrs) do
    mail_template
    |> cast(attrs, [:mail_template_type, :subject, :body, :status, :lock_version])
    |> validate_required([:mail_template_type, :subject, :body])
  end

  @doc false
  def changeset_update(mail_template, attrs) do
    mail_template
    |> cast(attrs, [:mail_template_type, :subject, :body, :status, :lock_version])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end

  def status() do
    %{
      active: 1, # 有効
      inactive: 2, # 無効
    }
  end
end
