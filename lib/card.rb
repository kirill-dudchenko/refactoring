class Card
  include Validations

  def initialize
    @file_path = 'accounts.yml'
  end

  def create_card
    puts I18n.t(:create_card_prompt)
    card = card_type
    Bank.accounts[Bank.accounts.find_index(Bank.current_account)].card << card
    File.open(@file_path, 'w') { |f| f.write Bank.accounts.to_yaml } # Storing
  end

  def destroy_card
    no_active_cards unless Bank.current_account.card.any?
    cards_to_delete
    answer = input
    if answer.to_i <= Bank.current_account.card.length && answer.to_i.positive?
      puts "Are you sure you want to delete #{Bank.current_account.card[answer.to_i - 1][:number]}?[y/n]"
      input == 'y' ? delete_card_and_update(answer) : return
    else
      wrong_number
      destroy_card
    end
  end

  def show_cards
    if Bank.current_account.card.any?
      Bank.current_account.card.each do |c|
        puts "- #{c[:number]}, #{c[:type]}"
      end
    else
      puts "There is no active cards!\n"
    end
  end

  private

  def input
    user_input = gets.chomp
    exit! if user_input == 'exit'
    user_input
  end

  def delete_card_and_update(answer)
    Bank.accounts[Bank.accounts.find_index(Bank.current_account)].card.delete_at(answer.to_i - 1)
    File.open(@file_path, 'w') { |f| f.write Bank.accounts.to_yaml }
  end

  def no_active_cards
    puts "There is no active cards!\n"
    exit!
  end

  def cards_to_delete
    puts 'If you want to delete:'
    Bank.current_account.card.each_with_index do |card, index|
      puts "- #{card[:number]}, #{card[:type]}, press #{index + 1}"
    end
    puts "press `exit` to exit\n"
  end

  def card_type
    card_type = gets.chomp
    validate_card_type(card_type)
    case card_type
    when 'usual' then { type: 'usual', number: 16.times.map { rand(10) }.join, balance: 50.00 }
    when 'capitalist' then { type: 'capitalist', number: 16.times.map { rand(10) }.join, balance: 100.00 }
    when 'virtual' then { type: 'virtual', number: 16.times.map { rand(10) }.join, balance: 150.00 }
    end
  end
end
