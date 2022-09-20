class Card
  include Validations
  include Messaging

  attr_accessor :balance
  attr_reader :type, :number

  # CARD_TYPES = {
  #   'usual' => UsualCard,
  #   'virtual' => VirtualCard,
  #   'capitalist' => CapitalistCard
  # }.freeze

  def initialize
    @number = 16.times.map { rand(10) }.join
  end

  def create_card
    puts I18n.t(:create_card_prompt)
    card = card_type
    AccountsStore.new.add_card(card)
  end

  # def create_card(card_type)
  #   raise CardError, I18n unless CARD_TYPES.keys.include?(card_type)

  #   puts I18n.t(:create_card_prompt)
  #   new_card = CARDS[card_type].new
  #   cards.nil? ? @cards = [new_card] : @cards << new_card
  #   AccountsStore.new.update_account(self)
  # end

  def destroy_card
    return no_active_cards unless Bank.instance.current_account.card.any?

    answer = cards_to_delete
    input == 'y' ? AccountsStore.new.destroy_card(answer) : return
  end

  def show_cards
    cards = Bank.instance.current_account.card
    cards.empty? ? no_active_cards : cards.each { |card| puts "- #{card.number}, #{card.type}" }
  end

  private

  def cards_to_delete
    puts 'If you want to delete:'
    Bank.instance.current_account.card.each_with_index do |card, index|
      puts "- #{card.number}, #{card.type}, press #{index + 1}"
    end
    puts "press `exit` to exit\n"
    answer = input
    validate_card_input(answer)
    puts "Are you sure you want to delete #{Bank.instance.current_account.card[answer.to_i - 1].number}?[y/n]"
    answer
  end

  def card_type
    card_type = gets.chomp
    validate_card_type(card_type)
    case card_type
    when 'usual' then UsualCard.new
    when 'capitalist' then CapitalistCard.new
    when 'virtual' then VirtualCard.new
    end
  end

  def validate_card_type(card_type)
    raise(I18n.t(:wrong_card_type)) unless %w[usual capitalist virtual].include?(card_type)
  end

  def validate_card_input(answer)
    unless answer.to_i <= Bank.instance.current_account.card.length && answer.to_i.positive?
      raise(I18n.t(:wrong_number))
    end
  end
end
