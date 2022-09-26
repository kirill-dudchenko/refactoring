module MainMenu
  def main_menu
    puts "\nWelcome, #{Bank.instance.current_account.name}"
    puts I18n.t(:main_menu_message)

    enter_command
  end

  def enter_command
    case input
    when 'SC' then CardProcessor.new.show_cards
    when 'CC' then CardProcessor.new.create_card
    when 'DC' then CardProcessor.new.destroy_card
    when 'PM' then MoneyProcessor.new.put_money
    when 'WM' then MoneyProcessor.new.withdraw_money
    when 'SM' then MoneyProcessor.new.send_money
    when 'DA' then AccountProcessor.new.destroy_account
    when 'exit' then exit
    else enter_command_retry
    end
  end

  def enter_command_retry
    wrong_command
    enter_command
  end
end
