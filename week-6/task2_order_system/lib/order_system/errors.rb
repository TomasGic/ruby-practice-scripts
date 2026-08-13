module Orders
  class Error < StandardError; end
  class EmptyOrderError < Error; end
  class AlreadyCompletedError < Error; end
  class InvalidQuantityError < Error; end
  class DuplicateDecoratorError < Error; end
  class InvalidPriceError < Error; end
end

