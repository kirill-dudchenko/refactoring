class Money
  include SaveLoad
  include Messaging
  include Validations

  def withdraw_money
    select_card('withdraw')
    input_withdraw_amount
    answer = input
    validate_amount(answer)
    money_left = calculate_money_left(answer)
    validate_sufficient_funds(money_left)
    @current_card.balance = money_left
    withdraw_save_and_output(answer)
  end

  def put_money
    select_card('put')
    puts 'Input the amount of money you want to put on your card'
    answer = input
    validate_put_money(answer)
    new_money_amount = @current_card.balance + answer.to_i - @current_card.put_tax(answer.to_i)
    @current_card.balance = new_money_amount
    put_save_and_output(answer)
  end

  def send_money
    sender_card = choose_sender
    recipient_card = choose_recipient
    input_money_to_send
    answer = input
    sender_balance = sender_card.balance - answer.to_i - sender_card.sender_tax(answer.to_i)
    recipient_balance = recipient_card.balance + answer.to_i - recipient_card.put_tax(answer.to_i)
    validate_sender_balance(answer, sender_balance, recipient_card)
    sender_card.balance = sender_balance
    recipient_card.balance = recipient_balance
    update_after_sending(answer, sender_card, sender_balance, recipient_balance)
  end

  private

  def update_after_sending(answer, sender_card, sender_balance, recipient_balance)
    save
    puts "Money #{answer.to_i}$ was put on #{sender_card.number}. Balance: #{recipient_balance}. Tax: #{sender_card.put_tax(answer.to_i)}$\n"
    puts "Money #{answer.to_i}$ was put on #{@recipient}. Balance: #{sender_balance}. Tax: #{sender_card.sender_tax(answer.to_i)}$\n"
  end

  def choose_sender
    choose_card('sender')
    validate_existence_of_cards
    Bank.instance.current_account.card.each_with_index do |card, index|
      puts "- #{card.number}, #{card.type}, press #{index + 1}"
    end
    exit_prompt
    answer = input
    validate_sender(answer)
    Bank.instance.current_account.card[answer.to_i - 1]
  end

  def choose_recipient
    choose_card('recipient')
    @recipient = input
    validate_recipient(@recipient)
    validate_recipient_card(@recipient)
    Bank.instance.accounts.map(&:card).flatten.select { |card| card.number == @recipient }.first
  end

  def select_card(method)
    choose_card(method)
    validate_existence_of_cards
    Bank.instance.current_account.card.each_with_index do |card, index|
      puts "- #{card.number}, #{card.type}, press #{index + 1}"
    end
    exit_prompt
    answer = input
    validate_card_input(answer)
    @current_card = Bank.instance.current_account.card[answer.to_i - 1]
  end

  def withdraw_save_and_output(answer)
    new_accounts = []
    Bank.instance.accounts.each do |ac|
      ac.login == Bank.instance.current_account.login ? new_accounts.push(Bank.instance.current_account) : new_accounts.push(ac)
    end
    save
    puts "Money #{answer.to_i} withdrawed from #{@current_card.number}$. Money left:
    #{@current_card.balance}$. Tax: #{@current_card.withdraw_tax(answer.to_i)}$"
  end

  def put_save_and_output(answer)
    new_accounts = []
    Bank.instance.accounts.each do |ac|
      ac.login == Bank.instance.current_account.login ? new_accounts.push(Bank.instance.current_account) : new_accounts.push(ac)
    end
    save
    puts "Money #{answer.to_i} was put on #{@current_card.number}. Balance: #{@current_card.balance}. Tax: #{@current_card.put_tax(answer.to_i)}"
  end

  def calculate_money_left(input)
    @current_card.balance - input.to_i - @current_card.withdraw_tax(input.to_i)
  end

  def validate_sender_balance(answer, sender_balance, recipient_card)
    validate_number(answer)
    validate_sufficient_funds(sender_balance)
    raise('There is no enough money on sender card') if recipient_card.put_tax(answer.to_i) >= answer.to_i
  end

  def validate_put_money(answer)
    validate_sufficient_funds(answer)
    validate_put_tax(answer)
  end

  def validate_sender(answer)
    unless answer.to_i <= Bank.instance.current_account.card.length && answer.to_i.positive?
      raise(I18n.t(:wrong_sender))
    end
  end

  def validate_recipient(answer)
    validate_length_exactly(answer, I18n.t(:wrong_recipient), 16)
  end

  def validate_recipient_card(answer)
    raise("There is no card with number #{answer}\n") unless Bank.instance.accounts.map(&:card).flatten.select do |card|
                                                               card.number == answer
                                                             end.any?
  end

  def validate_amount(answer)
    validate_positive(answer, I18n.t(:incorrect_amount))
  end

  def validate_number(answer)
    validate_positive(answer, I18n.t(:wrong_number))
  end

  def validate_sufficient_funds(money_left)
    validate_positive(money_left, I18n.t(:insufficient_funds))
  end

  def validate_put_tax(answer)
    raise(I18n.t(:tax_higher_than_input)) if @current_card.put_tax(answer.to_i) >= answer.to_i
  end

  def validate_existence_of_cards
    raise(I18n.t(:no_active_cards)) unless Bank.instance.current_account.card.any?
  end

  def validate_card_input(answer)
    unless answer.to_i <= Bank.instance.current_account.card.length && answer.to_i.positive?
      raise(I18n.t(:wrong_number))
    end
  end
end
