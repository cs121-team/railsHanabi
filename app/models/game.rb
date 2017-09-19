# require('SecureRandom')
# a = SecureRandom.uuid

class Game < ApplicationRecord
  attr_accessor :center_deck, :remaining_deck, :players
  def self.start(player1, player2)
    # Randomly choses who gets to be noughts or crosses
    cross, nought = [player1, player2].shuffle

    # Broadcast back to the players subscribed to the channel that the game has started
    ActionCable.server.broadcast "player_#{cross}", {action: "game_start", msg: "Cross"}
    ActionCable.server.broadcast "player_#{nought}", {action: "game_start", msg: "Nought"}

    # Store the details of each opponent
    REDIS.set("opponent_for:#{cross}", nought)
    REDIS.set("opponent_for:#{nought}", cross)
  end

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

  # TODO: should this go in this class or in the controller?
  def play()
    while (!over)
      #play
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
  attr_accessor :rank, :suite, :knowsRank, :knowsSuite
  def initialize(rank, suite)
    @rank = rank
    @suite = suite
    @knowsRank = false
    @knowsSuite = false
  end

  def knowsRank()
    @knowsRank = true
  end

  def knowsSuite()
    @knowsSuite = true
  end

  def to_s
    card_string = "#{@rank}#{@suite}"

    if @knowsRank
      card_string << "#{@rank}"
    end

    if @knowsSuite
      card_string << "#{@suite}"
    end

    card_string #returned
  end
end

class Hand
  attr_accessor :cards
  def initialize(cards)
    @cards = cards
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
