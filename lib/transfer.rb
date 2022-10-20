class Transfer

  attr_accessor :origin_account, :destination_account, :money

  LIMIT = 1000

  def initialize(origin_account, destination_account, money)
    @origin_account = origin_account
    @destination_account = destination_account
    @money = money
  end

  def perform_transfer
    origin_account.bank == destination_account.bank ? intra_transfer : inter_transfer
  end

  def perform_transfer_with_agent
    transfer_agent
  end

  private

    def intra_transfer(money_to_exchange = money)
      if destination_account.bank == origin_account.bank
        if money_to_exchange <= origin_account.money
          change_balances(money_to_exchange)
          add_historic("Intra bank", true, money_to_exchange)
          puts "Transfer successfully completed"
        else
          puts "Insufficient balance to complete the transaction"
        end
      else
        puts "The destination customer does not belong to your bank. Please make an external transfer"
      end
    end

    def inter_transfer(money_to_exchange = money)
      if destination_account.bank != origin_account.bank
        if money_to_exchange <= (origin_account.money - 5)
          if money_to_exchange <= 1000
            origin_account.money -= 5
            if rand(100) < 70
              change_balances(money_to_exchange)
              add_historic("Inter bank", true, money_to_exchange)
              puts "Transfer successfully completed"
              true
            else
              add_historic("Inter bank", false, money_to_exchange)
              puts "The transfer has failed"
              false
            end
          else
            puts "The limit for external transfers is €1000"
          end
        else
          puts "Insufficient balance to complete the transaction"
        end
      else
        puts "The destination customer belongs to the same bank as you. Please make an internal transfer"
      end
    end

    def transfer_agent
      num_initial_attempts = (money.to_f/LIMIT).ceil
      approximate_number_attempts = attempts_calculation(num_initial_attempts, 0.7)

      if origin_account.money > (money + (approximate_number_attempts * 5))
        cont = 1
        while cont <= (num_initial_attempts)
          if cont == num_initial_attempts
            if money%LIMIT != 0
              if inter_transfer(money%LIMIT)
                cont += 1
              end
            else 
              if inter_transfer(LIMIT)
                cont += 1
              end
            end
          else
            if inter_transfer(LIMIT)
              cont += 1
            end
          end
        end
      else
        puts "Not enough money is available for the operation to be carried out with sufficient certainty."
      end
    end


    def params_as_json(transfer_type, success, money_to_exchange = money)
      {origin_account: origin_account.account_holder,
       destination_account: destination_account.account_holder,
       transfer_type: transfer_type,
       success: success,
       money: money_to_exchange}
    end

    def add_historic(transfer_type, success, money_to_exchange = money)
      origin_account.historic << params_as_json(transfer_type, success, money_to_exchange)
      destination_account.historic << params_as_json(transfer_type, success, money_to_exchange)
    end

    def change_balances(money_to_exchange = money)
      destination_account.money += money_to_exchange
      origin_account.money -= money_to_exchange
    end

    # The methods below are used to calculate the number of attempts needed at the transfer agent to 
    # ensure greater than 99% certainty of being able to complete the transaction.
    def attempts_calculation(required, probability)
      margin = 0.99
      cont = required 
      final_prob = 0.0
      while final_prob < margin
        final_prob = complementary_binomial(20,cont,probability)
        cont += 1
      end

      cont
    end

    def complementary_binomial(required_attempts, total_attempts, probability)
      cont = 0.0
      (0..required_attempts).each do |a| 
        cont += combinations(total_attempts, a) * probability**a *(1-probability)**(total_attempts-a)
      end
      1-cont
    end

    def combinations(x,y)
      factorial(x) / (factorial(y) * factorial(x-y))
    end

    def factorial(x)
      (1..x).inject(:*) || 1
    end

end