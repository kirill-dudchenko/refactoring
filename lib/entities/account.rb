class Account
  include Messaging

  attr_accessor :name, :age, :login, :password, :card

  def initialize
    @name = ''
    @age = 0
    @login = ''
    @password = ''
    @card = []
  end
end
