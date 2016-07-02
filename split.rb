def split
  player_hands.each do |hand|
    if hand[0].name == hand[1].name
      puts "Would you like to split your hand? #{hand} (Y/N)"
      response = gets.chomp.downcase
      if response == "y"
        player_hands.insert(-1,[hand[0], hit) ] [hand[1], hit)]
        player_hands.delete_at(player_hands.index(hand))
        status_report_predealer
      elsif response == "n"
        next
      end
    end
  end
end
