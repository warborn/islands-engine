defmodule IslandsEngine.GameSpec do
  @moduledoc false

  use ESpec, async: true
  doctest IslandsEngine.Game

  alias IslandsEngine.Game

  before do
    {:ok, game} = Game.start_link("player1")

    {:ok, game: game}
  end

  describe "Adding a second player" do
    context "when there is only one player" do
      it "should add the second player to the game" do
        player_name = "player2"
        :ok = Game.add_player(shared.game, player_name)

        expect get_state(shared.game) |> Map.get(:player2) |> to(have name: player_name)
      end
    end

    context "when there are two players already" do
      it "should return an error" do
        :ok = Game.add_player(shared.game, "player2")

        expect Game.add_player(shared.game, "player3") |> to(eq :error)
      end
    end
  end

  defp get_state(process), do: :sys.get_state(process)
end
