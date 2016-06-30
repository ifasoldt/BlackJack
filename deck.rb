require './card'

class Deck
  attr_accessor :deck

  def initialize
    suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
    @deck = []
    suits.each do |suit|
    (2..14).each { |value| @deck << Card.new(value, suit) }
    @deck.shuffle!
    end
  end

end
