defmodule IslandsEngine.GameSpec do
  @moduledoc false

  use ESpec, async: true
  doctest IslandsEngine.Game

  alias IslandsEngine.{Game, Rules}

  before do
    {:ok, game} = Game.start_link("player1")

    {:ok, game: game}
  end

  describe "Adding a second player" do
    context "when there is only one player" do
      it "should add the second player to the game" do
        player_name = "player2"
        :ok = Game.add_player(shared.game, player_name)

        expect shared.game |> get_state() |> Map.get(:player2) |> to(have name: player_name)
      end
    end

    context "when there are two players already" do
      it "should return an error" do
        :ok = Game.add_player(shared.game, "player2")

        expect shared.game |> Game.add_player("player3") |> to(eq :error)
      end
    end
  end

  describe "Positioning an island" do
    context "of an invalid player" do
      it "should throw an error" do
        expect(fn -> Game.position_island(shared.game, :player3, :dot, 1, 1) end)
        |> to(raise_exception FunctionClauseError)
      end
    end

    context "when there's not a second player" do
      it "should return an error" do
        shared.game
        |> Game.position_island(:player1, :invalid, 1, 1)
        |> to(eq :error)
      end
    end

    context "with an invalid island type" do
      it "should return an :invalid_island_type error" do
        expect shared.game
               |> update_rules_state(:players_set)
               |> Game.position_island(:player1, :invalid, 1, 1)
               |> to(match_pattern {:error, :invalid_island_type})
      end
    end

    context "with an invalid coordinate" do
      it "should return an :invalid_coordinate error" do
        expect shared.game
               |> update_rules_state(:players_set)
               |> Game.position_island(:player1, :dot, 11, 1)
               |> to(match_pattern {:error, :invalid_coordinate})
      end
    end

    context "with an island that overlaps another" do
      it "should return an :overlapping_island error" do
        shared.game
        |> update_rules_state(:players_set)
        |> Game.position_island(:player1, :dot, 1, 1)

        expect shared.game
               |> Game.position_island(:player1, :square, 1, 1)
               |> to(match_pattern {:error, :overlapping_island})
      end
    end

    context "with valid data" do
      it "should position the island on the board" do
        shared.game
        |> update_rules_state(:players_set)
        |> Game.position_island(:player1, :dot, 1, 1)

        expect shared.game |> get_state() |> get_in([:player1, :board]) |> to(have_key :dot)
      end
    end
  end

  defp get_state(process), do: :sys.get_state(process)

  defp update_rules_state(game, rules_new_state) do
    :sys.replace_state(game, fn state ->
      %{state | rules: %Rules{state: rules_new_state}}
    end)

    game
  end
end
