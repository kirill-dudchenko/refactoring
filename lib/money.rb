class Money
  def withdraw_money
    puts 'Choose the card for withdrawing:'
    answer, a2, a3 = nil # answers for gets.chomp
    if @current_account.card.any?
      @current_account.card.each_with_index do |c, i|
        puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
      end
      puts "press `exit` to exit\n"
      loop do
        answer = gets.chomp
        break if answer == 'exit'

        if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i.positive?
          current_card = @current_account.card[answer&.to_i.to_i - 1]
          loop do
            puts 'Input the amount of money you want to withdraw'
            a2 = gets.chomp
            if a2&.to_i.to_i.positive?
              money_left = current_card[:balance] - a2&.to_i.to_i - withdraw_tax(current_card[:type],
                                                                                 current_card[:balance], current_card[:number], a2&.to_i.to_i)
              if money_left.positive?
                current_card[:balance] = money_left
                @current_account.card[answer&.to_i.to_i - 1] = current_card
                new_accounts = []
                accounts.each do |ac|
                  if ac.login == @current_account.login
                    new_accounts.push(@current_account)
                  else
                    new_accounts.push(ac)
                  end
                end
                File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } # Storing
                puts "Money #{a2&.to_i.to_i} withdrawed from #{current_card[:number]}$. Money left: #{current_card[:balance]}$. Tax: #{withdraw_tax(
                  current_card[:type], current_card[:balance], current_card[:number], a2&.to_i.to_i
                )}$"
              else
                puts "You don't have enough money on card for such operation"
              end
            else
              puts 'You must input correct amount of $'
            end
            return
          end
        else
          puts "You entered wrong number!\n"
          return
        end
      end
    else
      puts "There is no active cards!\n"
    end
  end

  def put_money
    puts 'Choose the card for putting:'
    if @current_account.card.any?
      @current_account.card.each_with_index do |c, i|
        puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
      end
      puts "press `exit` to exit\n"
      loop do
        answer = gets.chomp
        break if answer == 'exit'

        if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i.positive?
          current_card = @current_account.card[answer&.to_i.to_i - 1]
          loop do
            puts 'Input the amount of money you want to put on your card'
            a2 = gets.chomp
            if a2&.to_i.to_i.positive?
              if put_tax(current_card[:type], current_card[:balance], current_card[:number],
                         a2&.to_i.to_i) >= a2&.to_i.to_i
                puts 'Your tax is higher than input amount'
              else
                new_money_amount = current_card[:balance] + a2&.to_i.to_i - put_tax(current_card[:type],
                                                                                    current_card[:balance], current_card[:number], a2&.to_i.to_i)
                current_card[:balance] = new_money_amount
                @current_account.card[answer&.to_i.to_i - 1] = current_card
                new_accounts = []
                accounts.each do |ac|
                  if ac.login == @current_account.login
                    new_accounts.push(@current_account)
                  else
                    new_accounts.push(ac)
                  end
                end
                File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } # Storing
                puts "Money #{a2&.to_i.to_i} was put on #{current_card[:number]}. Balance: #{current_card[:balance]}. Tax: #{put_tax(
                  current_card[:type], current_card[:balance], current_card[:number], a2&.to_i.to_i
                )}"
              end
            else
              puts 'You must input correct amount of money'
            end
            return
          end
        else
          puts "You entered wrong number!\n"
          return
        end
      end
    else
      puts "There is no active cards!\n"
    end
  end

  def send_money
    puts 'Choose the card for sending:'
    if @current_account.card.any?
      @current_account.card.each_with_index do |c, i|
        puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
      end
      puts "press `exit` to exit\n"
      answer = gets.chomp
      exit if answer == 'exit'
      if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i.positive?
        sender_card = @current_account.card[answer&.to_i.to_i - 1]
      else
        puts 'Choose correct card'
        return
      end
    else
      puts "There is no active cards!\n"
      return
    end
    puts 'Enter the recipient card:'
    a2 = gets.chomp
    if a2.length > 15 && a2.length < 17
      all_cards = accounts.map(&:card).flatten
      if all_cards.select { |card| card[:number] == a2 }.any?
        recipient_card = all_cards.select { |card| card[:number] == a2 }.first
      else
        puts "There is no card with number #{a2}\n"
        return
      end
    else
      puts 'Please, input correct number of card'
      return
    end
    loop do
      puts 'Input the amount of money you want to withdraw'
      a3 = gets.chomp
      if a3&.to_i.to_i.positive?
        sender_balance = sender_card[:balance] - a3&.to_i.to_i - sender_tax(sender_card[:type], a3&.to_i.to_i)
        recipient_balance = recipient_card[:balance] + a3&.to_i.to_i - put_tax(recipient_card[:type],
                                                                               recipient_card[:balance], recipient_card[:number], a3&.to_i.to_i)
        if sender_balance.negative?
          puts "You don't have enough money on card for such operation"
        elsif put_tax(recipient_card[:type], recipient_card[:balance], recipient_card[:number],
                      a3&.to_i.to_i) >= a3&.to_i.to_i
          puts 'There is no enough money on sender card'
        else
          sender_card[:balance] = sender_balance
          @current_account.card[answer&.to_i.to_i - 1] = sender_card
          new_accounts = []
          accounts.each do |ac|
            if ac.login == @current_account.login
              new_accounts.push(@current_account)
            elsif ac.card.map { |card| card[:number] }.include? a2
              recipient = ac
              new_recipient_cards = []
              recipient.card.each do |card|
                card[:balance] = recipient_balance if card[:number] == a2
                new_recipient_cards.push(card)
              end
              recipient.card = new_recipient_cards
              new_accounts.push(recipient)
            end
          end
          File.open('accounts.yml', 'w') { |f| f.write new_accounts.to_yaml } # Storing
          puts "Money #{a3&.to_i.to_i}$ was put on #{sender_card[:number]}. Balance: #{recipient_balance}. Tax: #{put_tax(
            sender_card[:type], sender_card[:balance], sender_card[:number], a3&.to_i.to_i
          )}$\n"
          puts "Money #{a3&.to_i.to_i}$ was put on #{a2}. Balance: #{sender_balance}. Tax: #{sender_tax(
            sender_card[:type], a3&.to_i.to_i
          )}$\n"
          break
        end
      else
        puts 'You entered wrong number!\n'
      end
    end
  end

  private

  def withdraw_tax(type, _balance, _number, amount)
    case type
    when 'usual'
      return amount * 0.05
    when 'capitalist'
      return amount * 0.04
    when 'virtual'
      return amount * 0.88
    end

    0
  end

  def put_tax(type, _balance, _number, amount)
    case type
    when 'usual'
      return amount * 0.02
    when 'capitalist'
      return 10
    when 'virtual'
      return 1
    end

    0
  end

  def sender_tax(type, amount)
    case type
    when 'usual' then 20
    when 'capitalist' then amount * 0.1
    when 'virtual' then 1
    else 0
    end
  end
end
