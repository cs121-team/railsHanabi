class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
    Match.create(uuid)
  end

  def setup()
    Game.setup()
  end

  def takeTurn(message)
    # puts "MESSAGE", message
    # puts "Player ID 1", message.playerId
    # puts "player id 2", message.
    #Game.takeTurn(playerId, message.turnType, message.turnVal)
    #Game.takeTurn(playerId, turnType, turnVal)
    Game.takeTurn(message)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
