defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns a struct" do 
    game = Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "each element is an ASCII character" do
    game = Game.new_game()

    Enum.each(game.letters, fn x ->
      assert x =~ ~r/[a-z]/
    end)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [ :won, :lost ] do
      game = Game.new_game()
             |> Map.put(:game_state, state)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    {game, _} = Game.new_game("wibble")
      |> Game.make_move("x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is already used" do
    {game, _} = Game.new_game("wibble")
      |> Game.make_move("x")
    assert game.game_state != :already_used
    {game, _} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    {game, _} = Game.new_game("wibble")
      |> Game.make_move("w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {game, _} = Game.make_move(game, "i")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a won game is recognized" do
    game = Game.new_game("wibble")
    Enum.reduce(
      [
        {"w", :good_guess},
        {"i", :good_guess},
        {"b", :good_guess},
        {"l", :good_guess},
        {"e", :won},
      ],
      game,
      fn {guess, state}, acc ->
        {acc, _} = Game.make_move(acc, guess)
        assert acc.game_state == state
        acc
      end
    )
  end

  test "bad guess is recognized" do
    {game, _} = Game.new_game("wibble")
           |> Game.make_move("x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    game = Game.new_game("wibble")
    Enum.reduce(
      [
        {"q", :bad_guess},
        {"j", :bad_guess},
        {"a", :bad_guess},
        {"s", :bad_guess},
        {"z", :bad_guess},
        {"x", :bad_guess},
        {"v", :lost},
      ],
      game,
      fn {guess, state}, acc ->
        {acc, _} = Game.make_move(acc, guess)
        assert acc.game_state == state
        acc
      end
    )
  end
  
  test "not a-z is recognized" do
    game = Game.new_game()
    assert {^game, _} = Game.make_move(game, "1")
    assert {^game, _} = Game.make_move(game, 1)
  end
end
