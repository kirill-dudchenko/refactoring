module MainMenu
  def main_menu
    card = Card.new
    money = Money.new

    puts "\nWelcome, #{@bank.current_account.name}"
    puts I18n.t(:main_menu_message)

    case input
    when 'SC' then card.show_cards
    when 'CC' then card.create_card
    when 'DC' then card.destroy_card
    when 'PM' then money.put_money
    when 'WM' then money.withdraw_money
    when 'SM' then money.send_money
    when 'DA' then destroy_account
    when 'exit' then exit
    else puts "Wrong command. Try again!\n"
    end
  end
end
