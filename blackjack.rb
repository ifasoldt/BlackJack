require './card.rb'
require './deck.rb'

class BlackJack
  attr_accessor :deck, :player, :dealer, :player_hand, :dealer_hand

  def initialize
    self.deck = Deck.new.deck
    self.dealer = "The dealer"
    self.player_hand = []
    self.dealer_hand = []
  end

  def play
    intro
    initial_deal
    status_report
  end

  def intro
    puts "Welcome to the IronYard BlackJack Table. What would you like to be called?"
    self.player = gets.chomp
    puts "Welcome #{player}. Let's get started"
  end

  def initial_deal
    hit(player_hand)
    hit(dealer_hand)
    hit(player_hand)
    hit(dealer_hand)
  end

  def hit(which_hand)
    which_hand << deck.shift
  end

  def status_report
    puts "You have a #{player_hand_report}"
  end
  def player_hand_report
    card_list = []
    player_hand.each do |card|
    card_list << " #{card.name} of #{card.suit},"
    end
    card_list.insert(-2, " and a")
    return card_list.join
  end


end

BlackJack.new.play
