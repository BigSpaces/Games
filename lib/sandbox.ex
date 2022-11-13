# defmodule Tests do
#   def play do
#     answer_list = ["a", "b", "c", "d", "e"]
#     guess_list = ["a", "x", "e", "b", "a"]

#     greens(answer_list, guess_list)
#     |> greys()
#   end

#   def greens(answer_list, guess_list) do
#     zipped_list = Enum.zip(answer_list, guess_list)

#     greened_list =
#       Enum.map(zipped_list, fn
#         {elem, elem} -> {nil, :green}
#         elem -> elem
#       end)
#   end

#   def greys(zipped_list) do
#     {answer_list, guess_list} = Enum.unzip(zipped_list)

#     updated_guess_list =
#       Enum.map(guess_list, fn char ->
#         if Enum.any?(answer_list, char), do: :grey else char
#       end)

#     IO.inspect(answer_list, label: "answer")
#     IO.inspect(guess_list, label: "guess")
#     IO.inspect(updated_guess_list, label: "updated guess")
#   end


  ## ==================

  # remained_chars =
  #   Enum.reduce(greened_list, "", fn {answer_elem, _}, acc ->
  #     if is_binary(answer_elem) do
  #       acc <> answer_elem
  #     else
  #       acc
  #     end
  #   end)

  # greyed_list =
  #   Enum.map(greened_list, fn {answer_elem, guess_elem} ->
  #     if is_binary(guess_elem) do
  #       if String.contains?(remained_chars, guess_elem) do
  #         {answer_elem, guess_elem}
  #       else
  #         {answer_elem, :grey}
  #       end
  #     else
  #       {answer_elem, guess_elem}
  #     end
  #   end)
#end
