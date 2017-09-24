# require('SecureRandom')
# a = SecureRandom.uuid

class Game < ApplicationRecord
  attr_accessor :center_deck, :remaining_deck, :players,
                :hint_counter, :bomb_counter
  def self.start(player1, player2, player3="player3uid", player4="player4uid")
    @playerIds = [player1, player2].shuffle #TODO: Later modify to work with variable # players
    player0 = @playerIds[0]
    player1 = @playerIds[1]

    # Broadcast back to the players subscribed to the channel that the game has started
    ActionCable.server.broadcast "player_#{player0}", {action: "game_start", msg: 0}
    ActionCable.server.broadcast "player_#{player1}", {action: "game_start", msg: 1}

    # Store the details of each opponent
    # REDIS.set("opponent_for:#{player0}", player1) #TODO(olivia: I think we can delete this. Verify.
    # REDIS.set("opponent_for:#{player1}", player0)
  end

  def self.setup(user_names=%w[ Gavin Jasmine Nupur Olivia ])
    puts "INITIALIZING GAME!"
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
        @remaining_deck << [rank, suite, false, false] #Card.new(rank, suite)
      end
    end
    @user_names.each do |user_name|
      hand = Hand.new([])
      @players << Player.new(user_name, hand)
    end
    self.distributeCards()
  end

  def self.distributeCards()

    puts "Distributing Cards in game.rb!"
    @hands = []
    @playerIds.each do |player|
      x = 0
      hand = []
      while x < 5
        index = rand(@remaining_deck.length)
        hand.push(@remaining_deck[index])
        #player.hand.addCard(@remaining_deck[index])
        @remaining_deck.delete_at(index)
        x += 1
      end
      @hands.push(hand)
    end
    
    puts @hands
    self.messageAll({action: "distribute_cards", msg: @hands})
    # player0 = @playerIds[0]
    # player1 = @playerIds[1]
    # ActionCable.server.broadcast "player_#{player0}", {action: "distribute_cards", msg: "PLAYER 0 GOT STUFF!!!"}
    # ActionCable.server.broadcast "player_#{player1}", {action: "distribute_cards", msg: "PLAYER 1 GOT STUF!!!"}
  end

  def self.messageAll(broadcast)
    @playerIds.each do |id|
      ActionCable.server.broadcast "player_#{id}", broadcast
    end
  end


  def play()
    over = gameOver()
    while (!over)
      # play the game
      # TODO: give users options: play a card, discard a card, or give a hint

      # TODO: if the user wants to play a card, ask them to select the card
      # then, call playCard()

      # TODO: if the user wants to discard, call discardCard()

      # TODO: if the user wants to give a hint, call giveHint()

      # Move to next person's turn
      over = gameOver()
    end
  end

  def playCard()
    # ask the user to select a card, save this as card

    if (playable(card))
      addToCenterStack(card)
    else
      bomb_counter -= 1
    end
  end

  def playable(card)
    # TODO: true if the card can be played based on other cards in the center pile
    center_deck.any?{|center_card| center_card.suite == card.suite &&
      center_card.rank == (card.rank - 1)}
  end

  def addToCenterStack(card)
    center_deck << card;
  end

  def giveHint()
    suiteHint = false
    rankHint = false
    # provide options that person could choose from
    #   list of players, and either rank or suite that they could pick from
    #   store the type of hint (either suite or rank) by setting it true

    # TODO: for the chosen hint, identify list of all cards that are affected
    hintCards = []

    # set the hint to true for the specified card
    if suiteHint
      hintCards.each do |card|
        card.knowsSuite = true
      end
    end

    if rankHint
      hintCards.each do |card|
        card.knowsRank = true
      end
    end
  end

  def discardCard()
    # let the user choose a card to discard

    # remove the card from their hand

    # draw a new card for them

    # increase the hint counter
    hint_counter += 1
  end

  def gameOver()
    over = false
    bomb_counter == 0
      over = true
    over #returned
  end

  def self.takeTurn()
    puts "TAKING A TURN!!!"
    self.messageAll({action: "turn_finished", msg: true});
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

  def removeCard(card)
    @cards.delete_if {|c| c == card}
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
