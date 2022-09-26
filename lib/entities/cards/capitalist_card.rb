class CapitalistCard < Card
  def initialize
    super
    @type = 'capitalist'
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
