require './card.rb'
require './deck.rb'
require './status_reports.rb'
require './advisor.rb'

class BlackJack
  attr_accessor :deck, :player, :dealer, :player_hands, :dealer_hand, :dealer_hand_value, :winners, :game_num, :test_switch, :blackjack_counter

  include StatusReports
  include Advisor

  def initialize
    self.deck = Deck.new.big_deck
    self.dealer = "The dealer"
    self.player_hands = [[]]
    self.dealer_hand = []
    self.winners = []
    self.game_num = 0
    self.test_switch = false
  end

  def play(say_intro = true, initial_deal_inject_switch = false, player_hand_inject = [], dealer_hand_inject = [])
    intro if say_intro
    if initial_deal_inject_switch
      initial_deal_inject(player_hand_inject, dealer_hand_inject)
    else
      initial_deal
    end
    player_moves
    #I think the unless busted? needs to go inside the dealer_move and comparison methods, and I think that I have to iterate in each of them over every hand. This also means busted has to take an argument of the hand we are looking at.
    dealer_move unless all_hands_completed?
    comparison unless all_hands_completed?
    rematch? unless test_switch
  end

  def intro
    puts "Welcome to the IronYard BlackJack Table. What would you like to be called?"
    self.player = gets.chomp
    puts "Welcome #{player}. Let's get started"
  end

  def initial_deal
    player_hands[0] << hit
    dealer_hand << hit
    player_hands[0] << hit
    dealer_hand << hit
    bust_check_dealer
    split
    player_hands.each do |hand|
      check_for_winner(hand)
      blackjack_check(hand)
    end
  end

  def player_moves
    # each over the hands here and do this with all of them. Each do |x| x gets shoved into hit.
    player_hands.each do |this_hand|
      status_report_predealer(this_hand) unless test_switch
      response = ""
      unless test_switch
        until response[0] == "s" || busted?(this_hand)
          hit_advice_prompt(this_hand)
          puts "Would you like to hit or stand?"
          response = gets.chomp
          if response[0] == "h"
            # assuming eached over all the hands above somewhere.
            this_hand << hit
            status_report_predealer(this_hand)
          elsif response[0] == "s"
          else
            puts "Please respond with 'hit' or 'stay'. All other input is invalid"
          end
        end
      end
      check_for_winner(this_hand)
    end
  end

  def dealer_move
    puts "Alright, let's see what the dealer has"
    status_report_dealer unless test_switch
    until calc_dealer_hand_value > 15
      dealer_hand << hit
      status_report_dealer unless test_switch
      bust_check_dealer
    end
  end

  def comparison
    player_hands.each do |this_hand_for_comparison|
      unless busted?(this_hand_for_comparison)
        if calc_dealer_hand_value == 21 && dealer_hand.length == 2 && (this_hand_for_comparison.length > 2 || calc_hand(this_hand_for_comparison) < 21)
          puts "Dealer had blackjack, tough luck!"
          dealer_wins_scenario
        elsif calc_dealer_hand_value > calc_hand(this_hand_for_comparison)
          dealer_wins_scenario
        elsif calc_dealer_hand_value == calc_hand(this_hand_for_comparison) && dealer_hand.length > this_hand_for_comparison.length
          dealer_wins_scenario
        else
          player_wins_scenario
        end
      end
    end
  end

  def rematch?
    puts "Would you like to play again? (Y/N)"
    resp = gets.chomp&.downcase[0]
    if resp == "y"
      restart
      play(false)
    else
      puts "Thanks for playing. Here's a list of the winners #{winners.each {|x| x}}"
      exit
    end
  end

  def check_for_winner(pl_hand)
    if calc_hand(pl_hand) > 21 || calc_dealer_hand_value > 21
      ace_decrease(pl_hand)
      ace_decrease(dealer_hand)
      bust_check_player(pl_hand)
    end
      six_card_winner(pl_hand)
  end

  def blackjack_check(player_hand_b)
    self.blackjack_counter = 0
    if calc_hand(player_hand_b) == 21 && player_hand_b.length == 2
      puts "You got BlackJack! WOOOOOO!!!!"
      player_wins_scenario
      self.blackjack_counter += 1
      rematch? if !test_switch && all_hands_completed?
    end
  end



  def busted?(a_hand)
    if calc_hand(a_hand) > 21 || calc_dealer_hand_value > 21
      ace_decrease(a_hand)
      ace_decrease(dealer_hand)
      if calc_hand(a_hand) > 21 || calc_dealer_hand_value > 21
        return true
      end
    else
      false
    end
  end


  def hit
    new_card = deck.shift
    new_card
  end


  # could just make bust check return true or false, and then let another method handle the pushing out to dealer wins.
  def bust_check_player(player_hand_a)
    if calc_hand(player_hand_a) > 21
      puts "#{player} busts, the dealer wins!"
      return dealer_wins_scenario
    end
  end

  def bust_check_dealer
    ace_decrease(dealer_hand)
    if calc_dealer_hand_value > 21
      puts "The dealer busts, #{player} wins!"
      return player_wins_scenario
    end
  end

  def ace_decrease(hand)
    hand.each do |card|
      if calc_hand(hand) > 21 || calc_dealer_hand_value > 21
        if card.value == 11
          card.value = 1
          puts "Ace reassigned, total value now #{calc_hand(hand)}"
        end
      end
    end
  end

  def six_card_winner(player_hand_c)
    # each over player_hands
    if player_hand_c.length > 5 && calc_hand(player_hand_c) < 22
      puts "You have 6 cards and haven't busted! You win!"
      player_wins_scenario
    end
  end

  def dealer_wins_scenario
    self.game_num += 1
    self.winners << {game: game_num, winner: dealer}
    puts "You lost! Sorry, better luck next time!"
  end

  def player_wins_scenario
    self.game_num += 1
    self.winners << {game: game_num, winner: player}
    puts "Congratulations! You won!"
  end

  def restart
    self.deck = Deck.new.big_deck
    self.player_hands = [[]]
    self.dealer_hand.clear
  end

  def calc_hand(hand)
    hand.inject(0) {|sum, card| sum + card.value }
  end

  def calc_dealer_hand_value
    self.dealer_hand_value = dealer_hand.inject(0){|sum, card| sum + card.value}
    @dealer_hand_value
  end

  def all_hands_completed?
    busted_count = 0
    player_hands.each do |hand|
      if busted?(hand)
        busted_count += 1
      end
    end
    if busted_count + blackjack_counter == player_hands.length
      return true
    else
      return false
    end
  end

  def split
    player_hands.each do |hand|
      if hand[0].name == hand[1].name
        split_advice_prompt(hand[0])
        puts "Would you like to split your hand? #{hand} If so, then type 'yes'"
        response = gets.chomp.downcase
        if response[0] == "y"
          player_hands.insert(-1,[hand[0], hit], [hand[1], hit])
          player_hands.delete_at(player_hands.index(hand))
          status_report_predealer_split
          split
        end
      end
    end
  end

  def initial_deal_inject(player_hand_inject, dealer_hand_inject)
    player_hands[0] = player_hand_inject
    self.dealer_hand += dealer_hand_inject
    bust_check_dealer
    split
    player_hands.each do |hand|
      check_for_winner(hand)
      blackjack_check(hand)
    end
  end

end
