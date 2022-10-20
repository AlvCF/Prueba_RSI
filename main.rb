require_relative "./lib/bank"
require_relative "./lib/account"


first_bank = Bank.new("Palencia")

second_bank = Bank.new("La caja")

account_jim = Account.new("Jim Sinclair", first_bank)
account_pam = Account.new("Pam Beesly", first_bank)

account_emma = Account.new("Emma Smith", second_bank)
account_steven = Account.new("Steven Spielberg", second_bank)

puts "50000€ are added to Pam's account"
account_pam.add_money(50000)
puts "30000€ are transfered from Pam's account to Jim's account"
account_pam.make_transfer(account_jim, 30000)

puts "20000€ are transfered from Jim's account to Emma's account using transfer agent"
account_jim.make_transfer_with_agent(account_emma, 20000)

puts "Jim's historic is displayed"
first_bank.show_account_historic(account_jim)


