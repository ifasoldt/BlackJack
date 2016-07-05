module StatusReports

  def status_report_predealer(player_hand_d)
    puts "For hand number #{player_hands.index(player_hand_d) + 1} you have a #{player_hand_report_simple(player_hand_d)}."
    puts "The dealer has a #{dealer_hand_report_first} and another facedown card for a total visible value of #{dealer_seen_value}."
  end

  def status_report_predealer_split
    puts "You have a #{player_hand_report}"
    puts "The dealer has a #{dealer_hand_report_first} and another facedown card for a total visible value of #{dealer_seen_value}."
  end


  def player_hand_report_simple(player_hand_e)
    card_list = []
    player_hand_e.each do |card|
      card_list << " #{card.name} of #{card.suit},"
    end
    card_list.insert(-2, " and a")
    card_list << " for a total value of #{player_hand_e.inject(0){|sum, card| sum + card.value}}"
    card_list.join
  end

  def status_report_dealer
    puts "You have a #{player_hand_report}"
    puts "The dealer has a #{dealer_hand_report_second} for a total value of #{calc_dealer_hand_value}."
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
      hand_list << card_list.join
    end
    hand_list.join(" and ")
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

  def dealer_seen_value
    i = 1
    sum = 0
    while i < dealer_hand.length
      sum += dealer_hand[i].value
      i += 1
    end
    sum
  end

end
