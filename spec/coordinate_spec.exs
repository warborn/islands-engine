defmodule IslandsEngine.CoordinateSpec do
  use ESpec, async: true
  doctest IslandsEngine.Coordinate

  alias IslandsEngine.Coordinate

  describe "Creating a new coordinate" do
    context "with valid a row and column" do
      it "should return a Coordinate map" do
        expect Coordinate.new(1, 1) |> to(match_pattern({:ok, %Coordinate{}}))
      end
    end

    context "with invalid row and column " do
      it "should return an error" do
        expect Coordinate.new(11, 11) |> to(be_error_result())
      end
    end
  end
end
