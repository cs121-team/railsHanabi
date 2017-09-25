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
  end

  def self.setup(user_names=%w[ Gavin Jasmine Nupur Olivia ])
    puts "INITIALIZING GAME!"
    @user_names = user_names
    @center_deck = [nil, nil, nil, nil, nil]
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
    hands = self.getHands()
    self.messageAll({action: "distribute_cards", msg: @hands}) # TODO: Don't send people their own cards
    self.messageAll({action: "hint_counter", msg: @hint_counter})
  end

  def self.getHands()
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
    return @hands
  end 

  def self.messageAll(broadcast)
    @playerIds.each do |id|
      ActionCable.server.broadcast "player_#{id}", broadcast
    end
  end


  def self.playCard(playerId, cardIndex)
    hand = @hands[playerId]
    card = hand[cardIndex]
    if (self.playable(card))
      puts "YES"
      self.addToCenterStack(card)
    else
      puts "NO"
      @bomb_counter -= 1
    end
    self.removePlayersCard(playerId, card)
    self.sendGameState()
  end

  def self.removePlayersCard(playerId, card)
    puts "REMOVING PLAYER CARD"
    hand = @hands[playerId]
    for i in 0..4
      currentCard = hand[i]
      if currentCard[0] == card[0] and currentCard[1] == card[1]
        hand[i] = self.getNewCard()
      end
    end
  end

  def self.getNewCard()
    index = rand(@remaining_deck.length)
    newCard = @remaining_deck[index]
    @remaining_deck.delete_at(index)
    return newCard
  end

  def self.getSuitId(suit)
    puts "getting suit id"
    return ['A','B','C','D','E'].index(suit);
  end

  def self.playable(card)
    puts "CHECK PLAYABLE"
    rank = card[0]
    puts rank
    suit = self.getSuitId(card[1])
    puts card
    topCard = @center_deck[suit]
    if topCard.nil? # No top card
      return rank == 1
    end
    return rank = topCard + 1
  end

  def self.addToCenterStack(card)
    puts "ADDING TO CENTER"
    suit = self.getSuitId(card[1])
    @center_deck[suit] = card[0]
  end

  def self.giveHint(player, hint)
    # provide options that person could choose from
    #   list of players, and either rank or suite that they could pick from
    #   store the type of hint (either suite or rank) by setting it true

    # TODO: for the chosen hint, identify list of all cards that are affected

    # TODO: do this better
    # values for A-E are 6-10

    if hint == 6
      hint = 'A'
    elsif hint == 7
      hint = 'B'
    elsif hint == 8
      hint = 'C'
    elsif hint == 9
      hint = 'D'
    elsif hint == 10
      hint = 'E'
    end

    @hands[player.to_i].each do |card|
      if card[0].to_s == hint
        card[2] = true
      end
      if card[1].to_s == hint
        card[3] = true
      end
    end

  end

  def self.discardCard()
    # let the user choose a card to discard

    # remove the card from their hand

    # draw a new card for them

    # increase the hint counter
    hint_counter += 1
  end

  def self.gameOver()
    over = false
    if @bomb_counter == 0
      over = true
    end
    over #returned
  end

  def self.takeTurn(data)
    message = data['message']
    turnVal = message["turnVal"]
    puts ">>>>>>>>>> TAKING TURN <<<<<<<<<<<<"
    puts message
    puts message["playerId"]
    playerId = message["playerId"]
    player = @players[playerId] # TODO(olivia): figure out how message works

    if !self.gameOver()
      case message["turnType"]
      when "play"
        puts "TURN VAL"
        puts turnVal
        #card = Card.new(turnVal[0], turnVal[1]) #rank, suite
        self.playCard(playerId, turnVal)
      when "hint"
        self.giveHint(turnVal[0], turnVal[1])
      when "discard"
        puts "discarding not implemented yet"
        card = Card.new(turnVal[0], turnVal[1]) #rank, suite
      else
        puts "THIS IS SOME WEIRD INVALID THING"
      #self.messageAll({action: "turn_finished", msg: true});
      end
    end
  end

  def self.sendGameState()
    self.messageAll({action: "updated_state", msg: {
      hands: @hands,
      hint_counter: @hint_counter,
      bomb_counter: @bomb_counter
    }})

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
