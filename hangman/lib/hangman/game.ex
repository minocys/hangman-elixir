defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )
  
  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints
    }
  end
  def new_game() do
    new_game(Dictionary.random_word)
  end

  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do 
    return_game(game)
  end
  def make_move(game, guess) do
    if valid_guess?(guess) do 
      return_game(
        accept_move(game, guess, MapSet.member?(game.used, guess))
      )
    else
      return_game(game)
    end
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_guessed(game.used)
    }
  end 

  defp return_game(game) do
    { game, tally(game) }
  end

  defp valid_guess?(guess) when is_binary(guess) do
    guess =~ ~r/[a-z]/
  end
  defp valid_guess?(_), do: false

  defp accept_move(game, _guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end
  defp accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
      |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _guessed = true) do
    state = MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> check_win
    Map.put(game, :game_state, state)
  end
  defp score_guess(game = %{ turns_left: turns_left }, _guessed) do 
    state = check_lose(turns_left == 1)
    Map.put(game, :turns_left, turns_left - 1)
      |> Map.put(:game_state, state)
  end

  defp check_win(_won = true), do: :won
  defp check_win(_), do: :good_guess

  defp check_lose(_lose = true), do: :lost
  defp check_lose(_), do: :bad_guess

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_letter, _in_word), do: "_"

end
