class Card
  include SaveLoad
  include Validations
  include Messaging

  def initialize
    @file_path = 'accounts.yml'
  end

  def create_card
    puts I18n.t(:create_card_prompt)
    card = card_type
    Bank.instance.accounts[Bank.instance.accounts.find_index(Bank.instance.current_account)].card << card
    save
  end

  def destroy_card
    return no_active_cards unless Bank.instance.current_account.card.any?

    cards_to_delete
    answer = input
    if answer.to_i <= Bank.instance.current_account.card.length && answer.to_i.positive?
      puts "Are you sure you want to delete #{Bank.instance.current_account.card[answer.to_i - 1].number}?[y/n]"
      input == 'y' ? delete_card_and_update(answer) : return
    else
      wrong_number
      destroy_card
    end
  end

  def show_cards
    cards = Bank.instance.current_account.card
    cards.empty? ? no_active_cards : cards.each { |card| puts "- #{card.number}, #{card.type}" }
  end

  private

  def delete_card_and_update(answer)
    Bank.instance.accounts[Bank.instance.accounts.find_index(Bank.instance.current_account)].card.delete_at(answer.to_i - 1)
    save
  end

  def cards_to_delete
    puts 'If you want to delete:'
    Bank.instance.current_account.card.each_with_index do |card, index|
      puts "- #{card.number}, #{card.type}, press #{index + 1}"
    end
    puts "press `exit` to exit\n"
  end

  def card_type
    card_type = gets.chomp
    validate_card_type(card_type)
    case card_type
    when 'usual' then UsualCard.new
    when 'capitalist' then CapitalistCard.new
    when 'virtual' then VirtualsCard.new
    end
  end

  def validate_card_type(card_type)
    raise(I18n.t(:wrong_card_type)) unless %w[usual capitalist virtual].include?(card_type)
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
