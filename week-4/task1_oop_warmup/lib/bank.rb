class AccountOwner
  attr_reader :name
  
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @full_name = first_name + " " + last_name
  end
end

class BankAccount
  attr_reader :owner, :balance
  def initialize(owner:, balance:)
    @owner = owner

    validate_initial_balance!(balance)
    @balance = balance 
  end

  def deposit_amount(amount)
    @balance += amount
  end

  def withdraw_amount(amount)
    raise RuntimeError, "Account cannot go into overdraft" if is_overdrawn?(amount)
    raise RuntimeError, "Cannot withdraw more than 500" if withdrawal_greater_than_500?(amount)
    @balance -= amount
  end

  private 

  def is_overdrawn?(withdrawal_amount)
    withdrawal_amount > @balance 
  end

  def withdrawal_greater_than_500?(withdrawal_amount)
    withdrawal_amount > 500
  end

  def validate_initial_balance!(balance)
    raise ArgumentError, "Initial balance cannot be negative" if balance < 0
  end
end





