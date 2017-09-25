# require('SecureRandom')
# a = SecureRandom.uuid

class Game < ApplicationRecord
  attr_accessor :center_deck, :remaining_deck, :hint_counter, :bomb_counter
  def self.start(player0, player1, player2, player3)
    @playerIds = [player0, player1, player2, player3].shuffle #TODO: Later modify to work with variable # players

    # Broadcast back to the players subscribed to the channel that the game has started
    ActionCable.server.broadcast "player_#{@playerIds[0]}", {action: "game_start", msg: 0}
    ActionCable.server.broadcast "player_#{@playerIds[1]}", {action: "game_start", msg: 1}
    ActionCable.server.broadcast "player_#{@playerIds[2]}", {action: "game_start", msg: 2}
    ActionCable.server.broadcast "player_#{@playerIds[3]}", {action: "game_start", msg: 3}
    ActionCable.server.broadcast "player_#{@playerIds[4]}", {action: "game_start", msg: 4}
  end

  def self.setup(user_names=%w[ Gavin Jasmine Nupur Olivia ])
    @user_names = user_names
    @center_deck = [0, 0, 0, 0, 0]
    @discard_pile = []
    @remaining_deck = []
    @hint_counter = 8
    @bomb_counter = 3

    suites = %w[ A B C D E ]
    ranks = [1, 1, 1, 2, 2, 3, 3, 4, 4, 5]
    suites.each do |suite|
      ranks.each do |rank|
        @remaining_deck << [rank, suite, false, false] # rank, suit, knowsRank, knowsSuit
      end
    end
    self.distributeCards()
  end

  def self.distributeCards()
    hands = self.getHands()
    self.sendGameState("distribute_cards")
  end

  def self.getHands()
    @hands = []
    @playerIds.each do |player|
      x = 0
      hand = []
      while x < 5
        index = rand(@remaining_deck.length)
        hand.push(@remaining_deck[index])
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
      self.addToCenterStack(card)
    else
      @bomb_counter -= 1
      if @bomb_counter == 0
        self.messageAll({action: "game_over"})
      end
    end
    self.removePlayersCard(playerId, card)
    self.sendGameState("updated_state")
  end

  def self.removePlayersCard(playerId, card)
    hand = @hands[playerId]
    for i in 0..4
      currentCard = hand[i]
      if currentCard[0] == card[0] and currentCard[1] == card[1]
        hand[i] = self.getNewCard()
      end
    end
  end

  def self.getNewCard()
    if @remaining_deck.length == 0
      self.messageAll({action: "game_over"})
    end
    index = rand(@remaining_deck.length)
    newCard = @remaining_deck[index]
    @remaining_deck.delete_at(index)
    return newCard
  end

  def self.getSuitId(suit)
    return ['A','B','C','D','E'].index(suit);
  end

  def self.playable(card)
    rank = card[0]
    suit = self.getSuitId(card[1])
    topCard = @center_deck[suit]
    return rank == (topCard + 1)
  end

  def self.addToCenterStack(card)
    suit = self.getSuitId(card[1])
    @center_deck[suit] = card[0]
  end

  def self.giveHint(player, hint)
    # provide options that person could choose from
    #   list of players, and either rank or suite that they could pick from
    #   store the type of hint (either suite or rank) by setting it true

    @hands[player.to_i].each do |card|
      if card[0].to_s == hint
        card[2] = true
      end
      if card[1].to_s == hint
        card[3] = true
      end
    end
    
    @hint_counter -= 1
    
    self.sendGameState("updated_state")
  end

  def self.discardCard(playerId, cardIndex)
    hand = @hands[playerId]
    card = hand[cardIndex]
    self.removePlayersCard(playerId, card)
    @discard_pile << card
    @hint_counter += 1 # TODO: limit to max
    self.sendGameState("updated_state")
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
    playerId = message["playerId"]

    if !self.gameOver()
      case message["turnType"]
      when "play"
        self.playCard(playerId, turnVal)
      when "hint"
        self.giveHint(turnVal[0], turnVal[1])
      when "discard"
        self.discardCard(playerId, turnVal)
      else
        puts "THIS IS SOME WEIRD INVALID INPUT"
      end
    end
  end

  def self.sendGameState(action)
    self.messageAll({action: action, msg: {
      hands: @hands,
      hint_counter: @hint_counter,
      bomb_counter: @bomb_counter,
      center_deck: @center_deck,
      discard_pile: @discard_pile
    }})
  end
end
