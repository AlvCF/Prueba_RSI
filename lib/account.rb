class Account
  require_relative 'transfer'

  attr_accessor :account_holder, :money, :bank, :historic
  

  def initialize(account_holder, bank)
    @account_holder = account_holder
    @bank = bank
    @money = 0
    @historic = []
    bank.accounts << self
  end


  def add_money(money)
    self.money += money
  end

  def withdraw_money(money)
    if self.money >= money
      self.money -= money
    end
  end

  def make_transfer(destination_account, money)
    Transfer.new(self, destination_account, money).perform_transfer
  end

  def make_transfer_with_agent(destination_account, money)
    Transfer.new(self, destination_account, money).perform_transfer_with_agent
  end



end