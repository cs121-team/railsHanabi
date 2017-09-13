class Game < ApplicationRecord
  def initialize()
    @center_deck = []
    @remaining_deck = []
    suites = %w[ A B C D E ]
    ranks = %i[ 1 1 1 2 2 3 3 4 4 5 ]
    suites.each do |suite|
      ranks.each do |rank|
        @remaining_deck << Card.new(rank, suite)
      end
    end
  end
end


class Card
  def initialize(rank, suite)
    @rank = rank
    @suite = suite
  end
end
