RSpec.describe MainMenu do
  MAIN_OPERATIONS_TEXTS = [
    'If you want to:',
    '- show all cards - press SC',
    '- create card - press CC',
    '- destroy card - press DC',
    '- put money on card - press PM',
    '- withdraw money on card - press WM',
    '- send money to another card  - press SM',
    '- destroy account - press `DA`',
    '- exit from account - press `exit`'
  ].freeze

  ERROR_PHRASES = {
    user_not_exists: 'There is no account with given credentials',
    wrong_command: 'Wrong command. Try again!',
    no_active_cards: "There is no active cards!\n",
    wrong_card_type: "Wrong card type. Try again!\n",
    wrong_number: "You entered wrong number!\n",
    correct_amount: 'You must input correct amount of money',
    tax_higher: 'Your tax is higher than input amount'
  }.freeze

  let(:current_subject) { Account.new }
  let(:card) { Card.new }
  let(:money) { Money.new }

  describe '#main_menu' do
    let(:commands) do
      {
        'SC' => :show_cards,
        'CC' => :create_card,
        'DC' => :destroy_card,
        'PM' => :put_money,
        'WM' => :withdraw_money,
        'SM' => :send_money,
        'DA' => :destroy_account,
        'exit' => :exit
      }
    end

    context 'with correct outout' do
      it do
        current_subject.name = 'John'
        Bank.instance.current_account = current_subject
        allow(card).to receive(:show_cards)
        allow(current_subject).to receive(:exit)
        allow(card).to receive_message_chain(:gets, :chomp).and_return('SC', 'exit')
        expect { current_subject.main_menu }.to output(/Welcome, #{current_subject.name}/).to_stdout
        MAIN_OPERATIONS_TEXTS.each do |text|
          allow(card).to receive_message_chain(:gets, :chomp).and_return('SC', 'exit')
          expect { current_subject.main_menu }.to output(/#{text}/).to_stdout
        end
      end
    end

    context 'when commands used' do
      let(:undefined_command) { 'undefined' }

      it 'calls specific methods on predefined commands' do
        allow(current_subject).to receive(:exit)
        current_subject.name = 'John'
        Bank.instance.current_account = current_subject
        commands.each do |command, method_name|
          expect(current_subject).to receive(method_name)
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(command, 'exit')
          current_subject.main_menu
        end
      end

      it 'outputs incorrect message on undefined command' do
        current_subject.name = 'John'
        Bank.instance.current_account = current_subject
        expect(current_subject).to receive(:exit)
        allow(current_subject).to receive(:input).and_return(undefined_command, 'exit')
        expect { current_subject.main_menu }.to output(/#{ERROR_PHRASES[:wrong_command]}/).to_stdout
      end
    end
  end
end
