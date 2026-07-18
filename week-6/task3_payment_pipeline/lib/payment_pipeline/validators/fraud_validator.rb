module PaymentPipeline
  class FraudValidator < BaseValidator
    attr_reader :next_handler
    
    def initialize(blacklist:, next_handler: nil)
      @blacklist = blacklist
      super(next_handler: next_handler)
    end

    def can_validate?(request)
      request.respond_to?(:card_number) && !request.card_number.nil?
    end

    def perform_validation(request)
      if @blacklist.include?(request.card_number)
        { valid: false, error: "Fraudulent card detected", validator: self.class.name}
      else 
        { valid: true }
      end
    end
  end
end