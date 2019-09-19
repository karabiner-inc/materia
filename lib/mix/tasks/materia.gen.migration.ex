defmodule Mix.Tasks.Materia.Gen.Migration do
  @shortdoc "Generates Materia's migration files."

  use Mix.Task

  import Mix.Generator
  import Mix.Tasks.Guardian.Db.Gen.Migration

  @migrations_file_path "priv/repo/migrations"
  @migration_module_path "deps/materia/lib/mix/templates"

  @doc false
  def run(args) do
    args
    |> setting_migration_module_path(@migration_module_path)
    |> create_migration_files(@migrations_file_path, "materia")
  end

  defp timestamp(index) do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    index = index
            |> to_string()
            |> String.pad_leading(3, "0")
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}#{index}"
  end

  defp pad(i,j \\ 0)
  defp pad(i,j) when i < 10, do: <<?0, ?0 + ( i + j ) >>
  defp pad(i,j), do: to_string(i + j)

  @doc false
  def setting_migration_module_path(args, migration_module_path) do
    if length(args) >= 1 do
      List.first(args)
    else
      migration_module_path
    end
  end

  @doc false
  def create_migration_files(migration_module_path, migrations_file_path, materia_prefix) do
    app_module = Mix.Project.config[:app]
                 |> Atom.to_string()
                 |> Macro.camelize()
    assigns = [app_module: app_module]
    {:ok, file_names} = File.ls(migration_module_path)
    file_names
    |> Enum.sort()
    |> Enum.with_index()
    |> Enum.each(
         fn {file_name, index} ->
           {:ok, file} = File.read(migration_module_path <> "/" <> file_name)
           create_file(
             Path.join([migrations_file_path, "#{timestamp(index)}_#{materia_prefix}_#{file_name}"])
             |> Path.relative_to(Mix.Project.app_path),
             file
           )
         end
       )
  end
end
