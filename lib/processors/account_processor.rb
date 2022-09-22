class AccountProcessor
  include Messaging
  include Validations

  def create
    account = Account.new
    account.name = name_input
    account.age = age_input
    account.login = login_input
    account.password = password_input
    AccountsStore.new.create_account(account)
  end

  def load
    return create_the_first_account unless Bank.instance.accounts.any?

    check_credentials(input_login, input_password)
  end

  private

  def name_input
    name_prompt
    user_input = input
    validate_name(user_input)
    user_input
  end

  def login_input
    login_prompt
    user_input = input
    validate_login(user_input)
    user_input
  end

  def password_input
    password_prompt
    user_input = input
    validate_password(user_input)
    user_input
  end

  def age_input
    age_prompt
    age = input.to_i
    validate_age(age)
    age.to_i
  end

  def check_credentials(login, password)
    validate_credentials(login, password)
    Bank.instance.current_account = Bank.instance.accounts.select { |account| login == account.login }.first
  end

  def create_the_first_account
    puts I18n.t(:create_first_account_prompt)
    input == 'y' ? create : console
  end

  def validate_name(name)
    validate_non_empty(name, I18n.t(:name_empty_error))
    validate_capital_letter(name, I18n.t(:capital_error))
  end

  def validate_login(login)
    validate_non_empty(login, I18n.t(:login_empty_error))
    validate_length_less(login, I18n.t(:short_login_error), 4)
    validate_length_more(login, I18n.t(:long_login_error), 20)
    raise(I18n.t(:account_exists_error)) if !Bank.instance.accounts.empty? && (Bank.instance.accounts.map do |account|
                                                                               end.include? login)
  end

  def validate_password(password)
    validate_non_empty(password, I18n.t(:password_empty_error))
    validate_length_less(password, I18n.t(:short_password_error), 6)
    validate_length_more(password, I18n.t(:long_password_error), 30)
  end

  def validate_age(age)
    validate_is_integer(age, I18n.t(:integer_error))
    validate_integer_less(age, I18n.t(:young_age_error), 23)
    validate_integer_more(age, I18n.t(:old_age_error), 90)
  end

  def validate_credentials(login, password)
    unless Bank.instance.accounts.map do |account|
      { login: account.login, password: account.password }
    end.include?({ login: login, password: password })
      no_such_account
      load
    end
  end
end
