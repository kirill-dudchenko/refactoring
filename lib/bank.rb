class Bank
  attr_accessor :accounts, :current_account

  def self.load_accounts
    @@accounts = File.exist?('accounts.yml') ? YAML.load_file('accounts.yml') : []
  end

  def self.add_account(account)
    @@accounts << account
  end

  def self.accounts
    @@accounts
  end

  def self.new_current_account(account)
    @@current_account = account
  end

  def self.current_account
    @@current_account
  end
end
