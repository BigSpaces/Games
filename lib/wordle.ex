defmodule Games.Wordle do

  @doc """

  This is the main entry point to the wordle module

  The algorithm to solve Wordle is

  Both guess and answer are converted into lists of characters
  On a first pass, we locate the characters that are equal and in the same position (GREENS).
  On a second pass, we process those characters from the guess that are not in the answer (GREYS)
  On a third pass, characters that remain in the guess are bound to be found in the answer. Those are YELLOW.

  First pass - Green the greens: Both guess and answer are converted into lists.
  In the guess list, the characters that match the answer are marked :green.
  The corresponding characters in the answer are marked nil, which will signal that have already been checked and processed.

  Second pass - Grey the greys: each character in the guess list is checked against the remaining active characters in the answer.
  Characters that are not found in the answer are marked :grey in the guess list.

  Third pass - Characters that remain in the guess list are bound to be yellow at least once.
  They are processed one by one, marked :yellow in the guess list, and nil in the answer list.
  When a character from the guess list is no longer found in the answer list, it is marked :grey


  Split both strings into lists (answer & guess)
  Both lists are zipped together in order to process them later through Enum.map()
  A new list (greened_list) is created in Enum.map. Should the elements in the guess list and the answer list be the same ({elem, elem})
  a tuple {nil, :green} is returned as part of the zipped list. Otherwise the characters remain the same.

  )

  """

  @spec feedback(binary, binary) :: list()
  def feedback(answer, guess) do
    answer_list = String.split(answer, "", trim: true)
    guess_list = String.split(guess, "", trim: true)

    zipped_list = Enum.zip(answer_list, guess_list)


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
