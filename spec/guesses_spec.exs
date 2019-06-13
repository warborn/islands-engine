defmodule IslandsEngine.GuessesSpec do
  @moduledoc false

  use ESpec, async: true
  doctest IslandsEngine.Guesses

  alias IslandsEngine.{Coordinate, Guesses}

  describe "Creating a new Guesses structure" do
    it "should return a Guesses structure with hits and misses" do
      expect Guesses.new() |> to(be_struct Guesses)
    end
  end

  describe "Guessing a coordinate" do
    context "as a hit" do
      it "should add the coordinate to the set of hits" do
        {:ok, coordinate} = Coordinate.new(1, 1)

        expect Guesses.new()
               |> Guesses.add(:hit, coordinate)
               |> Map.get(:hits)
               |> to(have_count 1)
      end
    end

    context "as a miss" do
      it "should add the coordinate to the set of misses" do
        {:ok, coordinate} = Coordinate.new(1, 1)

        expect Guesses.new()
               |> Guesses.add(:miss, coordinate)
               |> Map.get(:misses)
               |> to(have_count 1)
      end
    end
  end
end
