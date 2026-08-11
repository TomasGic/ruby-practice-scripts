module PaymentPipeline
  class BalanceValidator < BaseValidator
    def initialize(balance:, next_handler: nil)
      @balance = balance
      super(next_handler: next_handler)
    end

    def can_validate?(request)
      request.respond_to?(:amount) && !request.amount.nil?
    end

    def perform_validation(request)
      if request.amount > @balance
        { valid: false, error: "Validation failed: Insufficient funds", validator: self.class.name.split("::").last }
      else 
        { valid: true }
      end
    end
  end
end