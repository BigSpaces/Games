defmodule Games.GuessingGame do
  def start(ai_number \\ nil) do
    # ai_number =
    #   if ai_number do
    #     ai_number
    #   else
    #      Enum.random(1..10)
    #   end
    ai_number = ai_number || Enum.random(1..10)

    user_guess = IO.gets("Tell me your guess: ") |> String.trim() |> String.to_integer()
    IO.puts(ai_number)

    cond do
      user_guess == ai_number ->
        "You did it! Correct"

      user_guess > ai_number ->
        IO.puts("Shooting too high")
        Games.GuessingGame.start(ai_number)

      user_guess < ai_number ->
        IO.puts("Not dreaming high enough")
        Games.GuessingGame.start(ai_number)
    end
  end
end
