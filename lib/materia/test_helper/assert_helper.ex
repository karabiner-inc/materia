defmodule Materia.TestHelper.AssertHelper do
  use ExUnit.CaseTemplate

  # map中の指定した項目のみassertionを実施する
  # 時刻など変動する項目をassertion実施したくない場合用
  def assert_values(test_map, estimated_map) do
    Map.to_list(estimated_map)
    |> Enum.each(fn {k, v} ->
      result = Map.get(test_map, Atom.to_string(k))
      assert v == result
    end)
  end
end
