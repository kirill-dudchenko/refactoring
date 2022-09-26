class Card
  attr_accessor :balance
  attr_reader :type, :number

  def initialize
    @number = 16.times.map { rand(10) }.join
    @balance = 0
    @type = ''
  end
end
