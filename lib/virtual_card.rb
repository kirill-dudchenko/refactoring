class VirtualsCard < Card
  attr_accessor :balance
  attr_reader :type, :number

  def initialize
    super
    @type = 'virtual'
    @number = 16.times.map { rand(10) }.join
    @balance = 150.00
  end

  def withdraw_tax(amount)
    amount * 0.88
  end

  def put_tax(_amount)
    1
  end

  def sender_tax(_amount)
    1
  end
end
