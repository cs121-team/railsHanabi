class Game < ApplicationRecord
  attr_accessor :center_deck, :remaining_deck, :players
  def initialize(user_names=%w[ Gavin Jasmine Nupur Olivia ])
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
      @players << Player.new(user_name)
    end
    distributeCards()
  end

  def distributeCards()
    players.each do |player|
      x = 0
      while x < 5
        index = rand(@remaining_deck.length)
        player.addCard(@remaining_deck[index])
        remaining_deck.delete_at(index)
        x += 1
      end

    end
  end
end


class Card
  attr_accessor :rank, :suite
  def initialize(rank, suite)
    @rank = rank
    @suite = suite
  end

  def to_s
    "#{@rank}#{@suite}"
  end
end

class Player
  attr_accessor :user_name, :cards
  def initialize(user_name)
    @user_name = user_name
    @cards = []
  end

  def addCard(card)
    @cards << card
  end

  def to_s
    cards_string = ""
    for card in @cards
      cards_string << "\t #{card} \n"
    end
    "Username: #{@user_name} \n" +
    "Cards: \n" + cards_string
  end
end
