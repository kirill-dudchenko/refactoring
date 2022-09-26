class MainProcessor
  include Messaging
  include MainMenu

  def call
    AccountsStore.new.load_accounts
    console
    main_menu
  end

  def console
    puts I18n.t(:console_welcome_prompt)
    case input
    when I18n.t(:create_command) then AccountProcessor.new.create
    when I18n.t(:load_command) then AccountProcessor.new.load
    else exit
    end
  end
end
