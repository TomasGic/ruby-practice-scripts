require "securerandom"
require "date"

# Base class to represent all borrowable items
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
    21 # max loan period for books is 21 days
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
    3 # max loan period for dvds is 3 days
  end
end


class Member
  attr_reader :full_name, :active_loans
  def initialize(first_name:, last_name:)
    @full_name = "#{@first_name} #{@last_name}"
    @id = SecureRandom.uuid
    @active_loans = []
  end

  def register_loan(loan)
    @active_loans << loan
  end

  def view_active_loans
    if @active_loans.empty?
      "No active loans"
    else 
      @active_loans.map { |loan| p loan.to_s}
    end
    
  end

  def remove_loan(item)
    @active_loans.delete_if { |loan| loan.item == item}
  end
end

# Combines item and member data to represent what is owed and by who
class Loan
  attr_reader :item, :member, :id

  def initialize(item:, member:)
    @item = item
    @member = member
    @id = SecureRandom.uuid
  end

  # we define how we want our loan object to be displayed when printed to the terminal
  def to_s
    "Loan ID: #{@id}, title: #{@item.title}, due date: #{@item.due_date}"
  end
end

class BorrowingService
  MAX_LOAN_LIMIT = 15 # member can have maximum 15 items on loan at a time
  
  def self.borrow_item(item:, member:)
    ensure_loan_limit_not_exceeded(member: member)
    loan = Loan.new(item: item, member: member)
    item.borrow
    member.register_loan(loan)
    loan
  end

  def self.return_item(loan)
    item = loan.item
    member = loan.member
    item.return
    member.remove_loan(item)
  end

  private 

  def self.ensure_loan_limit_not_exceeded(member:)
    if member.active_loans.size >= MAX_LOAN_LIMIT
      raise RuntimeError, "Cannot have more than #{MAX_LOAN_LIMIT} items on loan"
    end
  end
end


