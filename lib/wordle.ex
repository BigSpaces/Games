defmodule Games.Wordle do
  @doc """

  This is the main entry point to the wordle module

  The algorithm to solve Wordle is

  (Turn these into sentences)
  First, green the greens
  Second, grey the greys
  Third, figure out the yellows
  The rest is grey
  And we are done

  (Summarise green the greens)
  Wordle consists on an answer as well as a guess. We convert those into lists that can be processed together
  "Green the greens" is a first pass of processing where we mark those characters of both lists that are the same
  as well as being in the same place (or index). In the "guess" list, we mark with the atom :green
  In the answer list, we mark the character as "processed" by replacing it with nil.


  (Step by step)
  * Split both strings into lists
  * Both lists are zipped together in order to process them
  * 2nd Check both lists against each other

  )

  """
  def feedback(answer, guess) do
    answer_list = String.split(answer, "", trim: true)
    guess_list = String.split(guess, "", trim: true)

    zipped_list = Enum.zip(answer_list, guess_list)

    # First we green the grens
    greened_list =
      Enum.map(zipped_list, fn
        {elem, elem} -> {nil, :green}
        elem -> elem
      end)

    # take it from here
    # {answer_list2, guess_list2} = Enum.unzip(greened_list)

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

  def play(answer \\ nil, rounds \\ 0) do
    answer = answer || random_answer([])

    message =
      if rounds == 0 do
        "Gimme a 5 letter word, please!\n"
      else
        "...you have #{6 - rounds} rounds left. Do try!\n"
      end

    guess = IO.gets(message)
    evaluation = feedback(answer, guess)
    won = won?(evaluation)

    case {rounds, won} do
      {_, true} ->
        IO.inspect("Wowza! That was something. You won at attempt number #{rounds}")

      {6, _} ->
        "Sorry but... You are a loser, and you know it. Good news: unlike in Elixir, this is a mutable variable and you can play again"

      {_, false} ->
        # IO.puts(IO.ANSI.green <> "YELLOW")
        IO.inspect("Your guess is: ")
        IO.inspect(evaluation)
        IO.inspect("So...")
        play(answer, rounds + 1)
    end
  end
end
