defmodule BtreeTest do
  alias Btree.Node
  use ExUnit.Case
  doctest Btree

  describe "Collectable" do
    test "it implements the protocol collectable" do
      values = [11, 3, 9, 15, 1, 5]
      tree = Enum.into(values, %Node{})

      assert tree == %Btree.Node{
               value: 11,
               left: %Btree.Node{
                 value: 3,
                 left: %Btree.Node{value: 1, left: nil, right: nil},
                 right: %Btree.Node{
                   value: 9,
                   left: %Btree.Node{value: 5, left: nil, right: nil},
                   right: nil
                 }
               },
               right: %Btree.Node{value: 15, left: nil, right: nil}
             }
    end

    test "it returns an empty node when collecting an empty list" do
      assert Enum.into([], %Node{}) == %Node{}
    end
  end

  describe "sort/1" do
    test "it returns a sorted tree from a list" do
      values = [11, 3, 9, 15, 1, 5]

      assert Btree.sort(values) == %Btree.Node{
               value: 11,
               left: %Btree.Node{
                 value: 3,
                 left: %Btree.Node{value: 1, left: nil, right: nil},
                 right: %Btree.Node{
                   value: 9,
                   left: %Btree.Node{value: 5, left: nil, right: nil},
                   right: nil
                 }
               },
               right: %Btree.Node{value: 15, left: nil, right: nil}
             }
    end
  end

  describe "insert/2" do
    test "inserts a new value in a node" do
      assert Btree.insert(%Node{value: nil}, 5) == %Node{value: 5}
    end

    test "inserts smaller values on left branch" do
      assert Btree.insert(%Node{value: 10}, 5) == %Node{value: 10, left: %Node{value: 5}}
    end

    test "inserts larger values on right branch" do
      assert Btree.insert(%Node{value: 10}, 15) == %Node{value: 10, right: %Node{value: 15}}
    end

    test "inserts both values on the corresponding branch" do
      initial_node = %Node{value: 10}

      assert initial_node
             |> Btree.insert(5)
             |> Btree.insert(15) == %Node{
               value: 10,
               right: %Node{value: 15},
               left: %Node{value: 5}
             }
    end

    test "traverses inserts new nodes on the branches" do
      initial_node = %Node{value: 10}

      assert initial_node
             |> Btree.insert(5)
             |> Btree.insert(15)
             |> Btree.insert(7) ==
               %Node{
                 value: 10,
                 right: %Node{value: 15},
                 left: %Node{value: 5, right: %Node{value: 7}}
               }
    end

    test "inserts duplicate values on the left branch" do
      assert Btree.insert(%Node{value: 10}, 10) == %Node{
               value: 10,
               left: %Node{value: 10}
             }
    end
  end

  describe "search/2" do
    test "it returns :not_found for an empty tree" do
      assert Btree.search(nil, 123) == :not_found
    end

    setup do
      tree = %Node{
        value: 43,
        left: %Node{value: 12, right: %Node{value: 19}},
        right: %Node{value: 55}
      }

      {:ok, tree: tree}
    end

    test "it finds a value and returns the node", %{tree: tree} do
      assert Btree.search(tree, 43) == %Node{
               value: 43,
               left: %Node{value: 12, right: %Node{value: 19}},
               right: %Node{value: 55}
             }
    end

    test "it returns :not_found if node is not found", %{tree: tree} do
      assert Btree.search(tree, 456) == :not_found
    end

    test "it returns :not_found when traversing the left branch", %{tree: tree} do
      assert Btree.search(tree, 1) == :not_found
    end

    test "it returns :not_found when traversing the right branch", %{tree: tree} do
      assert Btree.search(tree, 99) == :not_found
    end

    test "it traverses the tree to return the correct node", %{tree: tree} do
      assert Btree.search(tree, 19) == %Node{
               value: 19,
               left: nil,
               right: nil
             }
    end
  end

  describe "invert/1" do
    test "it returns nil for an empty tree" do
      assert Btree.invert(nil) == nil
    end

    test "it inverts a binary tree" do
      tree = %Btree.Node{
        value: 2,
        left: %Btree.Node{value: 1},
        right: %Btree.Node{value: 3}
      }

      assert Btree.invert(tree) == %Btree.Node{
               value: 2,
               left: %Btree.Node{value: 3},
               right: %Btree.Node{value: 1}
             }
    end

    test "it inverts a more complex structure" do
      tree = [4, 2, 7, 1, 3, 6, 9] |> Btree.sort()

      assert Btree.invert(tree) == %Btree.Node{
               value: 4,
               left: %Btree.Node{
                 value: 7,
                 left: %Btree.Node{value: 9, left: nil, right: nil},
                 right: %Btree.Node{value: 6, left: nil, right: nil}
               },
               right: %Btree.Node{
                 value: 2,
                 left: %Btree.Node{value: 3, left: nil, right: nil},
                 right: %Btree.Node{value: 1, left: nil, right: nil}
               }
             }
    end
  end
end
