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
    assert_equal 0, @member.active_loans.length
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
    assert_empty @member.active_loans
  end
end

