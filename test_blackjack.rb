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
    assert game2.winners[0] == {game: 1, winner: "Isaiah"}
    assert game2.dealer_hand.length == 2
  end

  def test_ties_go_to_player
    game3 = BlackJack.new
    card3 = Card.new(10, "Spades")
    card5 = Card.new(9, "Diamonds")
    game3.player = "Isaiah"
    game3.test_switch = true
    game3.play(false, true, [card5, card3], [card3, card5])
    assert game3.dealer_hand_value == game3.calc_hand([card5, card3])
    assert game3.winners[0] == {game: 1, winner: "Isaiah"}
  end

  def test_6_card_win
    game4 = BlackJack.new
    card1 = Card.new(2, "Hearts")
    card2 = Card.new(4, "Clubs")
    card3 = Card.new(3, "Spades")
    card4 = Card.new(2, "Clubs")
    card5 = Card.new(2, "Diamonds")
    card6 = Card.new(3, "Hearts")
    card7 = Card.new(10, "Diamonds")
    card8 = Card.new(12, "Clubs")
    game4.player = "Isaiah"
    game4.test_switch = true
    game4.play(false, true, [card1, card2, card3, card4, card5, card6], [card7, card8])
    assert game4.winners[0] == {game: 1, winner: "Isaiah"}
    assert game4.calc_dealer_hand_value > game4.calc_hand([card1, card2, card3, card4, card5, card6])
  end

  def test_dealer_blackjack
    game5 = BlackJack.new
    card1 = Card.new(10, "Hearts")
    card2 = Card.new(14, "Clubs")
    card3 = Card.new(8, "Spades")
    card4 = Card.new(3, "Clubs")
    game5.player = "Isaiah"
    game5.test_switch = true
    game5.play(false, true, [card1, card3, card4], [card1, card2])
    puts game5.winners
    assert game5.winners[0] == {game: 1, winner: "The dealer"}
  end

  def test_ties_go_to_most_cards_then_player
    game6 = BlackJack.new
    card1 = Card.new(10, "Hearts")
    card2 = Card.new(10, "Clubs")
    card3 = Card.new(8, "Spades")
    card4 = Card.new(5, "Clubs")
    card5 = Card.new(3, "Diamonds")
    game6.player = "Isaiah"
    game6.test_switch = true
    game6.play(false, true, [card1, card3], [card1, card4, card5])
    assert game6.winners[0] == {game: 1, winner: "The dealer"}
    game7 = BlackJack.new
    game7.player = "Isaiah"
    game7.test_switch = true
    game7.play(false, true, [card1, card4, card5], [card1, card4, card5])
    assert game7.winners[0] == {game: 1, winner: "Isaiah"}
  end

  def test_aces_become_1_if_bust
    game8 = BlackJack.new
    card1 = Card.new(14, "Hearts")
    card2 = Card.new(12, "Clubs")
    card3 = Card.new(8, "Clubs")
    game8.test_switch = true
    assert card1.value == 11
    game8.play(false, true, [card1, card2, card3], [card2, card3])
    assert card1.value == 1
  end

  def test_big_deck_7_decks
    game9 = BlackJack.new
    assert game9.deck.length == 52 * 7
  end

end
