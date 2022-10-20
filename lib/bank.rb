class Bank

  attr_accessor :name, :accounts

  def initialize(name)
    @name = name
    @accounts = [] 
  end

  def show_name
    return self.name
  end

  def show_account_historic(account)
    historic = @accounts.select{|c| c == account}.first&.historic
    puts historic
  end
end