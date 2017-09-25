require "redis"
class Match < ApplicationRecord
  def self.create(uuid)
    for i in 0..2
      if REDIS.get("matches" + i.to_s).blank?
        puts "SETTING ", i
        REDIS.set("matches" + i.to_s, uuid)
        return
      end
    end

    # If we're at this line, we have 4 players waiting
    Game.start(uuid, REDIS.get("matches0"), REDIS.get("matches1"), REDIS.get("matches2"))

    # Clear the waiting key as no one new is waiting
    for i in 0..2
      REDIS.set("matches" + i.to_s, nil)
    end
  end
end
