defmodule Domainatrex.TrieBuilder do
  @moduledoc false

  def build(suffixes) do
    Enum.reduce(suffixes, %{}, &put_suffix(&2, &1))
  end

  defp put_suffix(node, []) do
    Map.put(node, :_end, true)
  end

  defp put_suffix(node, [head | tail]) do
    child = Map.get(node, head, %{})
    Map.put(node, head, put_suffix(child, tail))
  end
end
