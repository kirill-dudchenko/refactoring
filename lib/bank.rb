class Bank
  attr_accessor :accounts, :current_account

  def initialize
    @accounts = File.exist?('accounts.yml') ? YAML.load_file('accounts.yml') : []
    @current_account
  end
end
