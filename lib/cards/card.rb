class Card
  attr_accessor :balance
  attr_reader :type, :number

  def initialize
    @number = 16.times.map { rand(10) }.join
    @balance = 0
    @type = ''
  end

  def show_cards
    CardProcessor.new.show_cards
  end

  def create_card
    CardProcessor.new.create_card
  end

  def destroy_card
    CardProcessor.new.destroy_card
  end
end
