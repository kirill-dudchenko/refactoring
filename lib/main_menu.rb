module MainMenu
  def main_menu
    puts "\nWelcome, #{Bank.instance.current_account.name}"
    puts I18n.t(:main_menu_message)

    enter_command
  end

  def enter_command
    case input
    when 'SC' then show_cards
    when 'CC' then create_card
    when 'DC' then destroy_card
    when 'PM' then put_money
    when 'WM' then withdraw_money
    when 'SM' then send_money
    when 'DA' then destroy_account
    when 'exit' then exit
    else enter_command_retry
    end
  end

  def enter_command_retry
    wrong_command
    enter_command
  end
end
