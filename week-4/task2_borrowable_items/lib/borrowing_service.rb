require "securerandom"
require "date"

class Item
  attr_reader :title, :due_date, :id
  def initialize(title:)
    @title = title
    @id = SecureRandom.uuid
    @available = true
    @due_date = nil
  end

  def borrow
    ensure_available
    @available = false
    @due_date = Date.today + self.loan_period
  end

  def available?
    @available
  end

  def return
    @available = true
    @due_date = nil
  end

  private

  def ensure_available
    raise RuntimeError, "Item is on loan" unless @available
  end
end

class Book < Item
  attr_reader :author
  def initialize(author:, title:)
    @author = author
    super(title: title)
  end

  def loan_period
    21
  end
  
end

class DVD < Item
  attr_reader :director, :release_year
  def initialize(director:, title:, release_year:)
    @director = director
    super(title: title)
    @release_year = release_year
  end

  def loan_period
    3
  end
end

