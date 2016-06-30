require './card.rb'
require './deck.rb'

class BlackJack
  attr_accessor :deck, :player, :dealer, :player_hand, :dealer_hand

  def initialize
    self.deck = Deck.new
    self.dealer = "The dealer"
    self.player_hand = []
    self.dealer_hand = []




  def play
    intro

  end

  def intro
    puts "Welcome to the IronYard BlackJack Table. What would you like to be called?"
    self.player = gets.chomp
