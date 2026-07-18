module PaymentPipeline
  class LimitValidator < BaseValidator
    def initialize(limit: 10000, next_handler: nil)
      @limit = limit
      super(next_handler: next_handler)
    end

    def can_validate?(request)
      true
    end

    def perform_validation(request)
      if request.amount > @limit
        { valid: false, error: "Validation failed: Limit exceeded", validator: self.class.name.split("::").last }
      else
        { valid: true }
      end
    end
  end
end