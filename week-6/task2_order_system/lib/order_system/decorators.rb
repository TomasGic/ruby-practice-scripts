module Orders

  class ProductDecorator
    attr_reader :product
    def initialize(product)
      
      if product.respond_to?(:decorated_with?) && product.decorated_with?(self.class)
        raise DuplicateDecoratorError, "#{self.class.name} is already being applied."
      end
      @product = product
    end

    def price
      @product.price
    end

    def name
      @product.name
    end

    def decorated_with?(decorator_class)
      return true if self.instance_of?(decorator_class)
      if self.product.respond_to?(:decorated_with?)
        self.product.decorated_with?(decorator_class)
      else
        return false
      end
    end
  end
  
  class GiftWrapDecorator < ProductDecorator
    
    def price
      @product.price + 4.99
    end

    def name
      "#{@product.name} + Gift Wrap"
    end
  end

  class InsuranceDecorator < ProductDecorator
    
    def price
      @product.price + 9.99
    end

    def name
      "#{product.name} + Insurance"
    end
  end

  class ExpressShippingDecorator < ProductDecorator
    
    def price
      @product.price + 14.99
    end

    def name
      "#{product.name} + Express Shipping"
    end
  end
end