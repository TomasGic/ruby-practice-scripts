module Shipping
  class InvalidPackageError < StandardError; end
  
  class Package
    VALID_ZONES = %w[urban remote_a remote_b].freeze
    
    attr_reader :weight, :length, :width, :height, :zone
    
    def initialize(weight: nil, length: nil, width: nil, height: nil, zone: nil)
      begin
        @weight, @length, @width, @height = [weight, length, width, height].map do |val|
          Float(val)
        end
      rescue ArgumentError, TypeError
        raise InvalidPackageError, "Weight and dimensions must be numeric"
      end

      @zone = zone.to_s.strip.downcase
      
      validate!
    end

    def validate!
      if [@weight, @length, @width, @height].any? { |attr| attr <= 0 }
        raise InvalidPackageError, "Weight and/or dimensions cannot be negative or zero!"
      end
      if @zone.nil? || @zone.empty?
        raise InvalidPackageError, "Zone is required"
      end
      unless VALID_ZONES.include?(@zone) 
        raise InvalidPackageError, "Zone must be one of #{VALID_ZONES}.join(", ")."
      end
    end
  end
end