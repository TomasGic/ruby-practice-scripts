# A small banking system
A Ruby implementation of a small banking system using OOP principles. 

## Running tests
from this folder run the following command in your terminal: 

    test/bank_test.rb

## Usage (example scenario)

    owner = AccountOwner.new(first_name: "Tomas", last_name: "Gic")
    account = BankAccount.new(owner: owner, balance: 2000)
    credit_card = CreditCard.new(owner: owner, account: account, limit: 2500)
    
    account.deposit_amount(3000)
    account.display_balance
    credit_card.display_balance

    credit_card.charge(540)
    credit_card.display_balance

    credit_card.make_payment(account: account, amount: 500)
    credit_card.display_balance

## Design overview

The project contains 3 classes:
 - AccountOwner: represents the owner of a bank account (bank customer)
 - BankAccount: represents the primary funds and is linked to an account owner(bank customer)
 - CreditCard: represents the credit card which is linked to a particular bank         customer and their bank account. 

 ## Domain rules
 - The account holder cannot withdraw more than 500 at one time. 
 - The credit card is linked to 1 specific account holder and 1 specific bank account. 
 - The credit card holder can make payments from their primary account to reduce credit card balance 
 - The bank account cannot go into overdraft (balance cannot be < 0)

## Edge cases covered
 - initializing the bank account with a negative balance raises an error
 - initializing the bank account with a balance as a string will coerce the balance into a float 
 - charging the credit card with 0 or negative amount raises an error
 - trying to withdraw an amount from the bank account that is greater than the balance will raise an error
 