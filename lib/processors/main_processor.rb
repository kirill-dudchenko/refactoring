class MainProcessor
  include Messaging

  def initialize
    AccountsStore.new.load_accounts
    @account = Account.new
  end

  def console
    puts Bank.instance.accounts
    puts I18n.t(:console_welcome_prompt)
    case input
    when I18n.t(:create_command) then @account.create
    when I18n.t(:load_command) then @account.load
    else exit
    end
  end
end
