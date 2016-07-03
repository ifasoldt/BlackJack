module Advisor
  def hit_advice(player_hand_f)
    if calc_hand(player_hand_f) > 18
      return puts "stand"
    elsif calc_hand(player_hand_f) > 16 && include_ace?(player_hand_f) == false
      return puts "stand"
    elsif calc_hand(player_hand_f) == 18 && include_ace(player_hand_f) && dealer_seen_value > 8
      return puts "hit"
    elsif calc_hand(player_hand_f) == 18 && include_ace(player_hand_f)
      return puts "stand"
    elsif include_ace?(player_hand_f)
      return puts "hit"
    elsif calc_hand(player_hand_f) > 16
      puts "stand"
    elsif calc_hand(player_hand_f) > 12 &&  dealer_seen_value < 7
      puts "stand"
    elsif calc_hand(player_hand_f) > 12 && dealer_seen_value > 6
      puts "hit"
    elsif calc_hand(player_hand_f) == 12 && dealer_seen_value > 3 && dealer_seen_value < 7
      puts "stand"
    else
      puts "hit"
    end
  end

  def hit_advice_prompt(player_hand_h)
    puts "do you want advice on whether to hit or no?(Y/N)"
    response = gets.chomp.downcase
    if response[0] == "y"
      hit_advice(player_hand_h)
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

end
