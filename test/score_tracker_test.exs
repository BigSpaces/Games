defmodule Games.ScoreTrackerTest do
  use ExUnit.Case
  alias Games.ScoreTracker

  describe "ScoreTracker.start_link/1" do
    test "starting the server" do
      {:ok, pid} = ScoreTracker.start_link([])
    end
  end

  describe "ScoreTracker.score/2 and ScoreTracker.get_score/2" do
    test "adding scores" do
      {:ok, pid} = ScoreTracker.start_link([])
      Games.ScoreTracker.score(pid, 10)
      10 = Games.ScoreTracker.get_score(pid)
    end

    test "adding multiple scores" do
      {:ok, pid} = ScoreTracker.start_link([])
      Games.ScoreTracker.score(pid, 10)
      10 = Games.ScoreTracker.get_score(pid)
      Games.ScoreTracker.score(pid, 20)
      30 = Games.ScoreTracker.get_score(pid)
    end
  end


end
