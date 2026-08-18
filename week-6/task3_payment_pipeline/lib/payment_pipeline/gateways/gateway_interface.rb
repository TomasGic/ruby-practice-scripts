module PaymentPipeline
  module GatewayInterface
    def charge(amount:, currency:, card_token:)
      raise NotImplementedError, "#{self.class} must implement #charge"
    end
  end
end