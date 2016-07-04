module Advisor
  def hit_advice(player_hand_f)
    if calc_hand(player_hand_f) > 18
      return "STAND"
    elsif calc_hand(player_hand_f) > 16 && include_ace?(player_hand_f) == false
      return "STAND"
    elsif calc_hand(player_hand_f) == 18 && include_ace?(player_hand_f) && dealer_seen_value > 8
      return "HIT"
    elsif calc_hand(player_hand_f) == 18 && include_ace?(player_hand_f)
      return "STAND"
    elsif include_ace?(player_hand_f)
      return "HIT"
    elsif calc_hand(player_hand_f) > 16
      return "STAND"
    elsif calc_hand(player_hand_f) > 12 &&  dealer_seen_value < 7
      return "STAND"
    elsif calc_hand(player_hand_f) > 12 && dealer_seen_value > 6
      return "HIT"
    elsif calc_hand(player_hand_f) == 12 && dealer_seen_value > 3 && dealer_seen_value < 7
      return "STAND"
    else
      return "HIT"
    end
  end

  def hit_advice_prompt(player_hand_h)
    puts "do you want advice on whether to hit or stand?(Y/N)"
    response = gets.chomp.downcase
    if response[0] == "y"
      puts "Based on your cards and the dealer's visible card, the percentages say to #{hit_advice(player_hand_h)}"
    elsif response[0] == "n"
      puts "ok, good luck!"
    else
      puts "please return a valid response of 'yes' or 'no'."
      hit_advice_prompt(player_hand_h)
    end
  end

  def include_ace?(player_hand_g)
    player_hand_g.each do |card|
      if card.value == 11
        return true
      else
        next
      end
    end
    return false
  end

  def split_advice(card1)
    if card1.value == 11
      return "SPLIT"
  elsif card1.value == 9 && (dealer_seen_value == 7 || 10 || 11 || 1)
      return "DON'T SPLIT"
    elsif card1.value == 9
      return "SPLIT"
    elsif card1.value == 8
      return "SPLIT"
    elsif card1.value == 7 && dealer_seen_value < 8
      return "SPLIT"
    elsif card1.value == 6 && dealer_seen_value < 7 && dealer_seen_value != 2
      return "SPLIT"
    elsif (card1.value == 3 || card1.value == 2) && (dealer_seen_value == 4 || 5 || 6 || 7)
      return "SPLIT"
    else
      return "DON'T SPLIT"
    end
  end

  def split_advice_prompt(card)
    puts "do you want advice on whether to split or not?(Y/N)"
    response = gets.chomp.downcase
    if response[0] == "y"
      puts "Based on your cards and the dealer's visible card, the percentages say to #{split_advice(card)}"
    elsif response[0] == "n"
      puts "ok, good luck!"
    else
      puts "please return a valid response of 'yes' or 'no'."
      split_advice_prompt(card)
    end
  end

end
