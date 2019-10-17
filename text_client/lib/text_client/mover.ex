defmodule TextClient.Mover do
  alias TextClient.State

  def move(game = %State{}) do
    Hangman.make_move(game.game_service, game.guess)
      |> State.update(game)
  end
end
