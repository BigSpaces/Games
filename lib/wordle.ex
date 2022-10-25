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

# The we grey the greys

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


# And then we... we... well... something. Hit a wall. Now, the answer is there, ends up buried in a list within a list within a list.

    {answer, guess} = Enum.unzip(greyed_list)
 
    yellow_me(answer, guess)

    end

  def yellow_me(answer, guess) do
    if Enum.all?(guess, fn x -> is_atom(x) end) do
      IO.inspect("Game is over")
      guess
    else
      Enum.map(guess, fn element ->
        if is_binary(element) do
          if Enum.member?(answer, element) do
            index1_to_update = Enum.find_index(answer, fn n -> n === element end) 
            index2_to_update = Enum.find_index(guess, fn n -> n === element end) 
            updated_answer = List.replace_at(answer, index1_to_update, nil)
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
