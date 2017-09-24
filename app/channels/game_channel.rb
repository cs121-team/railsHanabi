class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
    Match.create(uuid)
  end

  def setup()
    Game.setup()
  end

  def takeTurn()
    Game.takeTurn()
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
