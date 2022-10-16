defmodule Games.RockPaperScissors do
  @winning_choices [{"rock", "scissors"}, {"scissors", "paper"}, {"paper", "rock"}]



      def get_choice do
        "Scissors"
        # user_choice = IO.gets("Type Rock, Paper, or Scissors:")
      end

      def generate_choice do
        Enum.random(["rock, paper, scissors"])
      end

      def decide_winner(user_choice, computer_choice)
          when user_choice == computer_choice do
        "Tie, suit and tie"
      end

      def decide_winner(user_choice, computer_choice)
          when {user_choice, computer_choice} in @winning_choices do
        "Player wins since #{user_choice} beats #{computer_choice}"
      end

      def decide_winner(user_choice, computer_choice) do
          "Computer wins since #{computer_choice} beats #{user_choice}"
      end

    end
gi
