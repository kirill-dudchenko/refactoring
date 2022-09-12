class Money
  include Validations
  include Messaging

  def initialize
    @file_path = 'accounts.yml'
  end

  def withdraw_money
    select_card('withdraw')
    input_withdraw_amount
    answer = input
    validate_amount(answer)
    money_left = calculate_money_left(answer)
    validate_sufficient_funds(money_left)
    @current_card[:balance] = money_left
    withdraw_save_and_output(answer)
  end

  def put_money
    select_card('put')
    puts 'Input the amount of money you want to put on your card'
    answer = input
    validate_put_money(answer)
    new_money_amount = @current_card[:balance] + answer.to_i - put_tax(@current_card[:type], answer.to_i)
    @current_card[:balance] = new_money_amount
    put_save_and_output(answer)
  end

  def send_money
    sender_card = choose_sender
    recipient_card = choose_recipient
    input_money_to_send
    answer = input
    sender_balance = sender_card[:balance] - answer.to_i - sender_tax(sender_card[:type], answer.to_i)
    recipient_balance = recipient_card[:balance] + answer.to_i - put_tax(recipient_card[:type], answer.to_i)
    validate_sender_balance(answer, sender_balance, recipient_card)
    sender_card[:balance] = sender_balance
    recipient_card[:balance] = recipient_balance
    update_after_sending(answer, sender_card, sender_balance, recipient_balance)
  end

  private

  def update_after_sending(answer, sender_card, sender_balance, recipient_balance)
    File.open('accounts.yml', 'w') { |f| f.write Bank.accounts.to_yaml } # Storing
    puts "Money #{answer.to_i}$ was put on #{sender_card[:number]}. Balance: #{recipient_balance}. Tax: #{put_tax(
      sender_card[:type], answer.to_i
    )}$\n"
    puts "Money #{answer.to_i}$ was put on #{@recipient}. Balance: #{sender_balance}. Tax: #{sender_tax(
      sender_card[:type], answer.to_i
    )}$\n"
  end

  def validate_sender_balance(answer, sender_balance, recipient_card)
    validate_number(answer)
    validate_sufficient_funds(sender_balance)
    raise('There is no enough money on sender card') if put_tax(recipient_card[:type], answer.to_i) >= answer.to_i
  end

  def choose_sender
    choose_card('sender')
    validate_existence_of_cards
    Bank.current_account.card.each_with_index do |card, index|
      puts "- #{card[:number]}, #{card[:type]}, press #{index + 1}"
    end
    exit_prompt
    answer = input
    validate_sender(answer)
    Bank.current_account.card[answer.to_i - 1]
  end

  def choose_recipient
    choose_card('recipient')
    @recipient = input
    validate_recipient(@recipient)
    validate_recipient_card(@recipient)
    Bank.accounts.map(&:card).flatten.select { |card| card[:number] == @recipient }.first
  end

  def input
    user_input = gets.chomp
    exit! if user_input == 'exit'
    user_input
  end

  def select_card(method)
    choose_card(method)
    validate_existence_of_cards
    Bank.current_account.card.each_with_index do |card, index|
      puts "- #{card[:number]}, #{card[:type]}, press #{index + 1}"
    end
    exit_prompt
    answer = input
    validate_card_input(answer)
    @current_card = Bank.current_account.card[answer.to_i - 1]
  end

  def withdraw_save_and_output(answer)
    new_accounts = []
    Bank.accounts.each do |ac|
      ac.login == Bank.current_account.login ? new_accounts.push(Bank.current_account) : new_accounts.push(ac)
    end
    File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } # Storing
    puts "Money #{answer.to_i} withdrawed from #{@current_card[:number]}$. Money left:
    #{@current_card[:balance]}$. Tax: #{withdraw_tax(@current_card[:type], answer.to_i)}$"
  end

  def put_save_and_output(answer)
    new_accounts = []
    Bank.accounts.each do |ac|
      ac.login == Bank.current_account.login ? new_accounts.push(Bank.current_account) : new_accounts.push(ac)
    end
    File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } # Storing
    puts "Money #{answer.to_i} was put on #{@current_card[:number]}. Balance: #{@current_card[:balance]}. Tax:
    #{put_tax(@current_card[:type], answer.to_i)}"
  end

  def calculate_money_left(input)
    @current_card[:balance] - input.to_i - withdraw_tax(@current_card[:type], input.to_i)
  end

  def validate_put_money(answer)
    validate_sufficient_funds(answer)
    validate_put_tax(answer)
  end

  def withdraw_tax(type, amount)
    case type
    when 'usual' then amount * 0.05
    when 'capitalist' then amount * 0.04
    when 'virtual' then amount * 0.88
    else 0
    end
  end

  def put_tax(type, amount)
    case type
    when 'usual' then amount * 0.02
    when 'capitalist' then 10
    when 'virtual' then 1
    else 0
    end
  end

  def sender_tax(type, amount)
    case type
    when 'usual' then 20
    when 'capitalist' then amount * 0.1
    when 'virtual' then 1
    else 0
    end
  end
end
