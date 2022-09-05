require 'i18n'

module Messaging
  I18n.load_path << Dir["#{File.expand_path('./lib/locale')}/*.yml"]
  I18n.config.available_locales = :en

  def input
    user_input = gets.chomp.strip
  end

  def console_welcome_prompt
    puts I18n.t(:console_welcome_prompt)
  end

  def welcome_message
    puts I18n.t(:welcome)
  end

  def get_login
    puts I18n.t(:enter_login)
    login = input
  end

  def get_password
    puts I18n.t(:enter_password)
    password = input
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

  def name_prompt
    puts I18n.t(:password_prompt)
  end

  def age_prompt
    puts I18n.t(:age_prompt)
  end
end
