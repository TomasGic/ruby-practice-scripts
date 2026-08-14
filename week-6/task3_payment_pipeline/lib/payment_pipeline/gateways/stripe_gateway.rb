module PaymentPipeline
  class StripeGateway
    require 'securerandom'
    def process_charge(cents:, currency_code:, token:)
      { id: "ch-#{SecureRandom.hex(6)}", status: "succeeded", error: nil }
    end
  end
end