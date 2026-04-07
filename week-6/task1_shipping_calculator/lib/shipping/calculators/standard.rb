module Shipping
  class StandardCalculator < ShippingCalculator
    
    private
    def compute_base_rate(package)
      package.weight * 0.50
    end

    def apply_surcharges(package)
      oversized?(package) ? 2.00 : 0.00
    end

    def apply_discount(package, subtotal)
      package.weight > 10 ? (subtotal * 0.10) : 0.00
    end
  end
end