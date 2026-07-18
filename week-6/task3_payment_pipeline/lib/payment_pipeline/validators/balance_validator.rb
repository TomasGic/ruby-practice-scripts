module PaymentPipeline
  class BalanceValidator < BaseValidator
    def initialize(balance:, next_handler: nil)
      @balance = balance
      super(next_handler: next_handler)
    end

    def can_validate?(request)
      true
    end

    def perform_validation(request)
      if request.amount > @balance
        { valid: false, error: "Validation failed: Insufficient funds", validator: self.class.name }
      else 
        { valid: true }
      end
    end
  end
end