module SaveLoad
  def save
    File.open('accounts.yml', 'w') { |f| f.write Bank.instance.accounts.to_yaml }
  end

  def load_accounts
    Bank.instance.accounts = File.exist?('accounts.yml') ? YAML.load_file('accounts.yml') : []
  end
end
