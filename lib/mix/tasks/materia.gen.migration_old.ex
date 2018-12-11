defmodule Mix.Tasks.Materia.Gen.MigrationOld do
  @shortdoc "Generates Materia's migration old"

  use Mix.Task

  import Mix.Generator
  import Mix.Tasks.Guardian.Db.Gen.Migration

  @migrations_file_path "priv/repo/migrations"

  @doc false
  def run(args) do

    app_module = Mix.Project.config[:app] |> Atom.to_string() |> Macro.camelize()
    assigns = [app_module: app_module]

  # create user migrations
  create_file(
    Path.join([@migrations_file_path, "#{timestamp(1)}_materia_craete_users.exs"]) |> Path.relative_to(Mix.Project.app_path),
    users_template(assigns))
  # create organizaion migrations
  {:ok, organizations_file} = File.read("lib/mix/templates/craete_organizations.exs")
  create_file(
    Path.join([@migrations_file_path, "#{timestamp(3)}_materia_craete_organizations.exs"]) |> Path.relative_to(Mix.Project.app_path),
    organizations_file)
  # create grant migrations
  create_file(
    Path.join([@migrations_file_path, "#{timestamp(2)}_materia_craete_grants.exs"]) |> Path.relative_to(Mix.Project.app_path),
    grants_template(assigns))

  # create address migrations
  create_file(
    Path.join([@migrations_file_path, "#{timestamp(3)}_materia_craete_address.exs"]) |> Path.relative_to(Mix.Project.app_path),
    address_template(assigns))

  # create mail_template migrations
  create_file(
    Path.join([@migrations_file_path, "#{timestamp(3)}_materia_craete_mail_templates.exs"]) |> Path.relative_to(Mix.Project.app_path),
    mail_templates_template(assigns))


  end

  defp timestamp(add_sec) do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss , add_sec )}"
  end

  defp pad(i,j \\ 0)
  defp pad(i,j) when i < 10, do: <<?0, ?0 + ( i + j ) >>
  defp pad(i,j), do: to_string(i + j)

  # template
  embed_template(:users, """
  defmodule <%= @app_module %>.Repo.Migrations.CreateUsers do
    use Ecto.Migration

    def change do
      create table(:users) do
        add :name, :string
        add :email, :string
        add :hashed_password, :string
        add :role, :string
        add :status, :integer
        add :back_ground_img_url, :string
        add :external_user_id, :string
        add :icon_img_url, :string
        add :one_line_message, :string
        add :descriptions, :string, size: 10000
        add :lock_version, :bigint

        timestamps()
      end

      create unique_index(:users, [:email])
      create index(:users, [:role, :status])
      create index(:users, [:name])
    end
  end
  """)

  embed_template(:grants, """
  defmodule <%= @app_module %>.Repo.Migrations.CreateGrants do
    use Ecto.Migration

    def change do
      create table(:grants) do
        add :role, :string
        add :method, :string
        add :request_path, :string

        timestamps()
      end

      create unique_index(:grants, [:role, :method, :request_path])
    end
  end
  """)

  embed_template(:mail_templates, """
  defmodule <%= @app_module %>.Repo.Migrations.CreateMailTemplates do
    use Ecto.Migration

    def change do
      create table(:mail_templates) do
        add :subject, :string
        add :body, :string, size: 10000
        add :status, :integer
        add :lock_version, :bigint

        timestamps()
      end

    end
    """)

  embed_template(:address, """
  defmodule <%= @app_module %>.Repo.Migrations.CreateAddresses do
    use Ecto.Migration

    def change do
      create table(:addresses) do
        add :location, :string
        add :zip_code, :string
        add :address1, :string
        add :address2, :string
        add :latitude, :decimal
        add :longitude, :decimal
        add :subject, :string
        add :user_id, references(:users, on_delete: :nothing)

        timestamps()
      end

      create index(:addresses, [:user_id, :subject])
    end

  end
  """)

  #embed_template(:organizations, organizations_file)

end
