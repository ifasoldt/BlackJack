require './card'

class Deck
  attr_accessor :deck, :big_deck

  def initialize
    populate_deck
    populate_big_deck
  end

  def populate_deck
    suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
    @deck = []
    suits.each do |suit|
      (2..14).each { |value| @deck << Card.new(value, suit) }
    end
    @deck.shuffle!
    @deck
  end

  def populate_big_deck

    @big_deck = []
    7.times { big_deck << deck }
    @big_deck.flatten!
    @big_deck.shuffle!
    @big_deck
  end

end
