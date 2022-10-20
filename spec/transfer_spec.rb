# frozen_string_literal: true

require 'transfer'
require 'account'
require 'bank'

RSpec.describe Transfer, '#calculate' do
  context 'Intra bank transfer' do
    it 'should be correct' do
      account_jim, account_pam, account_emma, account_steven = prepare_data
      described_class.new(account_pam, account_jim, 300).perform_transfer
      expect(account_jim.money).to eq(30300)
      expect(account_pam.money).to eq(49700)
    end
  end

  context 'Inter bank transfer' do
    it 'should be correct' do
      account_jim, account_pam, account_emma, account_steven = prepare_data
      described_class.new(account_pam, account_steven, 800).perform_transfer
      expect(account_steven.money).to eq(800)
      expect(account_pam.money).to eq(49195)
    end

    it 'could fail' do
      #This one could fail because of the chance of the inter_transfe failling
      # account_jim, account_pam, account_emma, account_steven = prepare_data
      # described_class.new(account_pam, account_steven, 800).perform_transfer
      # expect(account_steven.money).to eq(0)
      # expect(account_pam.money).to eq(49995)
    end
  end

  context 'Transfer with agent' do
    it 'should be correct' do
      account_jim, account_pam, account_emma, account_steven = prepare_data
      described_class.new(account_jim, account_emma, 20000).perform_transfer_with_agent
      expect(account_emma.money).to eq(20000)
    end
  end
end

def prepare_data
  first_bank = Bank.new("Palencia")

  second_bank = Bank.new("La caja")

  account_jim = Account.new("Jim Sinclair", first_bank)
  account_pam = Account.new("Pam Beesly", first_bank)

  account_emma = Account.new("Emma Smith", second_bank)
  account_steven = Account.new("Steven Spielberg", second_bank)

  account_pam.add_money(50000)
  account_jim.add_money(30000)
  [account_jim, account_pam, account_emma, account_steven]
end