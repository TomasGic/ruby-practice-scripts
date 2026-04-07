module Shipping
  class ExpressCalculator < ShippingCalculator
    
    private
    def compute_base_rate(package)
      package.weight * 1.20
    end

    def apply_surcharges(package)
      surcharge1 = oversized?(package) ? 5.00 : 0.00
      surcharge2 = remote_zone(package) ? 3.00 : 0.00
      surcharge1 + surcharge2
    end

    def apply_discount(package, subtotal)
      package.weight > 5 ? (subtotal * 0.05) : 0.00
    end
  end
end