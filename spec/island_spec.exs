defmodule IslandsEngine.IslandSpec do
  use ESpec, async: true
  doctest IslandsEngine.Island

  alias IslandsEngine.{Coordinate, Island}

  let_ok :coordinate, do: Coordinate.new(1, 1)

  describe "Creating a new island" do
    context "of a valid type" do
      it "should return an Island structure" do
        expect Island.new(:square, coordinate()) |> to(match_pattern {:ok, %Island{}})
      end
    end

    context "of an invalid type" do
      it "should return an error" do
        expect Island.new(:invalid, coordinate()) |> to(be_error_result())
      end
    end
  end
end
