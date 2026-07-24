module PaymentPipeline 
  SUPPORTED_CURRENCIES = ["EUR", "USD", "GBP"]

  class PaymentRequest
    require 'securerandom'
    
    attr_reader :id, :amount, :currency, :merchant, :metadata, :masked_card 
    
    def initialize(id:, amount:, currency:, card_number:, merchant:, metadata: nil)
      @id = id || SecureRandom.uuid
      @amount = amount
      @currency = currency.to_s.upcase.strip
      @merchant = merchant.to_s.strip
      @metadata = metadata
      validate!(card_number)
      @card_number = card_number.to_s
      @masked_card = "****#{card_number.to_s.strip[-4..-1]}"
      
    end

    def internal_raw_card_number
      @card_number
    end

    private

    def validate!(card_number)
      raise InvalidAmountError, "Amount must be a positive number" unless @amount > 0
      raise InvalidCurrencyError, "Currency must be one of #{SUPPORTED_CURRENCIES.join(", ")}" unless SUPPORTED_CURRENCIES.include?(@currency)

      clean_card_number = card_number.to_s.gsub(/\s+/, "")
      raise InvalidCardError, "Card number must be exactly 16 digits" unless clean_card_number.match(/\A\d{16}\z/)
      if @merchant.empty? || @merchant.nil? 
        raise InvalidMerchantError, "Merchant must be present"
      end
    end
  end

end