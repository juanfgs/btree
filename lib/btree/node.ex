defmodule Btree.Node do
  @moduledoc """
  Defines a binary tree node
  """
  alias Btree
  @type t() :: Btree.Node
  defstruct [:value, left: nil, right: nil]
end

defimpl Collectable, for: Btree.Node do
  def into(node) do
    collector_fun = fn
      node_acc, {:cont, value} ->
        Btree.insert(node_acc, value)

      node_acc, :done ->
        node_acc

      _node_acc, :halt ->
        :ok
    end

    initial_acc = node
    {initial_acc, collector_fun}
  end
end
