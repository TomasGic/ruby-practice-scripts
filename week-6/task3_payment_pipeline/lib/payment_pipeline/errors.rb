module PaymentPipeline
  class Error < StandardError; end

  class ValidationError < Error; end
  class InvalidAmountError < ValidationError; end
  class InvalidCurrencyError < ValidationError; end
  class InvalidCardError < ValidationError; end
  class InvalidMerchantError < ValidationError; end

  class GatewayError < Error; end
  class GatewayTimeoutError < GatewayError; end
  class GatewayRejectionError < GatewayError; end

  class ConfigurationError < Error; end
  class UnknownProviderError < ConfigurationError; end
end