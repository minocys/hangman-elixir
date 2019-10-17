defmodule TextClient.State do
  alias Hangman.Game

  defstruct(
    game_service: nil,
    tally: nil,
    guess: ""
  )

  def update(tally, game) do
    %{game | tally: tally }
  end
end
