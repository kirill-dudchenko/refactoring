require_relative 'autoload'

class Account
  include Validations
  include MainMenu
  include Messaging

  attr_accessor :login, :name, :card, :password, :file_path

  def initialize
    @bank = Bank.new
    @file_path = 'accounts.yml'
    @card = []
  end

  def console
    puts I18n.t(:console_welcome_prompt)
    case input
    when I18n.t(:create_command) then create
    when I18n.t(:load_command) then load
    else exit
    end
  end

  def create
    name_input
    age_input
    login_input
    password_input
    @bank.accounts << self
    @bank.current_account = self
    File.open(@file_path, 'w') { |f| f.write @bank.accounts.to_yaml }
    main_menu
  end

  def load
    return create_the_first_account unless @bank.accounts.any?

    check_credentials(get_login, get_password)
    main_menu
  end

  def check_credentials(login, password)
    if @bank.accounts.map do |account|
      { login: account.login, password: account.password }
    end.include?({ login: login, password: password })
      @bank.current_account = @bank.accounts.select { |account| login == account.login }.first
    else
      no_such_account
      load
    end
  end

  def create_the_first_account
    puts I18n.t(:create_first_account_prompt)
    input == 'y' ? create : console
  end

  def destroy_account
    destroy_double_check
    if input == 'y'
      @bank.accounts.delete(@bank.current_account)
      File.open(@file_path, 'w') { |f| f.write @bank.accounts.to_yaml }
    end
    exit
  end

  private

  def name_input
    name_prompt
    user_input = input
    validate_name(user_input)
    @name = user_input
  end

  def login_input
    login_prompt
    user_input = input
    validate_login(user_input)
    @login = user_input
  end

  def password_input
    password_prompt
    user_input = input
    validate_password(user_input)
    @password = user_input
  end

  def age_input
    age_prompt
    age = input.to_i
    validate_age(age)
    @age = age.to_i
  end
end
