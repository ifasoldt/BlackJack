require './deck'

class Player
  attr_accessor :name, :hand,
  def initialize(name)
    @name = name
    @playing_deck = Deck.new.deck
  end


  def shuffle
    playing_deck.shuffle!
  end
end

5.times do |x|
  puts "hello"
end
