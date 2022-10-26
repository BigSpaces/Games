defmodule Games.Wordle do
  def feedback(answer, guess) do
    answer_list = String.split(answer, "", trim: true)
    guess_list = String.split(guess, "", trim: true)

    zipped_list = Enum.zip(answer_list, guess_list)

#First we green the grens
    greened_list =
      Enum.map(zipped_list, fn {answer_element, guess_element} ->
        if answer_element == guess_element do
          {nil, :green}
        else
          {answer_element, guess_element}
        end
      end)

    remained_chars =
      Enum.reduce(greened_list, "", fn {answer_elem, _}, acc ->
        if is_binary(answer_elem) do
          acc <> answer_elem
        else
          acc
        end
      end)

    greyed_list =
      Enum.map(greened_list, fn {answer_elem, guess_elem} ->
        if is_binary(guess_elem) do
          if String.contains?(remained_chars, guess_elem) do
            {answer_elem, guess_elem}
          else
            {answer_elem, :grey}
          end
        else
          {answer_elem, guess_elem}
        end
      end)

    {answer, guess} = Enum.unzip(greyed_list)
    yellow_me(answer, guess)
  end

  def yellow_me(answer, guess) do
    if Enum.all?(guess, fn x -> is_atom(x) end) do
      guess
    else
      next_guess_index = Enum.find_index(guess, fn char -> is_binary(char) end)
      next_guess_char = Enum.at(guess, next_guess_index)
      next_answer_index = Enum.find_index(answer, fn char -> char == next_guess_char end)

      {answer, guess} =
        if next_answer_index do
          updated_answer = List.replace_at(answer, next_answer_index, nil)
          updated_guess = List.replace_at(guess, next_guess_index, :yellow)
          {updated_answer, updated_guess}
        else
          updated_guess = List.replace_at(guess, next_guess_index, :grey)
          {answer, updated_guess}
        end

      yellow_me(answer, guess)
    end
  end

  def won?(evaluation) do
    Enum.all?(evaluation, fn letter -> letter === :green end)
  end

  # @spec random_answer([binary | maybe_improper_list(any, binary | []) | char]) :: binary
  def random_answer(answer \\ []) do
    if length(answer) < 5 do
      answer = [Enum.random(97..122) | answer]
      random_answer(answer)
    else
      List.to_string(answer)
    end
  end

  def play(evaluation \\ [], answer \\ "", rounds \\ 0, won \\ false) do
    case rounds do
      0 ->
        answer = random_answer([])
        guess = IO.gets("Gimme a 5 letter word, please!\n")
        evaluation = feedback(answer, guess)
        IO.inspect("Your guess is: ")
        IO.inspect(evaluation)
        IO.inspect("So...")
        won = won?(evaluation)
        play(evaluation, answer, rounds + 1, won)

      n when n < 6 and won == false ->
        guess = IO.gets("...you have #{6 - rounds} rounds left. Do try!\n")
        evaluation = feedback(answer, guess)
        IO.inspect("Your guess is: ")
        IO.inspect(evaluation)
        IO.inspect("So...")
        won = won?(evaluation)
        play(evaluation, answer, rounds + 1, won)

      n when n < 6 and won == true ->
        IO.inspect("Wowza! That was something. You won at attempt number #{n}")

      6 ->
        "Sorry but... You are a loser, and you know it. Good news: unlike in Elixir, this is a mutable variable and you can play again"
    end
  end

  # if plays === 0 do
  #   answer = random_answer([])
  #   guess = IO.gets("Gimme a 5 letter word, mate!\n")
  #   plays = plays + 1
  #   feedback(answer, guess)
  #   play_starts(guess, answer, plays)
  # else
  #   guess = IO.gets("Ooops, mate, you have #{6 - plays} left. Do try!\n")
  #   plays = plays + 1
  #   feedback(answer, guess)
  #   play_starts(guess, answer, plays)

  # end
end

# Generate random word - DONE
# Get word from user - DONE
# Validate it a bit, I guess - TO BE DONE
# Launch the "feedback"
# Check if the answer is all greens
# If it is not, provide another chance to play and count +1
# Upon reaching 6 times, salute and go
