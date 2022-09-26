class AccountsStore
  include Messaging

  def add_card(card)
    Bank.instance.accounts[Bank.instance.accounts.find_index(Bank.instance.current_account)].card << card
    save
  end

  def update_card(card, balance)
    card.balance = balance
    new_accounts = []
    Bank.instance.accounts.each do |account|
      account.login == Bank.instance.current_account.login ? new_accounts.push(Bank.instance.current_account) : new_accounts.push(account)
    end
    save
  end

  def destroy_card(account_to_delete)
    Bank.instance.accounts[Bank.instance.accounts.find_index(Bank.instance.current_account)].card.delete_at(account_to_delete.to_i - 1)
    save
  end

  def load_accounts
    Bank.instance.accounts = File.exist?('accounts.yml') ? YAML.load_file('accounts.yml') : []
  end

  def create_account(account)
    Bank.instance.accounts << account
    Bank.instance.current_account = account
    save
  end

  def destroy_account
    Bank.instance.accounts.delete(Bank.instance.current_account)
    save
  end

  def save
    File.open('accounts.yml', 'w') { |f| f.write Bank.instance.accounts.to_yaml }
  end
end
