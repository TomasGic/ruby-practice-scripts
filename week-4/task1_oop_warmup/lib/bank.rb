class AccountOwner
  attr_reader :first_name, :last_name, :full_name
  
  def initialize(first_name: , last_name:)
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

  def display_balance
    puts "Current balance is $#{'%.2f' % @balance}."
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


class CreditCard
  attr_reader :owner, :account, :limit, :balance
  
  def initialize (owner:, account:, limit:)
    @owner = owner
    @account = account
    @limit = limit
    @balance = 0
  end

  def display_balance
    puts "Current balance is $#{'%.2f' % @balance}."
  end
  
  def charge(amount)
    validate_transaction(amount)
    @balance += amount
  end

  def make_payment(account:, amount:)
    account.withdraw_amount(amount)
    @balance -= amount
  end

  private

  def validate_transaction(amount)
    raise RuntimeError, "Transaction declined. Card limit exceeded!" if amount + @balance > @limit
    
  end
end


owner = AccountOwner.new(first_name: "Tomas", last_name: "Gic")
account = BankAccount.new(owner: owner, balance: 2000)
credit_card = CreditCard.new(owner: owner, account: account, limit: 2500)

account.deposit_amount(3000)
account.display_balance

