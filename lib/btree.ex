defmodule Btree do
  @moduledoc """
  Binary Tree Functions
  """
  alias Btree.Node

  @type bnode() :: Node.t()

  @doc """
  Returns a sorted tree structure from a list
  ## Examples

      iex> Btree.sort([43,12, 55, 19])
      %Node{
              value: 43,
              left: %Node{value: 12, right: %Node{value: 19}},
              right: %Node{value: 55}
           }
  """
  @spec sort(list()) :: bnode()
  def sort(values) do
    values
    |> Enum.reduce(%Node{}, fn value, acc ->
      insert(acc, value)
    end)
  end

  @doc """
  Search for a value in a binary tree 
  ## Examples

      iex> Btree.search(%Node{ value: 43, left: %Node{value: 12, right: %Node{value: 19}}, right: %Node{value: 55}},  19)
      %Node{value: 19}

  """
  def search(nil, _search_value), do: :not_found

  def search(%Node{value: value} = found_node, search_value) when value == search_value,
    do: found_node

  def search(%Node{value: value, left: left_node}, search_value)
      when value > search_value,
      do: search(left_node, search_value)

  def search(%Node{value: value, right: right_node}, search_value)
      when value < search_value,
      do: search(right_node, search_value)

  @doc """
  Inserts a new value into a tree preserving order
  ## Examples

      iex> Btree.insert(%Node{value: 5}, 3)
      %Node{value: 5, left: %Node{value: 3}}

  """
  @spec insert(bnode() | atom(), any()) :: bnode()
  def insert(%Node{value: value}, new_value) when is_nil(value),
    do: %Node{value: new_value}

  def insert(current_node, new_value) when is_nil(current_node),
    do: %Node{value: new_value}

  def insert(%Node{value: value, left: left_node} = current_node, new_value)
      when new_value <= value,
      do: %Node{current_node | left: insert(left_node, new_value)}

  def insert(%Node{value: value, right: right_node} = current_node, new_value)
      when new_value > value,
      do: %Node{current_node | right: insert(right_node, new_value)}

  @doc """
  Inverts a binary tree
      iex> Btree.invert(%Node{value: 2, left: %Btree.Node{value: 1}, right: %Btree.Node{value: 3}})
      %Node{
               value: 2,
               left: %Btree.Node{value: 3},
               right: %Btree.Node{value: 1}
             }
  """
  @spec invert(bnode()) :: bnode()
  def invert(tree) do
    do_invert(%Node{}, tree)
  end

  defp do_invert(
         %Node{},
         nil
       ),
       do: nil

  defp do_invert(
         %Node{} = result,
         %Node{value: value, left: left_node, right: right_node}
       ) do
    %Node{
      result
      | value: value,
        right: do_invert(result, left_node),
        left: do_invert(result, right_node)
    }
  end
end
