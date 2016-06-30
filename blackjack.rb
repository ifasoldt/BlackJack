require './card.rb'
require './deck.rb'

class BlackJack
  attr_accessor :deck, :player, :dealer, :player_hand, :dealer_hand, :player_hand_value, :dealer_hand_value, :winners

  def initialize
    self.deck = Deck.new.deck
    self.dealer = "The dealer"
    self.player_hand = []
    self.dealer_hand = []
    self.winners = []
  end

  def play
    intro
    initial_deal
    player_move
    dealer_move
    comparison
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
    bust_check
  end

  def player_move
    status_report_predealer
    response = ""
    until response == "stay"
      puts "Would you like to hit or stay?"
      response = gets.chomp
      if response == "hit"
        hit(player_hand)
        status_report_predealer
        bust_check
      elsif response == "stay"
        puts "Alright, let's see what the dealer has"
      else
        puts "Please respond with 'hit' or 'stay'. All other input is invalid"
      end
    end
  end

  def dealer_move
    status_report_dealer
    until dealer_hand_value > 15
      hit(dealer_hand)
      status_report_dealer
      bust_check
    end
  end

  def comparison
    if dealer_hand_value > player_hand_value
      dealer_wins_scenario
    else
      player_wins_scenario
    end
  end

  def hit(which_hand)
    which_hand << deck.shift
    self.dealer_hand_value = dealer_hand.inject(0){ |sum, card| sum + card.value.to_i }
    self.player_hand_value = player_hand.inject(0){ |sum, card| sum + card.value.to_i }
  end

  def status_report_predealer
    puts "You have a #{player_hand_report} for a total value of #{player_hand.inject(0){|sum, card| sum + card.value}}"
    puts "The dealer has a #{dealer_hand_report_first} and another facedown card for a total visible value of #{dealer_seen_value}"
  end

  def status_report_dealer
    puts "You have a #{player_hand_report} for a total value of #{player_hand.inject(0){|sum, card| sum + card.value}}"
    puts "The dealer has a #{dealer_hand_report_second} for a total visible value of #{dealer_hand_value}"
  end



  def player_hand_report
    card_list = []
    player_hand.each do |card|
    card_list << " #{card.name} of #{card.suit},"
    end
    card_list.insert(-2, " and a")
    card_list.join
  end

  def dealer_seen_value
    i = 1
    sum = 0
    while i < dealer_hand.length
      sum += dealer_hand[i].value
      i += 1
    end
    sum
  end

  def dealer_hand_report_first
    card_list = []
    i = 1
    while i < dealer_hand.length
      card_list << " #{dealer_hand[i].name} of #{dealer_hand[i].suit},"
      i += 1
    end
    card_list.insert(-2, " and a") if dealer_hand.length > 2
    card_list.join
  end

  def dealer_hand_report_second
    card_list = []
    dealer_hand.each do |card|
    card_list << " #{card.name} of #{card.suit},"
    end
    card_list.insert(-2, " and a")
    card_list.join
  end


  def bust_check
    if player_hand_value > 21
      puts "#{player} busts, the dealer wins!"
      return dealer_wins_scenario
    end
    if dealer_hand_value > 21
      puts "The dealer busts, #{player} wins!"
      return player_wins_scenario
    end
  end

  def dealer_wins_scenario
    self.winners << dealer
    puts "Sorry, better luck next time! Would you like to play again? (Y/N)"
    resp = gets.chomp&.downcase[0]
    if resp == "y"
      restart
      play
    else
      puts "Thanks for playing."
      exit
    end
  end

  def player_wins_scenario
    self.winners << dealer
    puts "Congratulations! Would you like to play again? (Y/N)"
    resp = gets.chomp&.downcase[0]
    if resp == "y"
      restart
      play
    else
      puts "Thanks for playing."
      exit
    end
  end

  def restart
    deck = Deck.new.deck
    self.player_hand.clear
    self.dealer_hand.clear
  end

end

BlackJack.new.play
