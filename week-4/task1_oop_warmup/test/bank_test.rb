require "minitest/autorun"
require_relative "../lib/bank"

class BankAccountTest < Minitest::Test
  def setup
    @owner = AccountOwner.new(first_name: "Tomas", last_name: "Gic")
    @account = BankAccount.new(owner: @owner, balance: 2000)
  end

  def test_error_is_rased_when_initial_balance_is_passed_as_string
    error = assert_raises(ArgumentError) { BankAccount.new(owner: @owner, balance: "2000") }
    assert_equal "Balance has to be a number", error.message
  end

  def test_account_has_initial_balance 
    assert_equal 2000, @account.balance
  end

  def test_account_cannot_initialize_with_negative_balance
    assert_raises(ArgumentError) { BankAccount.new(owner: @owner, balance: -10) }
  end

  def test_deposit_increases_balance
    @account.deposit_amount(200)
    assert_equal 2200, @account.balance
  end

  def test_withdraw_decreases_balance
    @account.withdraw_amount(200)
    assert_equal 1800, @account.balance
  end

  def test_account_cannot_overdraw
    assert_raises(RuntimeError) { @account.withdraw_amount(3000)}
  end

  def test_cannot_withdraw_more_than_limit
    assert_raises(RuntimeError) { @account.withdraw_amount(550) }
  end

  def test_user_can_view_balance
    assert_output("Current balance is $2000.00.\n") { @account.display_balance }
  end
end


class CreditCardTest < Minitest::Test
  def setup
    @owner = AccountOwner.new(first_name: "Tomas", last_name: "Gic")
    @account = BankAccount.new(owner: @owner, balance: 3000)
    @credit_card = CreditCard.new(owner: @owner, account: @account, limit: 2500)
  end

  def test_card_initializes_with_0_balance
    assert_equal 0, @credit_card.balance
  end

  def test_charging_card_increases_balance
    assert_equal 200, @credit_card.charge(200)
  end

  def test_user_can_make_payment_from_checking_account
    @credit_card.charge(200)
    @credit_card.make_payment(account: @account, amount: 200)
    assert_equal 2800, @account.balance
    assert_equal 0, @credit_card.balance
  end

  def test_card_balance_cannot_exceed_limit
    @credit_card.charge(2000)
    assert_raises(RuntimeError) { @credit_card.charge(600) }
  end

  def test_user_can_display_credit_card_balance
    assert_output("Current balance is $0.00.\n") { @credit_card.display_balance }
  end
end

