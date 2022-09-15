class CapitalistCard < Card
  attr_accessor :balance
  attr_reader :type, :number

  def initialize
    super
    @type = 'capitalist'
    @number = 16.times.map { rand(10) }.join
    @balance = 100.00
  end

  def withdraw_tax(amount)
    amount * 0.04
  end

  def put_tax(_amount)
    10
  end

  def sender_tax(amount)
    amount * 0.1
  end
end
