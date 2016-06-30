
class Card
  attr_accessor :name, :value, :suit

  def initialize (value, suit)
    self.value = value if value < 11
    self.value = 10 if value > 10 && value != 14
    self.value = 11 if value == 14
    self.suit = suit
    self.name=(value)
  end

  def name=(value)
    names = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
    @name = names[value]
  end

end
