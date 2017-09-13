class Game < ApplicationRecord
  attr_accessor :remaining_deck, :center_deck
  def initialize()
    @center_deck = []
    @remaining_deck = []
    suites = %w[ A B C D E ]
    values = %i[ 1 1 1 2 2 3 3 4 4 5 ]
    suites.each do |suite|
      values.each do |value|
        @remaining_deck << Card.new(value, suite)
      end
    end
  end
end


class Card
  attr_accessor :value, :suite
  def initialize(value, suite)
    @value = value
    @suite = suite
  end
end
