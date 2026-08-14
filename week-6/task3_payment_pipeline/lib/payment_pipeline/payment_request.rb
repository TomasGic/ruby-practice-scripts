module PaymentPipeline 
  SUPPORTED_CURRENCIES = ["EUR", "USD", "GBP"]

  class PaymentRequest
    require 'securerandom'
    require 'digest'
    
    attr_reader :id, :amount, :currency, :merchant, :metadata, :masked_card 
    
    def initialize(id: nil, amount:, currency:, card_number:, merchant:, metadata: nil)
      @id = id || SecureRandom.uuid
      @amount = amount
      @currency = currency.to_s.upcase.strip
      @merchant = merchant.to_s.strip
      @metadata = metadata
      @card_number = card_number.to_s.gsub(/\s+/, "")
      validate!
      @masked_card = "****#{@card_number.strip[-4..-1]}"
      
    end

    def card_fingerprint
      Digest::SHA256.hexdigest(@card_number)
    end

    private

    attr_reader :card_number

    def validate!
      raise InvalidAmountError, "Amount must be a positive number" unless @amount > 0
      raise InvalidCurrencyError, "Currency must be one of #{SUPPORTED_CURRENCIES.join(", ")}" unless SUPPORTED_CURRENCIES.include?(@currency)
      raise InvalidCardError, "Card number must be exactly 16 digits" unless @card_number.match(/\A\d{16}\z/)
      if @merchant.nil? || @merchant.empty? 
        raise InvalidMerchantError, "Merchant must be present"
      end
    end
  end

end