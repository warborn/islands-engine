defmodule IslandsEngine.Coordinate do
  @moduledoc """
  Defines the structure of a coordinate in a board.
  """

  alias __MODULE__

  @board_range 1..10

  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @typedoc """
  Type that represents the `IslandsEngine.Coordinate` struct.
  """

  @type t :: %Coordinate{row: integer(), col: integer()}

  @doc ~S"""
  Creates a new `IslandsEngine.Coordinate` map instance based on the given row and column.

  ## Examples

      iex> IslandsEngine.Coordinate.new(1, 1)
      {:ok, %IslandsEngine.Coordinate{row: 1, col: 1}}

  Coordinates outside range are considered invalid.

      iex> IslandsEngine.Coordinate.new(11, 11)
      {:error, :invalid_coordinate}

  """

  @spec new(integer(), integer()) :: {:ok, Coordinate.t()} | {:error, atom()}
  def new(row, col) when row in @board_range and col in @board_range do
    {:ok, %Coordinate{row: row, col: col}}
  end

  def new(_row, _col) do
    {:error, :invalid_coordinate}
  end
end
