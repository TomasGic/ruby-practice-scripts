module Shipping
  class Package
    attr_reader :weight, :length, :width, :height, :zone
    
    def initialize(weight:, length:, width:, height:, zone:)
      @weight = Float(weight)
      @length = Float(length)
      @width = Float(width)
      @height = Float(height)
      @zone = zone

      validate_attributes!
    end

    def validate_attributes!
      if [@weight, @length, @width, @height].any? { |attr| attr <= 0 }
        raise ArgumentError, "Weight and dimensions must be positive!"
      end
    end
  end
end