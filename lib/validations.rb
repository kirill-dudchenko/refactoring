module Validations
  def validate_name(name)
    raise('Your name must not be empty') if name.empty?
    raise('Your name must start with a capital letter') if name[0].upcase != name[0]
  end

  def validate_login(login)
    raise('Login must present') if login.empty?
    raise('Login must be longer then 4 symbols') if login.length < 4
    raise('Login must be shorter then 20 symbols') if login.length > 20

    raise('Such account is already exists') if !Bank.accounts.empty? && (Bank.accounts.map { |account| }.include? login)
  end

  def validate_password(password)
    raise('Password must be present') if password.empty?
    raise('Password must be longer then 6 symbols') if password.length <= 6
    raise('Password must be shorter then 30 symbols') if password.length > 30
  end

  def validate_age(age)
    raise('Your Age must be Integer') unless age.is_a?(Integer)
    raise('Your Age must be greater than 22') if age < 23
    raise('Your Age must be less than 91') if age >= 90
  end

  def validate_card_type(card_type)
    raise(I18n.t(:wrong_card_type)) unless %w[usual capitalist virtual].include?(card_type)
  end

  def validate_existence_of_cards
    raise(I18n.t(:no_active_cards)) unless Bank.current_account.card.any?
  end

  def validate_card_input(answer)
    raise(I18n.t(:wrong_number)) unless answer.to_i <= Bank.current_account.card.length && answer.to_i.positive?
  end

  def validate_sender(answer)
    raise(I18n.t(:wrong_sender)) unless answer.to_i <= Bank.current_account.card.length && answer.to_i.positive?
  end

  def validate_recipient(answer)
    raise(I18n.t(:wrong_recipient)) unless answer.length == 16
  end

  def validate_recipient_card(answer)
    raise("There is no card with number #{answer}\n") unless Bank.accounts.map(&:card).flatten.select do |card|
                                                               card[:number] == answer
                                                             end.any?
  end

  def validate_amount(answer)
    raise(I18n.t(:incorrect_amount)) unless answer.to_i.positive?
  end

  def validate_number(answer)
    raise(I18n.t(:wrong_number)) unless answer.to_i.positive?
  end

  def validate_sufficient_funds(money_left)
    raise(I18n.t(:insufficient_funds)) unless money_left.to_i.positive?
  end

  def validate_put_tax(answer)
    raise('Your tax is higher than input amount') if put_tax(@current_card[:type], answer.to_i) >= answer.to_i
  end
end
