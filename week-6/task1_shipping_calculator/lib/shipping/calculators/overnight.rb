module Shipping
  class OvernightCalculator < ShippingCalculator
    ShippingCalculator.register_carrier(carrier: :overnight, klass: self)
    
    private
    def compute_base_rate(package)
      package.weight * 3.00
    end

    def apply_surcharges(package)
      surcharge1 = oversized?(package) ? 10.00 : 0.00
      surcharge2 = remote_zone?(package) ? 5.00 : 0.00
      surcharge3 = heavy?(package) ? 8.00 : 0.00
      surcharge1 + surcharge2 + surcharge3
    end

    def apply_discount(package, subtotal)
      0.00
    end
  end
end