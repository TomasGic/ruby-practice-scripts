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

