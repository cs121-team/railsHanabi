class GamesController < ApplicationController
  before_action :authenticate_user!

  def new
    @game = Game.new
  end

  def create
    @game = Game.new
    puts "success"
    # redirect_to @game
  end
end
