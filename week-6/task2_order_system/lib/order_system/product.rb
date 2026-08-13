module Orders
  class Product
    attr_reader :name, :price
    
    def initialize(name:, price:)
      @name = name
      @price = price
      validate!
    end

    private 
    def validate!
      if @name.nil? || @name.to_s.strip.empty?
        raise ArgumentError, "Product name is required."
      end

      if @price.nil?
        raise InvalidPriceError, "Price is required."
      end

      unless @price.is_a?(Numeric) && @price >= 0
        raise InvalidPriceError, "Price cannot be negative."
      end
    end
  end
end