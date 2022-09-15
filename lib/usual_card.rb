class UsualCard < Card
  attr_accessor :balance
  attr_reader :type, :number

  def initialize
    super
    @type = 'usual'
    @number = 16.times.map { rand(10) }.join
    @balance = 50.00
  end

  def withdraw_tax(amount)
    amount * 0.05
  end

  def put_tax(amount)
    amount * 0.02
  end

  def sender_tax(_amount)
    20
  end
end
