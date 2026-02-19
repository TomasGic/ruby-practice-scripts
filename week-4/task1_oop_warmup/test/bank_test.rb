require "minitest/autorun"
require_relative "../lib/bank"

class BankAccountTest < Minitest::Test
  def setup
    @owner = AccountOwner.new("Tomas", "Gic")
    @account = BankAccount.new(owner: @owner, balance: 2000)
  end

  def test_account_has_initial_balance 
    assert_equal 2_000, @account.balance
  end

  def test_account_cannot_initialize_with_negative_balance
    assert_raises(ArgumentError) { BankAccount.new(owner: "Tomas Gic", balance: -10) }
  end

  def test_deposit_increases_balance
    @account.deposit_amount(200)
    assert_equal 2_200, @account.balance
  end

  def test_withdraw_decreases_balance
    @account.withdraw_amount(200)
    assert_equal 1_800, @account.balance
  end

  def test_account_cannot_overdraw
    assert_raises(RuntimeError) { @account.withdraw_amount(3_000)}
  end

  def test_cannot_withdraw_more_than_500
    assert_raises(RuntimeError) { @account.withdraw_amount(550) }
  end
end


class CreditCardTest < Minitest::Test
  def setup
    @owner = AccountOwner.new("Tomas", "Gic")
    @account = BankAccount.new(owner: @owner, balance: 3_000)
    @credit_card = CreditCard.new(owner: @owner, account: @account, limit: 2_500)
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
end

