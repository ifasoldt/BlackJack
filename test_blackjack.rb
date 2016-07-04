require 'minitest/autorun'
require './blackjack.rb'

class BlackJackTest < MiniTest::Test

  def test_new_deck_each_game
    game1 = BlackJack.new
    big_deck1 = game1.deck
    big_deck3 = game1.deck
    game1.restart
    big_deck2 = game1.deck
    assert big_deck1 == big_deck3
    assert big_deck1 === big_deck3
    refute big_deck1 == big_deck2
  end

  def test_shuffle_deck_each_game
    game1 = BlackJack.new
    big_deck1 = game1.deck
    game1.restart
    big_deck2 = game1.deck
    refute big_deck1[0] == big_deck2[0]
  end

  def test_suits_exist
    game1 = BlackJack.new
    big_deck1 = game1.deck
    assert big_deck1[0].suit == "Hearts" || "Diamonds" || "Clubs" || "Spades"
  end

  def test_dealer_hit_until_16
    game1 = BlackJack.new
    card1 = Card.new(5, "Hearts")
    card2 = Card.new(6, "Spades")
    game1.dealer_hand = [card1, card2]
    game1.player_hands = [[card1, card2]]
    assert game1.dealer_hand.length == 2
    assert game1.calc_dealer_hand_value== 11
    game1.dealer_move
    assert game1.calc_dealer_hand_value > 15
    assert game1.dealer_hand.length > 2
  end

  def test_lose_if_go_over_21
    game1 = BlackJack.new
    card2 = Card.new(1, "Spades")
    card3 = Card.new(10, "Spades")
    card4 = Card.new(10, "Hearts")
    card5 = Card.new(2, "Diamonds")
    refute game1.busted?([card2, card3, card4])
    assert game1.busted?([card5, card3, card4])
  end

  def test_must_beat_dealer_and_winners_get_recorded
    game1 = BlackJack.new
    card2 = Card.new(1, "Spades")
    card3 = Card.new(10, "Spades")
    card4 = Card.new(10, "Hearts")
    card5 = Card.new(2, "Diamonds")
    game1.dealer_hand = [card2, card3]
    game1.player_hands = [[card3, card4]]
    game1.player = "Isaiah"
    game1.comparison
    assert game1.winners[0] == {game: 1, winner: "Isaiah"}
    game1 = BlackJack.new
    game1.dealer_hand = [card4, card3]
    game1.player_hands = [[card3, card2]]
    game1.comparison
    assert game1.winners[0] == {game: 1, winner: "The dealer"}
  end

  # def test_can_see_one_of_dealers_cards
  #   game1 = BlackJack.new
  #   card2 = Card.new(9, "Spades")
  #   card3 = Card.new(10, "Spades")
  #   game1.dealer_hand = [card2, card3]
  #   game1.player_hands = [[card2, card3]]
  #   puts game1.status_report_predealer([card2, card3]).inspect
  #   assert game1.status_report_predealer([card2, card3]) == "For hand number 1 you have a  9 of Spades, and a 10 of Spades, for a total value of 19" "The dealer has a  10 of Spades, and another facedown card for a total visible value of 10"
  # end

  def test_blackjack_win_automagically
    game2 = BlackJack.new
    card2 = Card.new(14, "Spades")
    card3 = Card.new(10, "Spades")
    card5 = Card.new(2, "Diamonds")
    game2.player = "Isaiah"
    game2.test_switch = true
    game2.play(false, true, [card2, card3], [card3, card5])
    puts game2.winners
    assert game2.winners[0] == {game: 1, winner: "Isaiah"}
    assert game2.dealer_hand.length == 2
  end

end
