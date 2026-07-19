module PaymentPipeline
  class StripeGateway
    def process_charge(cents:, currency_code:, token:)
      { confirmation: "ST-#{rand(1000)}", ok: true, reason: nil }
    end
  end
end