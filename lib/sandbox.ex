defmodule Tests do
 def same_args({arg1, arg1}), do: {nil, :green}
 def same_args({arg1, arg2}), do: {arg1, arg2}



  def greens do
    answer_list = ["a", "b", "c", "d", "e"]
    guess_list = ["a", "x", "e", "b", "a"]

    zipped_list = Enum.zip(answer_list, guess_list)

    greened_list =
        Enum.map(zipped_list, fn
        {elem, elem} -> {nil, :green}
        elem -> elem
      end)
  end
end
