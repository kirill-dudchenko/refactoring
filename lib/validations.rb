module Validations
  def validate_name(name)
    raise('Your name must not be empty') if name.empty?
    raise('Your name must start with a capital letter') if name[0].upcase != name[0]
  end

  def validate_login(login)
    raise('Login must present') if login.empty?
    raise('Login must be longer then 4 symbols') if login.length < 4
    raise('Login must be shorter then 20 symbols') if login.length > 20
    raise('Such account is already exists') if @bank.accounts.map(&:login).include? login
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
end
