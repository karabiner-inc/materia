defmodule Mix.Tasks.Materia.Gen.Migration do
  @shortdoc "Generates Materia's migration files."

  use Mix.Task

  import Mix.Generator
  import Mix.Tasks.Guardian.Db.Gen.Migration

  @migrations_file_path "priv/repo/migrations"
  @migration_module_path "deps/materia/lib/mix/templates"

  @doc false
  def run(args) do

    migration_module_path =
    if length(args) >= 1 do
      List.first(args)
    else
      @migration_module_path
    end

    app_module = Mix.Project.config[:app] |> Atom.to_string() |> Macro.camelize()
    assigns = [app_module: app_module]

    {:ok, file_names} = File.ls(migration_module_path)
    file_names
    |> Enum.sort()
    |> Enum.with_index()
    |> Enum.each(fn{file_name, index} ->
      {:ok, file} = File.read(migration_module_path <> "/" <> file_name)
      create_file(
      Path.join([@migrations_file_path, "#{timestamp(index)}_materia_#{file_name}"])
        |> Path.relative_to(Mix.Project.app_path),
      file)
    end)
  end

  defp timestamp(add_sec) do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss , add_sec )}"
  end

  defp pad(i,j \\ 0)
  defp pad(i,j) when i < 10, do: <<?0, ?0 + ( i + j ) >>
  defp pad(i,j), do: to_string(i + j)

end
