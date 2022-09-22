class Account
  include Messaging
  include MainMenu

  attr_accessor :name, :age, :login, :password, :card

  def initialize
    @name = ''
    @age = 0
    @login = ''
    @password = ''
    @card = []
  end

  def create
    AccountProcessor.new.create
    main_menu
  end

  def load
    AccountProcessor.new.load
    main_menu
  end

  def show_cards
    Card.new.show_cards
  end

  def create_card
    Card.new.create_card
  end

  def destroy_card
    Card.new.destroy_card
  end

  def withdraw_money
    Money.new.withdraw_money
  end

  def send_money
    Money.new.send_money
  end

  def put_money
    Money.new.put_money
  end

  def destroy_account
    AccountsStore.new.destroy_account
  end
end
