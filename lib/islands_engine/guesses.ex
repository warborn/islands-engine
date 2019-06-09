defmodule IslandsEngine.Guesses do
  @moduledoc """
  Provides a set of functions manage the hits and misses of coordinates in the game.
  """

  alias IslandsEngine.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @type guesses :: %Guesses{hits: MapSet.t(), misses: MapSet.t()}

  @doc ~S"""
  Creates a new `IslandsEngine.Guesses` map with a key of `hits` and `misses` implemented as a `MapSet`.

  ## Examples:

      new()
      %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  """

  @spec new() :: guesses()
  def new, do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  @doc """
  Add a new coordinate as a **hit** or a **miss**.

  ## Examples:

      add(guesses, :hit, coordinate)
      add(guesses, :miss, coordinate)

  """

  @spec add(guesses(), atom(), Coordinate.t()) :: guesses()
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate),
    do: update_in(guesses.hits, &MapSet.put(&1, coordinate))

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate),
    do: update_in(guesses.misses, &MapSet.put(&1, coordinate))
end
