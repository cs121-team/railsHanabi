class Game < ApplicationRecord
  attr_accessor :center_deck, :remaining_deck, :players
  def initialize(user_names=%w[ Gavin Jasmine Nupur Olivia ])
    @user_names = user_names
    @center_deck = []
    @remaining_deck = []
    @players = []
    @hint_counter = 8
    @bomb_counter = 3

    suites = %w[ A B C D E ]
    ranks = %i[ 1 1 1 2 2 3 3 4 4 5 ]
    suites.each do |suite|
      ranks.each do |rank|
        @remaining_deck << Card.new(rank, suite)
      end
    end
    @user_names.each do |user_name|
      hand = Hand.new([])
      @players << Player.new(user_name, hand)
    end
    distributeCards()
  end

  def distributeCards()
    players.each do |player|
      x = 0
      while x < 5
        index = rand(@remaining_deck.length)
        player.hand.addCard(@remaining_deck[index])
        remaining_deck.delete_at(index)
        x += 1
      end
    end
  end

  def play()
    while (!over)
      #play the game
    end
  end

  def gameOver()
    over = false
    bomb_counter == 0
      over = true
    over #returned
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

class Hand
  attr_accessor :cards, :hints
  def initialize(cards)
    @cards = cards
    @hints = []
  end

  def addCard(card)
    @cards << card
  end

  def to_s
    cards_string = ""
    for card in @cards
      cards_string << "\t #{card} \n"
    end
    cards_string
  end
end

class Player
  attr_accessor :user_name, :hand
  def initialize(user_name, hand)
    @user_name = user_name
    @hand = hand
  end

  def to_s
    "Username: #{@user_name} \n" +
    "Cards: \n #{@hand}"
  end
end
