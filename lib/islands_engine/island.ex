defmodule IslandsEngine.Island do
  @moduledoc """
  Provides a set of functions to work with islands.
  """

  alias IslandsEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  @type t :: %Island{coordinates: MapSet.t(), hit_coordinates: MapSet.t()}

  @doc """
  Creates a new island of the given type starting from the given `IslandsEngine.Coordinate`.

  ## Examples:

      {:ok, coordinate} = Coordinate.new(1, 1)
      {:ok, island} = new(:square, coordinate)

  Here's the full list of island types:
      new(:square, coordinate)
      new(:atoll, coordinate)
      new(:dot, coordinate)
      new(:l_shape, coordinate)
      new(:s_shape, coordinate)

  Returns an error tuple in case of an invalid type of island:

      new(:invalid, coordinate)
      {:error, :invalid_island_type}
  """

  @spec new(atom(), Coordinate.t()) :: tuple()
  def new(type, %Coordinate{} = upper_left) do
    with [_ | _] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  def overlaps?(existing_island, new_island),
    do: not MapSet.disjoint?(existing_island.coordinates, new_island.coordinates)

  def guess(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}

      false ->
        :miss
    end
  end

  def forested?(island), do: MapSet.equal?(island.coordinates, island.hit_coordinates)

  def types, do: [:atoll, :dot, :l_shape, :s_shape, :square]

  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offsets(:dot), do: [{0, 0}]
  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  defp offsets(_), do: {:error, :invalid_island_type}

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} ->
        {:cont, MapSet.put(coordinates, coordinate)}

      {:error, :invalid_coordinate} ->
        {:halt, {:error, :invalid_coordinate}}
    end
  end
end
