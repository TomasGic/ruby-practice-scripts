module Shipping
  class InvalidPackageError < StandardError; end
  
  class Package
    attr_reader :weight, :length, :width, :height, :zone
    
    def initialize(weight: nil, length: nil, width: nil, height: nil, zone: nil)
      begin
        @weight, @length, @width, @height = [weight, length, width, height].map do |val|
          Float(val)
        end
      rescue ArgumentError, TypeError
        raise InvalidPackageError, "Weight and dimensions must be numeric"
      end

      @zone = zone
      
      validate!
    end

    def validate!
      if [@weight, @length, @width, @height].any? { |attr| attr <= 0 }
        raise InvalidPackageError, "Weight and/or dimensions cannot be negative or zero!"
      end
      if @zone.nil? || @zone.to_s.strip.empty?
        raise InvalidPackageError, "Zone is required"
      end
    end
  end
end