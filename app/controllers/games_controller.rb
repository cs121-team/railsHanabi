class GamesController < ApplicationController
  before_action :authenticate_user!

  def new
  	# select users and redirect to play
  end

  def play
    @game = Game.new # This could also be moved to the new function
    @game.setup(%w[ GavinTheIncredible JasmineTheAmazing SuperDuperNupur OliviaTheAwesome])
    #@game.save # I think we only want to call this function when all 4 players arrive.
  end
end
