require './card.rb'
require './deck.rb'

class BlackJack
  attr_accessor :deck, :player, :dealer, :player_hands, :dealer_hand, :player_hand_value, :dealer_hand_value, :winners, :game_num

  def initialize
    self.deck = Deck.new.big_deck
    self.dealer = "The dealer"
    self.player_hands = [[]]
    self.dealer_hand = []
    self.winners = []
    self.game_num = 0
    self.dealer_hand_value = dealer_hand.inject(0){ |sum, cards| sum + cards.value.to_i }
    # player_hands.each do |hand|
    #   self.player_hand_value << [hand.inject(0){ |sum, cards| sum + cards.value }]
    end
  end

  def play(say_intro = true)
    intro if say_intro
    initial_deal
    player_moves
    dealer_move unless busted?
    comparison unless busted?
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
    check_for_winner(player_hands[0])
  end

  def player_moves
    # each over the hands here and do this with all of them. Each do |x| x gets shoved into hit.
    player_hands.each do |this_hand|
      blackjack_check(this_hand)
      one_status_report
      response = ""
      until response == "stay" || busted?
        puts "Would you like to hit or stay?"
        puts calc_hand(this_hand).inspect
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
      check_for_winner
    end
  end

  def dealer_move
    status_report_dealer
    until dealer_hand_value > 15
      dealer_hand << hit
      one_status_report
      bust_check
    end
  end

  def comparison
    # each over the player hands.
    if dealer_hand_value > calc_hand(this_hand)
      dealer_wins_scenario
    elsif dealer_hand_value == calc_hand(this_hand) && dealer_hand.length > player_hands.length
      dealer_wins_scenario
    else
      player_wins_scenario
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
    if calc_hand(pl_hand) > 21 || dealer_hand_value > 21
      ace_decrease(pl_hand)
      ace_decrease(dealer_hand)
      bust_check(pl_hand)
      six_card_winner
    end
  end

  def blackjack_check(this_hand)
    if calc_hand(this_hand) == 21
      puts "You got BlackJack! WOOOOOO!!!!"
      player_wins_scenario
      rematch?
    elsif dealer_hand_value == 21
      puts "Wow, dealer hit BlackJack! That sucks."
      rematch?
    end
  end



  def busted?
    if calc_hand(this_hand) > 21 || dealer_hand_value > 21
      ace_decrease(player_hands)
      ace_decrease(dealer_hand)
      if calc_hand(this_hand) > 21 || dealer_hand_value > 21
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
    puts "You have #{player_hand_report.each {|hand| puts hand}}"
    puts "The dealer has a #{dealer_hand_report_first} and another facedown card for a total visible value of #{dealer_seen_value}"
  end

  def status_report_dealer
    puts "You have a #{player_hand_report} for a total value of #{player_hand.inject(0){|sum, card| sum + card.value}}"
    puts "The dealer has a #{dealer_hand_report_second} for a total value of #{dealer_hand_value}"
  end



  def player_hand_report
    hand_list = []
    player_hands.each do |hand|
      card_list = []
      hand.each do |card|
        card_list << " #{card.name} of #{card.suit},"
        card_list.insert(-2, " and a")
        puts card.inspect
      end
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
  def bust_check(player_hand_a)
    if calc_hand(player_hand_a) > 21
      puts "#{player} busts, the dealer wins!"
      return dealer_wins_scenario
    end
    if dealer_hand_value > 21
      puts "The dealer busts, #{player} wins!"
      return player_wins_scenario
    end
  end

  def ace_decrease(hand)
    if calc_hand(this_hand) > 21 || dealer_hand_value > 21
      hand.each do |card|
        if card.value == 11
          card.value = 1
          one_status_report
        end
      end
    end
  end

  def six_card_winner
    # each over player_hands
    if player_hands.length > 5 && player_hand_value < 22
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
    self.player_hands.clear
    self.dealer_hand.clear
  end

  def one_status_report
    if dealer_hand.length == 2
      status_report_predealer
    else
      status_report_dealer
    end
  end

  def calc_hand(hand)
    hand.inject(0) {|sum, card| sum + card.value }
  end

end

BlackJack.new.play
