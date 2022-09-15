require 'i18n'

module Messaging
  I18n.load_path << Dir["#{File.expand_path('./lib/locale')}/*.yml"]
  I18n.config.available_locales = :en

  def input
    user_input = gets
    user_input ||= ''
    user_input.chomp!
  end

  def console_welcome_prompt
    puts I18n.t(:console_welcome_prompt)
  end

  def welcome_message
    puts I18n.t(:welcome)
  end

  def input_login
    puts I18n.t(:enter_login)
    input
  end

  def input_password
    puts I18n.t(:enter_password)
    input
  end

  def wrong_command
    puts I18n.t(:wrong_command)
  end

  def no_such_account
    puts I18n.t(:no_such_account)
  end

  def destroy_double_check
    puts I18n.t(:destroy_double_check)
  end

  def name_prompt
    puts I18n.t(:name_prompt)
  end

  def login_prompt
    puts I18n.t(:login_prompt)
  end

  def password_prompt
    puts I18n.t(:password_prompt)
  end

  def age_prompt
    puts I18n.t(:age_prompt)
  end

  def no_active_cards
    puts I18n.t(:no_active_cards)
    exit!
  end

  def wrong_card_type
    puts I18n.t(:wrong_card_type)
  end

  def choose_card(method)
    case method
    when 'withdraw' then puts I18n.t(:choose_card_withdraw)
    when 'put' then puts I18n.t(:choose_card_put)
    when 'sender' then puts I18n.t(:choose_card_sender)
    when 'recipient' then puts I18n.t(:choose_card_recipient)
    end
  end

  def input_withdraw_amount
    puts I18n.t(:input_withdraw_amount)
  end

  def exit_prompt
    puts I18n.t(:exit_prompt)
  end

  def input_money_to_send
    puts I18n.t(:input_money_to_send)
  end

  def wrong_number
    puts I18n.t(:wrong_number)
  end
end
