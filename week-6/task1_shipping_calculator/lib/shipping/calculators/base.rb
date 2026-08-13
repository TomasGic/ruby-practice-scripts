module Shipping
  class UnknownCarrierError < StandardError; end
  
  class ShippingCalculator
    include Loggable

    def self.registry
      @registry ||= {}
    end

    def self.register_carrier(carrier:, klass: self)
      carrier = carrier.to_s.strip.downcase.to_sym
      registry[carrier] = klass
    end
    
    def self.for(carrier:)
      carrier = carrier.to_s.strip.downcase.to_sym
      klass = registry[carrier]
      raise UnknownCarrierError, "Carrier #{carrier} not recognized" unless klass
      klass.new
    end

    def currency
      "$"
    end

    def calculate(package)
      
      log validate_package(package)
      
      base_rate = compute_base_rate(package)
      log "Base rate: #{currency}#{'%.2f' % base_rate}"
      
      surcharge = apply_surcharges(package)
      log(surcharge > 0 ? "Surcharge: #{currency}#{'%.2f' % surcharge}" : "No surcharges applied")
      
      subtotal = base_rate + surcharge
      discount = apply_discount(package, subtotal)
      log(discount > 0 ? "Discount: #{currency}#{'%.2f' % discount}" : "No discount applied")
      
      total = (subtotal - discount).round(2)
      log("Total: #{currency}#{'%.2f' % total}")
      build_result(base_rate: base_rate, surcharge: surcharge, discount: discount, total: total)
      
    end

    private 

    def validate_package(package)
      "Validating package: #{package.weight}kg, zone: #{package.zone}"
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