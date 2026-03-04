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

