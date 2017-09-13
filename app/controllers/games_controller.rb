class GamesController < ApplicationController
  before_action :authenticate_user!

  def new
  	# select users and redirect to play
  end

  def play
    @game = Game.new
    # play the game...
  end
end
