defmodule Games.WordleTest do
  use ExUnit.Case
  doctest Games.Wordle
  alias Games.Wordle

  test "feedback :green" do
    assert true
  end

  @tag :benchmark
  test "feedback/2 benchmark" do
    Benchee.run(%{
      "test all yellow" => fn -> Games.Wordle.feedback("abcde", "cedba") end,
      "test all grey" => fn -> Games.Wordle.feedback("aaaaa", "tferg") end,
      "test all green" => fn -> Games.Wordle.feedback("aaaaa", "aaaaa") end,
      "test 5 letters" => fn -> Games.Wordle.feedback("asdrf", "safwf") end,
      "test 1 letters" => fn -> Games.Wordle.feedback("a", "f") end,
      "test 30 letters" => fn ->
        Games.Wordle.feedback(
          "azswedfrtgsdfdfsdfyujkiyhtygfdeddessfasdfadfadfddf",
          "azswedfrtgsdfdygfdeddessfasfsdfyujkiyhtyhtdfadfadf"
        )
      end
    })
  end
end
