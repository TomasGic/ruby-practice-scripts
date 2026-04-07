module Shipping
  class UnknownCarrierError < StandardError; end
  
  class ShippingCalculator
    def self.for(carrier:)
      case carrier
      when :standard then StandardCalculator.new
      when :express then ExpressCalculator.new
      when :overnight then OvernightCalculator.new
      else raise UnknownCarrierError, "Carrier #{carrier} not recognized"
      end
    end

    def calculate(package)
      base_rate = compute_base_rate(package)
      surcharge = apply_surcharges(package)
      subtotal = base_rate + surcharge
      discount = apply_discount(package, subtotal)
      total = subtotal - discount
      build_result(base_rate: base_rate, surcharge: surcharge, discount: discount, total: total)
      
    end

    private 

    def validate_package(package)
      puts "Validating package..."
    end

    def build_result(base_rate:, surcharge:, discount:, total:)
      { 
        base_rate: base_rate,
        surcharge: surcharge,
        discount: discount,
        total: total
      }
    end

    def oversized?(package)
      [package.height, package.width, package.length].any? { |val| val > 100}
    end

    def remote_zone?(package)
      ["remote_a", "remote_b"].include?(package.zone)
    end

    def heavy?(package)
      package.weight > 20
    end
  end
end