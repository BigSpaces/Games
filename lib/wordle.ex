defmodule Games.Wordle do
  def feedback(answer, guess) do
    answer_list = String.split(answer, "", trim: true)
    guess_list = String.split(guess, "", trim: true)

    zipped_list = Enum.zip(answer_list, guess_list)

    greened_list =
      Enum.map(zipped_list, fn {answer_element, guess_element} ->
        if answer_element == guess_element do
          {nil, :green}
        else
          {answer_element, guess_element}
        end
      end)

    IO.inspect("This is the greens: ")
    IO.inspect(greened_list)

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

    IO.inspect("This is the greys: ")
    IO.inspect(greyed_list)

    {answer, guess} = Enum.unzip(greyed_list)
    IO.inspect("This is the answer: ")
    IO.inspect(answer)

    IO.inspect("This is the guess: ")
    IO.inspect(guess)
    yellow_me(answer, guess)

    # item = "a"
    # item in list1
    # index1_to_update = Enum.find_index(list1, fn n -> n === item end)
    # index2_to_update = Enum.find_index(list2, fn n -> n === item end)
    # new_list1 = List.replace_at(list1, index1_to_update, nil)
    # new_list2 = List.replace_at(list2, index2_to_update, :yellow)

    # IO.inspect(list1)
    # IO.inspect(list2)

    # item = "b"
    # item in new_list1 |> IO.inspect()
    # IO.inspect(item)
    # index1_to_update = Enum.find_index(new_list1, fn n -> n === item end)  |> IO.inspect()
    # index2_to_update = Enum.find_index(new_list2, fn n -> n === item end)   |> IO.inspect()
    # List.replace_at(new_list1, index1_to_update, nil) |> IO.inspect()
    # List.replace_at(new_list2, index2_to_update, :yellow)
  end

  def yellow_me(answer, guess) do
    if Enum.all?(guess, fn x -> is_atom(x) end) do
      IO.inspect("Game is over")
      guess
    else
      Enum.map(guess, fn element ->
        if is_binary(element) do
          if Enum.member?(answer, element) do
            index1_to_update = Enum.find_index(answer, fn n -> n === element end) |> IO.inspect()
            index2_to_update = Enum.find_index(guess, fn n -> n === element end) |> IO.inspect()
            updated_answer = List.replace_at(answer, index1_to_update, nil)
            IO.inspect("this is the updated answer: ")
            IO.inspect(updated_answer)
            updated_guess = List.replace_at(guess, index2_to_update, :yellow)
            yellow_me(updated_answer, updated_guess)
          else
            index2_to_update = Enum.find_index(guess, fn n -> n === element end)
            updated_guess = List.replace_at(guess, index2_to_update, :grey)
            yellow_me(answer, updated_guess)
          end
        end
      end)
    end
  end
end
