module PaymentPipeline 
  SUPPORTED_CURRENCIES = ["EUR", "USD", "GBP"]

  class PaymentRequest
    attr_reader :masked_card, :card_number
    
    def initialize(id:, amount:, currency:, card_number:, merchant:, metadata: nil)
      @id = id
      @amount = amount
      @currency = currency.to_s.upcase.strip
      @merchant = merchant.to_s.strip
      @metadata = metadata
      validate!(card_number)
      @card_number = card_number.to_s
      @masked_card = "****#{card_number.to_s.strip[-4..-1]}"
      
    end

    private

    def validate!(card_number)
      raise "Amount must be a positive number" unless @amount > 0
      raise "Currency must be one of #{SUPPORTED_CURRENCIES.join(", ")}" unless SUPPORTED_CURRENCIES.include?(@currency)

      clean_card_number = card_number.to_s.gsub(/\s+/, "")
      raise "Card number must be exactly 16 digits" unless clean_card_number.match(/\A\d{16}\z/)
    end
  end

end