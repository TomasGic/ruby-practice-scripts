## Borrowing Service

A Ruby implentation of a small borrowing system that models borrowing of books and dvds (borrowable items) using the OOP principles.

# Running tests

from this folder run the following command in your terminal:


    test/borrowing_service.rb

# Example usage 

member = Member.new(first_name: "Tomas", last_name: "Gic")
book = Book.new(author: "Robert C. Martin", title: "Clean Code")

loan = BorrowingService.borrow_item(item: book, member: member)
BorrowingService.return_item(loan)

# Design overview

The project contains the following classes:
- Book, DVD, Item - represent the borrowable items. Book and DVD are subclasses that inherit the behaviour from the parent class Item.
- Member - represents the person who can borrow items and can track active loans
- Loan - represents the act of borrowing a borrowable item and tracks which member borrowed which item. 
- BorrowingService - represents the orchestrator that coordinates the act of borrowing and returning items

# Domain rules

- A member can have maximum of 15 active loans
- Borrowing an item will change its availability state making it impossible to be borrowed twice (an error will be raised when trying to borrow an unavailable item)
- returning an item will make it available again

# Edge cases covered
- borrowing an unavailable item
- having too many active loans
