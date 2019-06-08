defmodule IslandsEngine.Guesses do
  @moduledoc """
  Provides a set of functions to hold the list of guessed and missed coordinates
  """

  alias IslandsEngine.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @spec new() :: %Guesses{hits: MapSet.t(), misses: MapSet.t()}
  def new, do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  @spec add(%Guesses{}, atom(), %Coordinate{}) :: %Guesses{}
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate),
    do: update_in(guesses.hits, &MapSet.put(&1, coordinate))

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate),
    do: update_in(guesses.misses, &MapSet.put(&1, coordinate))
end
