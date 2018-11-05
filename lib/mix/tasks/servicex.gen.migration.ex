defmodule Mix.Tasks.Servicex.Gen.Migration do
  @shortdoc "Generates Servicex's migration"

  use Mix.Task

  import Mix.Generator
  import Mix.Tasks.Guardian.Db.Gen.Migration

  @migrations_file_path "priv/repo/migrations"

  @doc false
  def run(args) do


    Mix.Tasks.Guardian.Db.Gen.Migration.run([])

    app_module = Mix.Project.config[:app] |> Atom.to_string() |> Macro.camelize()
    assigns = [app_module: app_module]

    # create user migrations
    create_file(
      Path.join([@migrations_file_path, "#{timestamp(1)}_servicex_craete_user.exs"]) |> Path.relative_to(Mix.Project.app_path),
      user_template(assigns))
    # create grant migrations
    create_file(
      Path.join([@migrations_file_path, "#{timestamp(2)}_servicex_craete_grant.exs"]) |> Path.relative_to(Mix.Project.app_path),
      grant_template(assigns))
    # create address migrations
    create_file(
      Path.join([@migrations_file_path, "#{timestamp(3)}_servicex_craete_address.exs"]) |> Path.relative_to(Mix.Project.app_path),
      address_template(assigns))

  end

  defp timestamp(add_sec) do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss , add_sec )}"
  end

  defp pad(i,j \\ 0)
  defp pad(i,j) when i < 10, do: <<?0, ?0 + ( i + j ) >>
  defp pad(i,j), do: to_string(i + j)

  # template
  embed_template(:user, """
  defmodule <%= @app_module %>.Repo.Migrations.CreateUsers do
    use Ecto.Migration

    def change do
      create table(:users) do
        add :name, :string
        add :email, :string
        add :hashed_password, :string
        add :role, :string
        add :status, :integer

        timestamps()
      end

      create unique_index(:users, [:email])
    end
  end
  """)

  embed_template(:grant, """
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

  embed_template(:address, """
  defmodule <%= @app_module %>.Repo.Migrations.CreateAddresses do
    use Ecto.Migration
  
    def change do
      create table(:addresses) do
        add :location, :string
        add :zip_code, :string
        add :address1, :string
        add :address2, :string
        add :latitud, :decimal
        add :longitude, :decimal
        add :user_id, references(:users, on_delete: :nothing)
  
        timestamps()
      end
  
      create index(:addresses, [:user_id])
    end
  end
  """)

end
