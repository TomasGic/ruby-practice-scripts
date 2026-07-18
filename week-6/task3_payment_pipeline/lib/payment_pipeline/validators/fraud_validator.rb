module PaymentPipeline
  class FraudValidator < BaseValidator
    attr_reader :next_handler
    
    def initialize(blacklist:, next_handler: nil)
      @blacklist = blacklist
      super(next_handler: next_handler)
    end

    def can_validate?(request)
      request.respond_to?(:card_number) && !request.internal_raw_card_number.nil?
    end

    def perform_validation(request)
      if @blacklist.include?(request.internal_raw_card_number)
        { valid: false, error: "Fraudulent card detected", validator: self.class.name.split("::").last}
      else 
        { valid: true }
      end
    end
  end
end