require './card.rb'
require './deck.rb'

class BlackJack
  attr_accessor :deck, :player, :dealer, :player_hands, :dealer_hand, :dealer_hand_value, :winners, :game_num

  def initialize
    self.deck = Deck.new.big_deck
    self.dealer = "The dealer"
    self.player_hands = [[]]
    self.dealer_hand = []
    self.winners = []
    self.game_num = 0
  end

  def play(say_intro = true)
    intro if say_intro
    initial_deal
    player_moves
    #I think the unless busted? needs to go inside the dealer_move and comparison methods, and I think that I have to iterate in each of them over every hand. This also means busted has to take an argument of the hand we are looking at.
    dealer_move unless all_hands_busted?
    comparison unless all_hands_busted?
    rematch?
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
    check_for_winner(player_hands[0])
    blackjack_check(player_hands[0])
    split
  end

  def player_moves
    # each over the hands here and do this with all of them. Each do |x| x gets shoved into hit.
    player_hands.each do |this_hand|
      one_status_report
      response = ""
      until response == "stay" || busted?(this_hand)
        puts "Would you like to hit or stay?"
        response = gets.chomp
        if response == "hit"
          # assuming eached over all the hands above somewhere.
          this_hand << hit
          one_status_report
        elsif response == "stay"
          puts "Alright, let's see what the dealer has"
        else
          puts "Please respond with 'hit' or 'stay'. All other input is invalid"
        end
      end
      check_for_winner(this_hand)
    end
  end

  def dealer_move
    status_report_dealer
    until calc_dealer_hand_value > 15
      dealer_hand << hit
      one_status_report
      bust_check_dealer
    end
  end

  def comparison
    player_hands.each do |this_hand_for_comparison|
      if calc_dealer_hand_value > calc_hand(this_hand_for_comparison)
        dealer_wins_scenario
      elsif calc_dealer_hand_value == calc_hand(this_hand_for_comparison) && dealer_hand.length > this_hand_for_comparison.length
        dealer_wins_scenario
      else
        player_wins_scenario
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
      six_card_winner(pl_hand)
    end
  end

  def blackjack_check(player_hand_b)
    if calc_hand(player_hand_b) == 21
      puts "You got BlackJack! WOOOOOO!!!!"
      player_wins_scenario
      rematch?
    elsif calc_dealer_hand_value == 21
      puts "Wow, dealer hit BlackJack! That sucks."
      rematch?
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

  def status_report_predealer
    puts "You have a #{player_hand_report.each {|hand_list| hand_list.flatten}}"
    puts "The dealer has a #{dealer_hand_report_first} and another facedown card for a total visible value of #{dealer_seen_value}"
  end

  def status_report_dealer
    puts "You have a #{player_hand_report.each {|hand_list| hand_list.flatten}}"
    puts "The dealer has a #{dealer_hand_report_second} for a total value of #{calc_dealer_hand_value}"
  end

  def one_status_report
    if dealer_hand.length == 2
      status_report_predealer
    else
      status_report_dealer
    end
  end



  def player_hand_report
    hand_list = []
    player_hands.each do |hand|
      card_list = []
      hand.each do |card|
        card_list << " #{card.name} of #{card.suit},"
      end
      card_list.insert(-2, " and a")
      card_list << " for a total value of #{hand.inject(0){|sum, card| sum + card.value}}"
      hand_list << [card_list.join]
    end
    hand_list
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

  # could just make bust check return true or false, and then let another method handle the pushing out to dealer wins.
  def bust_check_player(player_hand_a)
    if calc_hand(player_hand_a) > 21
      puts "#{player} busts, the dealer wins!"
      return dealer_wins_scenario
    end
  end

  def bust_check_dealer
    if calc_dealer_hand_value > 21
      ace_decrease(dealer_hand)
      puts "The dealer busts, #{player} wins!"
      return player_wins_scenario
    end
  end

  def ace_decrease(hand)
    hand.each do |card|
      if calc_hand(hand) > 21 || calc_dealer_hand_value > 21
        if card.value == 11
          card.value = 1
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

  def all_hands_busted?
    busted_count = 0
    player_hands.each do |hand|
      if busted?(hand)
        busted_count += 1
      end
    end
    if busted_count == player_hands.length
      return true
    else
      return false
    end
  end

  def split
    player_hands.each do |hand|
      if hand[0].name == hand[1].name
        puts "Would you like to split your hand? #{hand} (Y/N)"
        response = gets.chomp.downcase
        if response == "y"
          player_hands.insert(-1,[hand[0], hit], [hand[1], hit])
          player_hands.delete_at(player_hands.index(hand))
          status_report_predealer
          split
        elsif response == "n"
          next
        end
      end
    end
  end


end

BlackJack.new.play
