class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new
    puts "success"
    # redirect_to @game
  end
end
