
class Card
  attr_accessor :name, :value, :suit

  def initialize (value, suit)
    self.value = value
    self.suit = suit
    self.name=(value)
  end

  def value=(value)
    names = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
    @name = names[value]
  end

end
