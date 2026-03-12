class AccountOwner
  attr_reader :first_name, :last_name, :full_name
  
  def initialize(first_name: , last_name:)
    @first_name = first_name
    @last_name = last_name
    @full_name = "#{first_name} #{last_name}"
  end
end

class BankAccount
  WITHDRAWAL_LIMIT = 500
  
  attr_reader :owner, :balance
  def initialize(owner:, balance:)
    @owner = owner

    validate_initial_balance!(balance)
    @balance = balance.to_f 
  end

  def display_balance
    puts "Current balance is $#{'%.2f' % @balance}."
  end
  
  def deposit_amount(amount)
    validate_amount(amount)
    @balance += amount
  end

  def withdraw_amount(amount)
    validate_amount(amount)
    # note: when account is in overdraft/overdrawn it has a negative balance
    raise OverdraftError, "Account cannot go into overdraft" if overdrawn?(amount)
    raise WithdrawalLimitError, "Cannot withdraw more than #{WITHDRAWAL_LIMIT}" if withdrawal_exceeds_limit?(amount)
    @balance -= amount
  end

  private 

  def overdrawn?(withdrawal_amount)
    withdrawal_amount > @balance 
  end

  def withdrawal_exceeds_limit?(withdrawal_amount)
    withdrawal_amount > WITHDRAWAL_LIMIT
  end

  def validate_initial_balance!(balance)
    raise ArgumentError, "Balance has to be a number" unless balance.is_a?(Numeric)
    raise ArgumentError, "Initial balance cannot be negative" if balance < 0
  end

  def validate_amount(amount)
    raise ArgumentError, "Amount has to a positive number" unless amount.is_a?(Numeric) && amount > 0
  end
end


class CreditCard
  attr_reader :owner, :account, :limit, :balance
  
  def initialize (owner:, account:, limit:)
    @owner = owner
    @account = account
    @limit = limit
    @balance = 0.0 
  end

  def display_balance
    puts "Current balance is $#{'%.2f' % @balance}."
  end
  
  def charge(amount)
    # verify that amount the card is charged with does not exceed limit and is not negative
    validate_transaction(amount)
    @balance += amount
  end

  # credit card holder can make payment from his linked account to reduce debt
  def make_payment(amount:)
    @account.withdraw_amount(amount)
    @balance -= amount
  end

  private

  def validate_transaction(amount)
    raise CreditCardLimitError, "Transaction declined. Card limit exceeded!" if amount + @balance > @limit
    raise ArgumentError, "Card cannot be charged with negative amount or 0" if amount <= 0
  end
end

class OverdraftError < StandardError; end
class WithdrawalLimitError < StandardError; end
class CreditCardLimitError < StandardError; end
