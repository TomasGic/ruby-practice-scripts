require "minitest/autorun"
require_relative "../lib/borrowing_service"

class BookTest < Minitest::Test
  def setup
    @book = Book.new(author: "Robert C. Martin", title: "Clean Code")
  end

  def test_that_book_initializes_with_author_and_title
    assert_equal "Robert C. Martin", @book.author
    assert_equal "Clean Code", @book.title
  end

  def test_borrowing_makes_book_unavailable
    @book.borrow
    refute @book.available?
  end

  def test_returning_makes_book_available
    @book.return
    assert @book.available?
  end
  def test_due_date_changes_after_borrowing_and_returning
    @book.borrow
    assert_equal Date.today + 21, @book.due_date
    @book.return
    assert_equal nil, @book.due_date
  end

  def test_borrowing_unavailable_book_raises_error
    @book.borrow
    assert_raises(RuntimeError) { @book.borrow }
  end
end

class MemberTest < Minitest::Test
  def setup
    @member = Member.new(first_name: "Tomas", last_name: "Gic")
    @book = Book.new(author: "Robert C. Martin", title: "Clean Code")
    @loan = Loan.new(item: @book, member: @member)
  end

  def test_member_initializes_with_full_name
    assert_equal "Tomas Gic", @member.full_name
  end

  def test_member_initializes_with_empty_loans_array
    assert_empty @member.active_loans
  end

  def test_registering_new_loan_adds_loan_object_into_active_loans
    @member.register_loan(@loan)
    assert_includes @member.active_loans, @loan
  end

  def test_viewing_active_loans
    @member.register_loan(@loan)
    due_date = (Date.today + 21).to_s
    output = ["Loan ID: #{@loan.id}, title: #{@book.title}, due date: #{due_date}"]
    assert_equal output, @member.view_active_loans
  end

  def test_viewing_active_loans_if_no_active_loans_present
    assert_equal "No active loans", @member.view_active_loans
  end
  
  def test_removing_loan_from_active_loans
    @member.register_loan(@loan)
    @member.remove_loan(@book)
    refute_includes @member.active_loans, @loan
  end
end

class BorrowingServiceTest < Minitest::Test
  def setup
    @member = Member.new(first_name: "Tomas", last_name: "Gic")
    @book = Book.new(author: "Robert C. Martin", title: "Clean Code")
    @book_loan = BorrowingService.borrow_item(item: @book, member: @member)
    @dvd = DVD.new(director: "Sam Mendez", title: "Spectre", release_year: "2015")
    @dvd_loan = BorrowingService.borrow_item(item: @dvd, member: @member)
  end

  def test_checkout_makes_item_unavailable
    refute @book.available?
    refute @dvd.available?
  end
  
  def test_checkout_adds_loan_object_to_active_loans
    assert_includes @member.active_loans, @book_loan, @dvd_loan
  end

  def test_checkin_removes_loan_object_from_active_loans
    BorrowingService.return_item(@book_loan)
    BorrowingService.return_item(@dvd_loan)
    refute_includes @member.active_loans, @book_loan, @dvd_loan
  end

  def test_checkin_makes_item_available_again_and_resets_due_date
    BorrowingService.return_item(@book_loan)
    BorrowingService.return_item(@dvd_loan)
    assert @book.available?
    assert @dvd.available?
    assert_nil @book.due_date
    assert_nil @dvd.due_date
  end

  def test_member_cannot_have_too_many_active_loans
    @member = Member.new(first_name: "Lucas", last_name: "Gic")
    15.times do
      book = Book.new(author: "Robert C. Martin", title: "Clean Code")
      BorrowingService.borrow_item(item: book, member: @member)
    end
    extra_book = Book.new(author: "Robert C. Martin", title: "Clean Architecture")
    
    assert_raises(RuntimeError) { BorrowingService.borrow_item(item: extra_book, member: @member) }
    
  end
end
