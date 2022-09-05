class Card
  def create_card
    puts I18n.t(:create_card_prompt)
    card_type = gets.chomp
    if %w[usual capitalist virtual].include?(card_type)
      case card_type
      when 'usual' then card = { type: 'usual', number: 16.times.map { rand(10) }.join, balance: 50.00 }
      when 'capitalist' then card = { type: 'capitalist', number: 16.times.map { rand(10) }.join, balance: 100.00 }
      when 'virtual' then card = { type: 'virtual', number: 16.times.map { rand(10) }.join, balance: 150.00 }
      end
      @bank.current_account.card << card
      new_accounts = []
      accounts.each do |ac|
        if ac.login == @bank.current_account.login
          new_accounts.push(@bank.current_account)
        else
          new_accounts.push(ac)
        end
      end
      File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } # Storing
    else
      puts "Wrong card type. Try again!\n"
    end
  end

  def destroy_card
    loop do
      if @bank.current_account.card.any?
        puts 'If you want to delete:'
        @bank.current_account.card.each_with_index do |c, i|
          puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}"
        end
        puts "press `exit` to exit\n"
        answer = gets.chomp
        break if answer == 'exit'

        if answer&.to_i.to_i <= @bank.current_account.card.length && answer&.to_i.to_i.positive?
          puts "Are you sure you want to delete #{@bank.current_account.card[answer&.to_i.to_i - 1][:number]}?[y/n]"
          a2 = gets.chomp
          if a2 == 'y'
            @bank.current_account.card.delete_at(answer&.to_i.to_i - 1)
            new_accounts = []
            accounts.each do |ac|
              if ac.login == @bank.current_account.login
                new_accounts.push(@bank.current_account)
              else
                new_accounts.push(ac)
              end
            end
            File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } # Storing
            break
          else
            return
          end
        else
          puts "You entered wrong number!\n"
        end
      else
        puts "There is no active cards!\n"
        break
      end
    end
  end

  def show_cards
    if @bank.current_account.card.any?
      @bank.current_account.card.each do |c|
        puts "- #{c[:number]}, #{c[:type]}"
      end
    else
      puts "There is no active cards!\n"
    end
  end
end
