module Orders
  class EmptyOrderError < StandardError; end
  class AlreadyCompletedError < StandardError; end
  class InvalidQuantityError < StandardError; end
  
  class Order
    attr_reader :items, :completed

    def initialize
      @items = []
      @completed = false
    end

    def add_item(product:, quantity:)
      raise InvalidQuantityError, "Quantity cannot be negative or zero" if quantity <= 0
      raise AlreadyCompletedError, "Cannot add items to already completed order" if @completed
      item = { product_name: product.name, count: quantity, total_price: product.price * quantity }
      @items << item
    end

    def total
      sum_total = 0
      @items.each do |item|
        sum_total += item[:total_price]
      end
      sum_total
    end

    def item_count
      count = 0
      @items.each do |item|
        count += item[:count]
      end
      count
    end

    def complete!
      raise EmptyOrderError, "Order cannot be empty" if @items.empty?
      raise AlreadyCompletedError, "Order has already been completed" if @completed
      @completed = true
    end
  end
end