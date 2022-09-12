module MainMenu
  def main_menu
    puts "\nWelcome, #{Bank.current_account.name}"
    puts I18n.t(:main_menu_message)

    enter_command
  end

  def enter_command
    card = Card.new
    money = Money.new

    case input
    when 'SC' then card.show_cards
    when 'CC' then card.create_card
    when 'DC' then card.destroy_card
    when 'PM' then money.put_money
    when 'WM' then money.withdraw_money
    when 'SM' then money.send_money
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
