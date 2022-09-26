class Bank
  include Singleton

  attr_accessor :accounts, :current_account
end
