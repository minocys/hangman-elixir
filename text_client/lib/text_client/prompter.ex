defmodule TextClient.Prompter do
  alias TextClient.State

  def accept_move(game = %State{}) do
    IO.gets("Your guess: ")
    |> check_input(game)
  end

  def check_input({:error, reason}, _game) do
    IO.puts("Game ended: #{reason}")
    exit(:normal)
  end
  def check_input(:eof, _game) do
    IO.puts("Game Over!")
    exit(:normal)
  end
  def check_input(input, game = %State{}) do
    input = String.trim(input)
    cond do
      input =~ ~r/\A[a-z]\z/ ->
        Map.put(game, :guess, input)
      true  ->
        IO.puts "please enter a single lowercase letter"
        accept_move(game)
    end
  end
end
