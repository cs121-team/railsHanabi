class Game < ApplicationRecord
  attr_accessor :center_deck, :remaining_deck, :players
  def initialize(user_names=%w[ Gavin Jasmine Nupur Oliva ])
    @user_names = user_names
    @center_deck = []
    @remaining_deck = []
    @players = []
    suites = %w[ A B C D E ]
    ranks = %i[ 1 1 1 2 2 3 3 4 4 5 ]
    suites.each do |suite|
      ranks.each do |rank|
        @remaining_deck << Card.new(rank, suite)
      end
    end
    @user_names.each do |user_name|
      @players<< Player.new(user_name)
    end
  end

  def distributeCards()
  end
end


class Card
  attr_accessor :rank, :suite
  def initialize(rank, suite)
    @rank = rank
    @suite = suite
  end
end

class Player
  attr_accessor :user_name, :cards
  def initialize(user_name)
    @user_name = user_name
    @cards = []
  end
end
