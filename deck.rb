require './card'

class Deck
  attr_accessor :deck

  def initialize
    suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
    @deck = []
    suits.each do |suit|
    [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, [11, 1]].each { |value| @deck << Card.new(value, suit) }
    end
  end

end
