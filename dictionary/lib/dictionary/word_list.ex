defmodule Dictionary.WordList do

  @key __MODULE__

  def start_link() do
    Agent.start_link(&read_list/0, name: @key)
  end

  def random_word() do 
    Agent.get(@key, &Enum.random/1)
  end

  defp read_list() do
    "../../assets/words.txt"
      |> Path.expand(__DIR__)
      |> File.read!()
      |> String.split(~r/\n/)
  end
end
