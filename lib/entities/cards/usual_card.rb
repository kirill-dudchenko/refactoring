class UsualCard < Card
  def initialize
    super
    @type = 'usual'
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
